/// obj_debug — ferramentas de debug do MineIdle
// Só existe na configuração "debug" (DEBUG_MODE). No build normal ele se destrói
// na hora e não custa nada.
//
// ATALHOS
//   Tab ............ painel completo (overlay do GameMaker)
//   F1 ............. monitor de desempenho (FPS, frametime, instâncias)
//   F2 ............. hitboxes + linha de mineração
//   F3 ............. info dos blocos (grade, margens, tooltip do bloco no mouse)
//   F4 ............. mapa da mina (clique no mapa = teleporta)
//   F5 ............. noclip
//   F6 ............. stamina infinita
//   F7 ............. sem escuridão
//   F8 ............. câmera lenta (60 <-> 15 fps; timers feitos com FPS continuam em tempo real)
//   F9 ............. screenshot
//   Ctrl + T ....... teleporta o player pro mouse

//inicializadas antes do guard porque o CleanUp usa elas
painel_view  = -1;
mapa_surface = -1;

if (!DEBUG_MODE)
{
    instance_destroy();
    exit;
}

depth = -99999;



#region Estado (variáveis de instância — os checkboxes do painel apontam pra elas)

    //visualização
    mostra_monitor      = false;
    mostra_hitbox       = false;
    mostra_linha        = false;
    mostra_info_player  = false;
    mostra_grade        = false;
    mostra_tooltip      = false;
    mostra_vida_blocos  = false;
    mostra_mapa         = false;
    mostra_chances      = false;
    mostra_log          = true;

    //cheats
    noclip              = false;
    stamina_infinita    = false;
    mochila_infinita    = false;
    sem_escuridao       = false;
    velocidade_jogo     = 60;

    //guardando o estado anterior pra só agir quando mudar
    noclip_anterior     = false;
    mochila_anterior    = false;
    mochila_max_salvo   = 0;

    //picareta
    nivel_picareta_dbg      = global.nivel_picareta;
    nivel_picareta_anterior = global.nivel_picareta;

    //texto do estado do player (atualizado só com o painel aberto)
    estado_player_txt   = "-";

    //a origem do sprite dos blocos não é o canto (x do bloco = centro)
    bloco_ox = sprite_get_xoffset(spr_blocos);
    bloco_oy = sprite_get_yoffset(spr_blocos);

    //array vazia reaproveitada pelo noclip (não cria uma nova todo frame)
    colisoes_vazias = [];

    //salas que aparecem nos botões
    salas_debug = [rm_vila, rm_mina, rm_shop, rm_shop_picareta, rm_upgrade, rm_refinacao];

    //escala do texto na GUI (a GUI é 1920x1080)
    txt_escala = 1.5;

#endregion

#region Monitor de desempenho

    //frametime (amostras circulares, sem alocar nada por frame)
    #macro DBG_AMOSTRAS 120
    frametimes      = array_create(DBG_AMOSTRAS, 0);
    ft_indice       = 0;
    ft_medio        = 0;
    ft_max          = 0;
    fps_real_suave  = 0;

    //contagens (atualizadas 2x por segundo, não todo frame)
    n_instancias    = 0;
    n_minerio       = 0;
    n_drop          = 0;
    n_tween         = 0;
    n_sombra        = 0;
    top_objetos     = [];

    //blocos criados por segundo (pega o "pisca-pisca" das bordas da mina)
    ultimo_id_bloco      = -1;
    blocos_criados_acum  = 0;
    blocos_criados_seg   = 0;

    //timers em milissegundos (não dependem da velocidade do jogo)
    t_contagem  = 0;
    t_segundo   = 0;
    t_ft        = 0;

    atualiza_monitor = function()
    {
        //guardando o frametime deste frame
        frametimes[ft_indice] = delta_time / 1000;
        ft_indice = (ft_indice + 1) mod DBG_AMOSTRAS;
        fps_real_suave = lerp(fps_real_suave, fps_real, .05);

        conta_blocos_criados();

        //média e pico do frametime (4x por segundo)
        if (current_time - t_ft >= 250)
        {
            t_ft = current_time;

            var _soma = 0, _max = 0;
            for (var i = 0; i < DBG_AMOSTRAS; i++)
            {
                var _ft = frametimes[i];
                _soma += _ft;
                if (_ft > _max) _max = _ft;
            }
            ft_medio = _soma / DBG_AMOSTRAS;
            ft_max   = _max;
        }

        //blocos criados no último segundo
        if (current_time - t_segundo >= 1000)
        {
            t_segundo = current_time;
            blocos_criados_seg  = blocos_criados_acum;
            blocos_criados_acum = 0;
        }

        //contagem de instâncias (2x por segundo)
        if (current_time - t_contagem >= 500)
        {
            t_contagem = current_time;
            conta_instancias();
        }
    }

    conta_blocos_criados = function()
    {
        //os ids das instâncias só crescem, então todo bloco com id maior que
        //o maior que já vimos foi criado agora
        var _ref    = ultimo_id_bloco;
        var _maior  = _ref;
        var _novos  = 0;

        with (obj_minerio)
        {
            var _n = real(id);
            if (_n > _ref)
            {
                _novos++;
                if (_n > _maior) _maior = _n;
            }
        }

        //no primeiro frame só marca a referência
        if (_ref >= 0) blocos_criados_acum += _novos;
        ultimo_id_bloco = _maior;
    }

    conta_instancias = function()
    {
        n_instancias = instance_count;
        n_minerio    = instance_number(obj_minerio);
        n_drop       = instance_number(obj_drop);
        n_tween      = instance_number(obj_tween);
        n_sombra     = instance_number(obj_sombra);

        //top objetos por quantidade
        var _cont = {};
        with (all)
        {
            var _nome = object_get_name(object_index);
            _cont[$ _nome] = (_cont[$ _nome] ?? 0) + 1;
        }

        var _nomes = struct_get_names(_cont);
        var _lista = array_create(array_length(_nomes));
        for (var i = 0; i < array_length(_nomes); i++)
        {
            _lista[i] = {nome: _nomes[i], qtd: _cont[$ _nomes[i]]};
        }
        array_sort(_lista, function(_a, _b) { return _b.qtd - _a.qtd; });

        array_resize(_lista, min(6, array_length(_lista)));
        top_objetos = _lista;
    }

    reseta_monitor = function()
    {
        ultimo_id_bloco     = -1;
        blocos_criados_acum = 0;
        blocos_criados_seg  = 0;
    }

#endregion

#region Log na tela

    log_linhas = [];
    #macro DBG_LOG_MAX 8
    #macro DBG_LOG_TEMPO 6000

    adiciona_log = function(_texto)
    {
        array_push(log_linhas, {texto: _texto, t: current_time});
        if (array_length(log_linhas) > DBG_LOG_MAX) array_delete(log_linhas, 0, 1);
    }

#endregion

#region Mapa da mina

    mapa_sujo    = true;
    t_mapa       = 0;
    cores_mapa   = {};

    //posição e tamanho do mapa na GUI
    mapa_cel = 14;
    mapa_x   = 260;
    mapa_y   = 1080 - (MAX_LINHAS * 14) - 30;

    na_mina = function()
    {
        return array_contains(global.rooms_mina, room) && array_length(global.blocos_struct) > 0;
    }

    cor_do_bloco = function(_tipo)
    {
        if (_tipo == undefined) return make_colour_rgb(30, 30, 40);  //ainda não gerado
        if (_tipo == "vazio")   return c_black;                      //quebrado

        //cache das cores pra não procurar toda vez
        var _cor = cores_mapa[$ _tipo];
        if (_cor == undefined)
        {
            var _dados = global.minerios[$ _tipo];
            _cor = (_dados != undefined && is_numeric(_dados.cor)) ? _dados.cor : c_fuchsia;
            cores_mapa[$ _tipo] = _cor;
        }
        return _cor;
    }

    atualiza_mapa = function()
    {
        //surface de 1 pixel por bloco, redesenhada só 6x por segundo
        if (!surface_exists(mapa_surface))
        {
            mapa_surface = surface_create(MAX_COLUNAS, MAX_LINHAS);
            mapa_sujo = true;
        }

        if (!mapa_sujo && current_time - t_mapa < 166) return;
        t_mapa    = current_time;
        mapa_sujo = false;

        surface_set_target(mapa_surface);
        draw_clear_alpha(c_black, 0);

        var _colunas = min(MAX_COLUNAS, array_length(global.blocos_struct));
        for (var c = 0; c < _colunas; c++)
        {
            var _coluna = global.blocos_struct[c];
            for (var l = 0; l < MAX_LINHAS; l++)
            {
                draw_point_colour(c, l, cor_do_bloco(_coluna[l]));
            }
        }

        surface_reset_target();
    }

    //coluna/linha do mapa embaixo do mouse da GUI (ou undefined)
    mapa_celula_mouse = function()
    {
        var _mx = device_mouse_x_to_gui(0);
        var _my = device_mouse_y_to_gui(0);
        var _w  = MAX_COLUNAS * mapa_cel;
        var _h  = MAX_LINHAS * mapa_cel;

        if (!point_in_rectangle(_mx, _my, mapa_x, mapa_y, mapa_x + _w - 1, mapa_y + _h - 1)) return undefined;

        return
        {
            col:   floor((_mx - mapa_x) / mapa_cel),
            linha: floor((_my - mapa_y) / mapa_cel)
        };
    }

    clique_mapa = function()
    {
        if (!mostra_mapa || !na_mina()) return;

        var _cel = mapa_celula_mouse();
        if (_cel == undefined) return;

        //mouse em cima do mapa: o jogo não deve minerar
        global.mouse_hud = true;

        if (mouse_check_button_pressed(mb_left))
        {
            var _x = X_INICIAL + _cel.col * BLOCO_WIDTH;
            var _y = Y_INICIAL + _cel.linha * BLOCO_HEIGHT;
            teleporta_player(_x, _y);
        }
    }

#endregion

#region Player

    nome_estado = function(_p)
    {
        var _e = _p.estado;
        if (_e == _p.estado_parado)     return "parado";
        if (_e == _p.estado_andando)    return "andando";
        if (_e == _p.estado_minerando)  return "minerando";
        if (_e == _p.estado_desmaio)    return "desmaio";
        if (_e == _p.estado_desativado) return "desativado";
        return "?";
    }

    teleporta_player = function(_x, _y)
    {
        if (!instance_exists(obj_player)) return;

        obj_player.x = _x;
        obj_player.y = _y;

        if (!noclip) log_debug("Teleportado. Se ficou preso na parede, liga o noclip (F5).");
    }

    aplica_cheats = function()
    {
        //noclip (aplica todo frame porque o player refaz as colisões ao trocar de sala)
        if (instance_exists(obj_player))
        {
            if (noclip) obj_player.colisoes = colisoes_vazias;
            else if (noclip_anterior) obj_player.colisoes = obj_player.colisoes_originais;
        }
        noclip_anterior = noclip;

        //stamina infinita
        if (stamina_infinita) global.dados.stamina_atual = global.dados.stamina_max;

        //mochila infinita (força todo frame; ao desligar, recalcula pelo upgrade)
        if (mochila_infinita && !mochila_anterior) mochila_max_salvo = global.mochila.max_peso;
        if (mochila_infinita)
        {
            global.mochila.max_peso = 999999;
        }
        else if (mochila_anterior)
        {
            var _up = global.upgrades[$ "equip_mochila"];
            if (_up != undefined && _up.level_atual > 0) _up.aplica_efeito();
            else global.mochila.max_peso = mochila_max_salvo;
        }
        mochila_anterior = mochila_infinita;

        //escuridão
        with (obj_iluminacao) visible = !other.sem_escuridao;

        //velocidade do jogo
        velocidade_jogo = clamp(round(velocidade_jogo), 5, 240);
        if (velocidade_jogo != game_get_speed(gamespeed_fps)) game_set_speed(velocidade_jogo, gamespeed_fps);

        //trocou a picareta pelo slider (se foi o jogo que trocou, só acompanha)
        nivel_picareta_dbg = clamp(round(nivel_picareta_dbg), 0, array_length(global.tipos_picareta) - 1);
        if (nivel_picareta_dbg == nivel_picareta_anterior)
        {
            nivel_picareta_dbg = global.nivel_picareta;
        }
        nivel_picareta_anterior = nivel_picareta_dbg;

        if (nivel_picareta_dbg != global.nivel_picareta)
        {
            global.nivel_picareta = nivel_picareta_dbg;
            global.picareta = global.tipos_picareta[nivel_picareta_dbg];
            log_debug("Picareta: " + global.picareta.nome);

            //os sliders de dano/cooldown apontam pra struct antiga
            if (global.debug) recria_painel();
        }
    }

#endregion

#region Ações dos botões

    ganha_dinheiro = function()
    {
        global.dados.moeda = (global.dados.moeda <= 0) ? 10 : global.dados.moeda * 10;
        log_debug("Moeda: " + formata_moeda(global.dados.moeda));
    }

    dinheiro_milhao = function()
    {
        global.dados.moeda += 1000000;
        log_debug("+1M de moeda");
    }

    zera_dinheiro = function()
    {
        global.dados.moeda = 0;
        log_debug("Moeda zerada");
    }

    soma_item = function(_categoria, _chave, _qtd)
    {
        var _inv = global.inventario_global[$ _categoria];
        _inv[$ _chave] = (_inv[$ _chave] ?? 0) + _qtd;
    }

    ganha_itens = function()
    {
        //usa as mesmas chaves que o livro (item, item_puro, item_refinado)
        for (var p = 0; p < array_length(global.paginas_livro); p++)
        {
            var _pagina = global.paginas_livro[p];
            for (var i = 0; i < array_length(_pagina); i++)
            {
                var _item = _pagina[i];
                soma_item("minerios", _item, 10);

                //pedra não tem puro nem refinado
                if (string_pos("_pedra", _item) != 0) continue;

                soma_item("puros", _item + "_puro", 10);
                soma_item("refinados", _item + "_refinado", 10);
            }
        }
        log_debug("+10 de cada item no inventário");
    }

    zera_inventario = function()
    {
        global.inventario_global = {minerios: {}, puros: {}, refinados: {}};
        log_debug("Inventário zerado");
    }

    enche_mochila = function()
    {
        var _pedra = global.pedra_atual;
        var _peso  = global.minerios[$ _pedra].peso;
        var _qtd   = floor((global.mochila.max_peso - global.mochila.peso_atual) / _peso);
        if (_qtd <= 0) return;

        global.mochila.itens[$ _pedra] = (global.mochila.itens[$ _pedra] ?? 0) + _qtd;
        global.mochila.peso_atual += _qtd * _peso;
        log_debug(string("Mochila cheia (+{0} pedras)", _qtd));
    }

    esvazia_mochila = function()
    {
        global.mochila.itens = {};
        global.mochila.peso_atual = 0;
        log_debug("Mochila esvaziada");
    }

    muda_level_upgrades = function(_maximo)
    {
        var _chaves = struct_get_names(global.upgrades);
        for (var i = 0; i < array_length(_chaves); i++)
        {
            var _up = global.upgrades[$ _chaves[i]];
            _up.level_atual = _maximo ? _up.level_max : 0;
            _up.aplica_efeito();
        }
    }

    maxa_upgrades = function()
    {
        muda_level_upgrades(true);
        log_debug("Todos os upgrades no máximo");
    }

    reseta_upgrades = function()
    {
        muda_level_upgrades(false);
        log_debug("Upgrades resetados (nível 0)");
    }

    desbloqueia_lojas = function()
    {
        global.refinacao_bloqueada = false;
        global.upgrades_bloqueado  = false;
        log_debug("Refinação e upgrades desbloqueados");
    }

    limpa_blocos_tela = function()
    {
        if (!na_mina()) return;

        //some com os blocos sem dropar nada
        var _qtd = 0;
        with (obj_minerio)
        {
            var _col   = floor((x - X_INICIAL) / BLOCO_WIDTH);
            var _linha = floor((y - Y_INICIAL) / BLOCO_HEIGHT);
            global.blocos_struct[_col][_linha] = "vazio";
            instance_destroy();
            _qtd++;
        }
        mapa_sujo = true;
        log_debug(string("{0} blocos removidos", _qtd));
    }

    regenera_mina = function()
    {
        if (!na_mina()) return;

        //apaga tudo; o gerador cria de novo os blocos perto da câmera
        with (obj_minerio) instance_destroy();
        for (var c = 0; c < array_length(global.blocos_struct); c++)
        {
            var _coluna = global.blocos_struct[c];
            for (var l = 0; l < array_length(_coluna); l++) _coluna[l] = undefined;
        }
        mapa_sujo = true;
        reseta_monitor();
        log_debug("Mina regenerada");
    }

    vai_para_sala = function(_sala)
    {
        if (global.transicao || _sala == room) return;

        //mina e vila têm ponto de spawn; as lojas usam o player desativado
        if (array_contains(global.rooms_mina, _sala))
        {
            global.spawn_x = SPAWN_X_MINA;
            global.spawn_y = SPAWN_Y_MINA;
        }
        else if (_sala == rm_vila)
        {
            global.spawn_x = SPAWN_X_VILA;
            global.spawn_y = SPAWN_Y_VILA;
        }
        else
        {
            //ESC nas lojas volta pra vila usando esse destino
            global.dest_x = SPAWN_X_VILA;
            global.dest_y = SPAWN_Y_VILA;
        }

        if (instance_exists(obj_player)) obj_player.estado = obj_player.estado_desativado;

        cria_transicao(_sala);
    }

    tira_screenshot = function()
    {
        var _nome = string("debug_{0}{1}{2}_{3}{4}{5}.png",
            current_year, string_format(current_month, 2, 0), string_format(current_day, 2, 0),
            string_format(current_hour, 2, 0), string_format(current_minute, 2, 0), string_format(current_second, 2, 0));
        _nome = string_replace_all(_nome, " ", "0");

        screen_save(_nome);
        log_debug("Screenshot: " + _nome);
    }

#endregion

#region Painel (overlay do GameMaker)

    cria_painel = function()
    {
        show_debug_overlay(true);
        painel_view = dbg_view("MineIdle Debug", true, 20, 60, 400, 720);

        dbg_section("Desempenho", true);
        dbg_watch(ref_create(id, "n_instancias"), "Instâncias");
        dbg_watch(ref_create(id, "n_minerio"), "Blocos (obj_minerio)");
        dbg_watch(ref_create(id, "blocos_criados_seg"), "Blocos criados/s");
        dbg_watch(ref_create(id, "n_drop"), "Drops");
        dbg_watch(ref_create(id, "n_tween"), "Tweens");
        dbg_watch(ref_create(id, "n_sombra"), "Sombras");
        dbg_checkbox(ref_create(id, "mostra_monitor"), "Monitor na tela (F1)");

        dbg_section("Visualização", true);
        dbg_checkbox(ref_create(id, "mostra_hitbox"), "Hitboxes (F2)");
        dbg_checkbox(ref_create(id, "mostra_linha"), "Linha de mineração (F2)");
        dbg_checkbox(ref_create(id, "mostra_info_player"), "Info do player");
        dbg_checkbox(ref_create(id, "mostra_grade"), "Grade e margens da mina (F3)");
        dbg_checkbox(ref_create(id, "mostra_tooltip"), "Bloco no mouse (F3)");
        dbg_checkbox(ref_create(id, "mostra_vida_blocos"), "Vida de todos os blocos");
        dbg_checkbox(ref_create(id, "mostra_mapa"), "Mapa da mina (F4)");
        dbg_checkbox(ref_create(id, "mostra_chances"), "Chances da coluna do mouse");
        dbg_checkbox(ref_create(id, "mostra_log"), "Log na tela");

        dbg_section("Player", true);
        dbg_text(ref_create(id, "estado_player_txt"));
        dbg_checkbox(ref_create(id, "noclip"), "Noclip (F5)");
        dbg_checkbox(ref_create(id, "stamina_infinita"), "Stamina infinita (F6)");
        dbg_checkbox(ref_create(id, "mochila_infinita"), "Mochila infinita");
        dbg_slider(ref_create(global.dados, "speed_player"), 1, 10, "Velocidade", .5);
        dbg_slider(ref_create(global.dados, "alcance_lanterna"), .1, 5, "Lanterna", .1);
        dbg_slider(ref_create(global.dados, "chance_critico"), 0, 100, "Chance crítico %", 1);
        dbg_slider(ref_create(global.dados, "chance_drop"), 0, 100, "Chance drop duplo %", 1);
        dbg_slider(ref_create(global.dados, "ima_drop"), 0, 300, "Ímã dos drops", 5);

        dbg_section("Picareta", false);
        dbg_slider_int(ref_create(id, "nivel_picareta_dbg"), 0, array_length(global.tipos_picareta) - 1, "Tipo");
        dbg_slider(ref_create(global.picareta, "dano"), 1, 500, "Dano", 1);
        dbg_slider(ref_create(global.picareta, "cooldown"), 1, 60, "Cooldown (frames)", 1);

        dbg_section("Mina", false);
        dbg_checkbox(ref_create(id, "sem_escuridao"), "Sem escuridão (F7)");
        dbg_button("Limpar blocos da tela", limpa_blocos_tela);
        dbg_button("Regenerar mina", regenera_mina);

        dbg_section("Economia", false);
        dbg_button("Moeda x10", ganha_dinheiro);
        dbg_same_line();
        dbg_button("+1M", dinheiro_milhao);
        dbg_same_line();
        dbg_button("Zerar", zera_dinheiro);
        dbg_button("+10 de cada item", ganha_itens);
        dbg_same_line();
        dbg_button("Zerar inventário", zera_inventario);
        dbg_button("Encher mochila", enche_mochila);
        dbg_same_line();
        dbg_button("Esvaziar mochila", esvazia_mochila);

        dbg_section("Upgrades", false);
        dbg_button("Maxar todos", maxa_upgrades);
        dbg_same_line();
        dbg_button("Resetar todos", reseta_upgrades);
        dbg_button("Desbloquear lojas", desbloqueia_lojas);

        dbg_section("Salas", false);
        for (var i = 0; i < array_length(salas_debug); i++)
        {
            var _sala = salas_debug[i];
            if (i mod 2 == 1) dbg_same_line();
            dbg_button(room_get_name(_sala), method({dbg: id, sala: _sala}, function() { dbg.vai_para_sala(sala); }));
        }

        dbg_section("Tempo", false);
        dbg_slider_int(ref_create(id, "velocidade_jogo"), 5, 240, "FPS do jogo (F8)", 5);
        dbg_button("Screenshot (F9)", tira_screenshot);
    }

    deleta_painel = function()
    {
        show_debug_overlay(false);
        if (dbg_view_exists(painel_view)) dbg_view_delete(painel_view);
        painel_view = -1;
    }

    recria_painel = function()
    {
        deleta_painel();
        cria_painel();
    }

#endregion

#region Atalhos

    atalhos = function()
    {
        //painel
        if (keyboard_check_pressed(vk_tab))
        {
            global.debug = !global.debug;
            if (global.debug) cria_painel();
            else deleta_painel();
        }

        if (keyboard_check_pressed(vk_f1))
        {
            mostra_monitor = !mostra_monitor;
            if (mostra_monitor) reseta_monitor();
        }

        if (keyboard_check_pressed(vk_f2))
        {
            mostra_hitbox = !mostra_hitbox;
            mostra_linha  = mostra_hitbox;
        }

        if (keyboard_check_pressed(vk_f3))
        {
            mostra_grade   = !mostra_grade;
            mostra_tooltip = mostra_grade;
        }

        if (keyboard_check_pressed(vk_f4))
        {
            mostra_mapa = !mostra_mapa;
            mapa_sujo = true;
        }

        if (keyboard_check_pressed(vk_f5))
        {
            noclip = !noclip;
            log_debug("Noclip: " + (noclip ? "ON" : "OFF"));
        }

        if (keyboard_check_pressed(vk_f6))
        {
            stamina_infinita = !stamina_infinita;
            log_debug("Stamina infinita: " + (stamina_infinita ? "ON" : "OFF"));
        }

        if (keyboard_check_pressed(vk_f7))
        {
            sem_escuridao = !sem_escuridao;
            log_debug("Sem escuridão: " + (sem_escuridao ? "ON" : "OFF"));
        }

        if (keyboard_check_pressed(vk_f8))
        {
            velocidade_jogo = (velocidade_jogo == 60) ? 15 : 60;
            log_debug("FPS do jogo: " + string(velocidade_jogo));
        }

        if (keyboard_check_pressed(vk_f9)) tira_screenshot();

        //teleporte
        if (keyboard_check(vk_control) && keyboard_check_pressed(ord("T")))
        {
            teleporta_player(mouse_x, mouse_y);
        }
    }

#endregion

#region Desenho no mundo (Draw)

    desenha_mundo = function()
    {
        var _cam = view_camera[0];
        var _vx  = camera_get_view_x(_cam);
        var _vy  = camera_get_view_y(_cam);
        var _vw  = camera_get_view_width(_cam);
        var _vh  = camera_get_view_height(_cam);

        if (mostra_grade && na_mina()) desenha_grade(_vx, _vy, _vw, _vh);
        if (mostra_hitbox) desenha_hitboxes();
        if (mostra_linha)  desenha_linha_mineracao();
        if (mostra_tooltip) desenha_bloco_mouse();

        draw_set_alpha(1);
        draw_set_colour(c_white);
    }

    desenha_grade = function(_vx, _vy, _vw, _vh)
    {
        //canto superior esquerdo do bloco (0,0)
        var _ox = X_INICIAL - bloco_ox;
        var _y1 = Y_INICIAL - bloco_oy;
        var _y2 = _y1 + MAX_LINHAS * BLOCO_HEIGHT;

        //linhas das colunas que estão na tela
        draw_set_alpha(.25);
        draw_set_colour(c_white);
        var _c1 = max(0, floor((_vx - _ox) / BLOCO_WIDTH));
        var _c2 = min(MAX_COLUNAS, ceil((_vx + _vw - _ox) / BLOCO_WIDTH));
        for (var c = _c1; c <= _c2; c++)
        {
            var _x = _ox + c * BLOCO_WIDTH;
            draw_line(_x, _y1, _x, _y2);
        }
        for (var l = 0; l <= MAX_LINHAS; l++)
        {
            var _y = _y1 + l * BLOCO_HEIGHT;
            draw_line(_ox + _c1 * BLOCO_WIDTH, _y, _ox + _c2 * BLOCO_WIDTH, _y);
        }

        //faixa que o gerador cria (mesma conta do obj_gerador_minerios)
        var _ini = max(0, floor((_vx - X_INICIAL) / BLOCO_WIDTH) - MARGEM);
        var _fim = min(MAX_COLUNAS - 1, ceil(((_vx + _vw) - X_INICIAL) / BLOCO_WIDTH) + MARGEM);
        var _gx1 = _ox + _ini * BLOCO_WIDTH;
        var _gx2 = _ox + (_fim + 1) * BLOCO_WIDTH;

        draw_set_alpha(.9);
        draw_set_colour(c_lime);
        draw_rectangle(_gx1, _y1, _gx2, _y2, true);

        //limite em que o obj_minerio se destrói (obj_minerio.descarrega_bloco)
        //se você mudar a margem lá, mude aqui também
        var _margem_descarte = BLOCO_WIDTH * 2;
        draw_set_colour(c_red);
        draw_line(_vx - _margem_descarte, _y1 - 8, _vx - _margem_descarte, _y2 + 8);
        draw_line(_vx + _vw + _margem_descarte, _y1 - 8, _vx + _vw + _margem_descarte, _y2 + 8);
    }

    desenha_hitboxes = function()
    {
        draw_set_colour(c_fuchsia);

        with (obj_player)
        {
            draw_set_alpha(.2);
            draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, false);
            draw_set_alpha(1);
            draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true);
        }

        draw_set_colour(c_aqua);
        with (obj_drop) draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true);

        draw_set_colour(c_orange);
        with (obj_colisao) draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true);
    }

    desenha_linha_mineracao = function()
    {
        if (!instance_exists(obj_player)) return;

        //mesma conta do obj_picareta.linha_mineracao
        var _px  = obj_player.x;
        var _py  = obj_player.yy;
        var _dir = point_direction(_px, _py, mouse_x, mouse_y);
        var _lx  = _px + lengthdir_x(30, _dir);
        var _ly  = _py + lengthdir_y(30, _dir);

        draw_set_alpha(1);
        draw_set_colour(c_yellow);
        draw_line(_px, _py, _lx, _ly);
        draw_circle(_lx, _ly, 2, false);

        //bloco que a picareta está mirando
        with (obj_picareta)
        {
            if (instance_exists(bloco))
            {
                draw_set_colour(c_yellow);
                draw_rectangle(bloco.bbox_left, bloco.bbox_top, bloco.bbox_right, bloco.bbox_bottom, true);
            }
        }
    }

    desenha_bloco_mouse = function()
    {
        var _b = instance_position(mouse_x, mouse_y, obj_minerio);
        if (_b == noone) return;

        draw_set_alpha(1);
        draw_set_colour(c_white);
        draw_rectangle(_b.bbox_left, _b.bbox_top, _b.bbox_right, _b.bbox_bottom, true);
    }

#endregion

#region Desenho na GUI (Draw GUI)

    //converte a posição do mundo pra GUI sem criar struct
    gui_fx = 1;
    gui_fy = 1;
    gui_cx = 0;
    gui_cy = 0;

    prepara_conversao_gui = function()
    {
        var _cam = view_camera[0];
        gui_cx = camera_get_view_x(_cam);
        gui_cy = camera_get_view_y(_cam);
        gui_fx = display_get_gui_width()  / camera_get_view_width(_cam);
        gui_fy = display_get_gui_height() / camera_get_view_height(_cam);
    }

    caixa_texto = function(_x, _y, _texto, _cor = c_white, _fundo = .6)
    {
        var _w = string_width(_texto) * txt_escala;
        var _h = string_height(_texto) * txt_escala;

        draw_set_alpha(_fundo);
        draw_set_colour(c_black);
        draw_rectangle(_x - 6, _y - 4, _x + _w + 6, _y + _h + 4, false);

        draw_set_alpha(1);
        draw_set_colour(_cor);
        draw_text_transformed(_x, _y, _texto, txt_escala, txt_escala, 0);

        return _h + 12;
    }

    desenha_gui = function()
    {
        draw_set_font(fnt_pixel);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);

        prepara_conversao_gui();

        if (mostra_vida_blocos) desenha_vida_blocos();
        if (mostra_info_player) desenha_info_player();
        if (mostra_tooltip)     desenha_tooltip_bloco();
        if (mostra_mapa && na_mina()) desenha_mapa();
        if (mostra_monitor)     desenha_monitor();
        if (mostra_chances && na_mina()) with (obj_gerador_minerios) desenha_debug_porcentagens();
        if (mostra_log)         desenha_log();

        //devolvendo o estado do desenho pro resto do jogo
        draw_set_font(-1);
        draw_set_alpha(1);
        draw_set_colour(c_white);
    }

    desenha_monitor = function()
    {
        var _x = display_get_gui_width() - 420;
        var _y = 20;
        var _alvo_ms = 1000 / game_get_speed(gamespeed_fps);

        //texto todo num desenho só
        var _txt = string("FPS: {0} / {1}   (real: {2})\n", fps, game_get_speed(gamespeed_fps), round(fps_real_suave));
        _txt += string("Frame: {0} ms  pico {1} ms\n", string_format(ft_medio, 1, 2), string_format(ft_max, 1, 2));
        _txt += string("Instâncias: {0}\n", n_instancias);
        _txt += string("Blocos: {0}   criados/s: {1}\n", n_minerio, blocos_criados_seg);
        _txt += string("Drops: {0}  Tweens: {1}\n", n_drop, n_tween);
        _txt += string("Sala: {0}\n", room_get_name(room));

        var _cor = (blocos_criados_seg > 30 || fps < game_get_speed(gamespeed_fps) - 2) ? c_yellow : c_white;
        _y += caixa_texto(_x, _y, _txt, _cor);

        //gráfico de frametime
        var _gw = 400, _gh = 70;
        var _escala_ms = 40;  //topo do gráfico = 40ms

        draw_set_alpha(.6);
        draw_set_colour(c_black);
        draw_rectangle(_x - 6, _y, _x - 6 + _gw, _y + _gh, false);

        //linha do alvo (16.6ms em 60fps)
        draw_set_alpha(1);
        draw_set_colour(c_green);
        var _ly = _y + _gh - (_alvo_ms / _escala_ms) * _gh;
        draw_line(_x - 6, _ly, _x - 6 + _gw, _ly);

        //barras (da mais antiga pra mais nova)
        var _bw = _gw / DBG_AMOSTRAS;
        for (var i = 0; i < DBG_AMOSTRAS; i++)
        {
            var _ft = frametimes[(ft_indice + i) mod DBG_AMOSTRAS];
            var _bh = min(_gh, (_ft / _escala_ms) * _gh);
            var _bx = _x - 6 + i * _bw;
            draw_set_colour(_ft > _alvo_ms * 1.25 ? c_red : c_white);
            draw_rectangle(_bx, _y + _gh - _bh, _bx + _bw - 1, _y + _gh, false);
        }
        _y += _gh + 12;

        //objetos com mais instâncias
        var _top = "Mais instâncias:\n";
        for (var i = 0; i < array_length(top_objetos); i++)
        {
            _top += string("{0}  {1}\n", top_objetos[i].qtd, top_objetos[i].nome);
        }
        caixa_texto(_x, _y, _top, c_ltgray);
    }

    desenha_info_player = function()
    {
        if (!instance_exists(obj_player)) return;

        var _p   = obj_player;
        var _gx  = (_p.x - gui_cx) * gui_fx;
        var _gy  = (_p.y - gui_cy) * gui_fy;

        var _txt = string("{0}\nx {1}  y {2}\ndepth {3}\nstamina {4}/{5}\nmochila {6}/{7}",
            nome_estado(_p), round(_p.x), round(_p.y), _p.depth,
            round(global.dados.stamina_atual), global.dados.stamina_max,
            global.mochila.peso_atual, global.mochila.max_peso);

        caixa_texto(_gx + 40, _gy - 120, _txt, c_white, .5);
    }

    desenha_vida_blocos = function()
    {
        var _w = display_get_gui_width();
        var _h = display_get_gui_height();
        var _fx = gui_fx, _fy = gui_fy, _cx = gui_cx, _cy = gui_cy;

        draw_set_alpha(1);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);

        with (obj_minerio)
        {
            var _gx = (x - _cx) * _fx;
            var _gy = (y - _cy) * _fy;
            if (_gx < -50 || _gy < -50 || _gx > _w + 50 || _gy > _h + 50) continue;

            draw_set_colour(vida < max_vida ? c_yellow : c_white);
            draw_text_transformed(_gx, _gy, string(vida), 1.25, 1.25, 0);
        }

        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    }

    desenha_tooltip_bloco = function()
    {
        var _b = instance_position(mouse_x, mouse_y, obj_minerio);
        if (_b == noone) return;

        var _col   = floor((_b.x - X_INICIAL) / BLOCO_WIDTH);
        var _linha = floor((_b.y - Y_INICIAL) / BLOCO_HEIGHT);
        var _regen = (_b.vida < _b.max_vida) ? string_format(_b.timer / game_get_speed(gamespeed_fps), 1, 1) + "s" : "-";

        var _txt = string("{0} ({1})\nvida {2}/{3}\nregenera em {4}\nstamina por golpe {5}\ncoluna {6}  linha {7}\ndepth {8}",
            _b.dados.nome, _b.tipo_bloco, _b.vida, _b.max_vida, _regen,
            _b.custo_stamina, _col, _linha, _b.depth);

        var _mx = device_mouse_x_to_gui(0) + 30;
        var _my = device_mouse_y_to_gui(0) + 30;
        caixa_texto(_mx, _my, _txt, c_white, .75);
    }

    desenha_mapa = function()
    {
        atualiza_mapa();

        var _w = MAX_COLUNAS * mapa_cel;
        var _h = MAX_LINHAS * mapa_cel;

        //fundo
        draw_set_alpha(.75);
        draw_set_colour(c_black);
        draw_rectangle(mapa_x - 6, mapa_y - 36, mapa_x + _w + 6, mapa_y + _h + 6, false);
        draw_set_alpha(1);

        //o mapa em si (1 pixel por bloco, esticado)
        if (surface_exists(mapa_surface)) draw_surface_stretched(mapa_surface, mapa_x, mapa_y, _w, _h);

        //retângulo da câmera
        var _cam = view_camera[0];
        var _ox = X_INICIAL - bloco_ox;
        var _c1 = (camera_get_view_x(_cam) - _ox) / BLOCO_WIDTH;
        var _c2 = (camera_get_view_x(_cam) + camera_get_view_width(_cam) - _ox) / BLOCO_WIDTH;
        draw_set_colour(c_white);
        draw_rectangle(mapa_x + max(0, _c1) * mapa_cel, mapa_y, mapa_x + min(MAX_COLUNAS, _c2) * mapa_cel, mapa_y + _h, true);

        //player
        if (instance_exists(obj_player))
        {
            var _pc = (obj_player.x - _ox) / BLOCO_WIDTH;
            var _pl = (obj_player.y - (Y_INICIAL - bloco_oy)) / BLOCO_HEIGHT;
            if (_pc >= 0 && _pc <= MAX_COLUNAS)
            {
                draw_set_colour(c_lime);
                draw_circle(mapa_x + _pc * mapa_cel, mapa_y + clamp(_pl, 0, MAX_LINHAS) * mapa_cel, 5, false);
            }
        }

        //título e célula no mouse
        var _titulo = "Mapa da mina (clique = teleporta)";
        var _cel = mapa_celula_mouse();
        if (_cel != undefined)
        {
            var _tipo = global.blocos_struct[_cel.col][_cel.linha];
            _titulo = string("col {0}  linha {1}: {2}", _cel.col, _cel.linha, _tipo ?? "não gerado");
        }
        draw_set_colour(c_white);
        draw_text_transformed(mapa_x, mapa_y - 32, _titulo, txt_escala, txt_escala, 0);
    }

    desenha_log = function()
    {
        var _n = array_length(log_linhas);
        if (_n <= 0) return;

        //tirando as mensagens velhas
        while (_n > 0 && current_time - log_linhas[0].t > DBG_LOG_TEMPO)
        {
            array_delete(log_linhas, 0, 1);
            _n--;
        }

        var _x = 20;
        var _y = display_get_gui_height() - 60;
        if (mostra_mapa && na_mina()) _y = mapa_y - 60;

        //de baixo pra cima, mais nova embaixo
        for (var i = _n - 1; i >= 0; i--)
        {
            var _linha = log_linhas[i];
            var _alpha = clamp((DBG_LOG_TEMPO - (current_time - _linha.t)) / 1000, 0, 1);

            draw_set_alpha(_alpha * .5);
            draw_set_colour(c_black);
            var _w = string_width(_linha.texto) * txt_escala;
            draw_rectangle(_x - 6, _y - 2, _x + _w + 6, _y + 26, false);

            draw_set_alpha(_alpha);
            draw_set_colour(c_white);
            draw_text_transformed(_x, _y, _linha.texto, txt_escala, txt_escala, 0);

            _y -= 32;
        }
        draw_set_alpha(1);
    }

#endregion
