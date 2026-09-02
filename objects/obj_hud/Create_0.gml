//efeitos
escala_sacola = new efeito_escala();
escala_stamina = new efeito_escala();
escala_moeda = new efeito_escala();
escala_voltar = new efeito_escala();



#region Sacola
    
    itens_caindo = [];
    peso_desenhado = 0;
    
    sacola_drops_caindo = function(_xsacola, _ysacola)
    {
        //rodando a lista de tras pra frente pra poder deletar mais facil
        for (var i = array_length(itens_caindo) - 1; i >= 0; i--)
        {
            var _item = itens_caindo[i];
            
            //aplicando velocidade
            _item.vspd += .5;
            _item.y += _item.vspd;
            
            //desenhando a sprite
            draw_sprite_ext(spr_minerios_pequenos, _item.frame, _xsacola, _item.y, global.escala_hud, global.escala_hud, 0, c_white, 1);
            
            //apagando se chegou na sacola
            if (_item.y >= _ysacola)
            {
                //criando a chave
                if (global.sacola.itens[$ _item.tipo] == undefined)
                {
                    global.sacola.itens[$ _item.tipo] = 0;
                }
                
                //adicionando minerio
                global.sacola.itens[$ _item.tipo]++;
                
                //adicionando peso
                global.sacola.peso_atual += _item.peso;
                
                //efeito
                escala_sacola.squash(1.5, .5);
                
                //efeito de texto voador
                var _txt = instance_create_depth(0, 0, -9999, obj_texto_voador, {xx: _xsacola, yy: _ysacola});
                _txt.texto = "[wave]+" + string(_item.peso) + "kg[/]";
                
                //deletando o item da array
                array_delete(itens_caindo, i, 1);
            }
        }
    }
    
    sacola_porcentagem = function(_xsacola, _ysacola)
    {
        scribble_anim_wave(3, .1, .1)
        
        //posição do texto
        var _xscale = .3 * escala_sacola.xscale;
        var _yscale = .3 * escala_sacola.yscale;
        var _x = _xsacola + 5;
        var _y = _ysacola - 10;
        var _cor = c_white;
        
        //porcentagem
        peso_desenhado = lerp(peso_desenhado, global.sacola.peso_atual, .1);
        var _porc = string(round((peso_desenhado / global.sacola.max_peso) * 100));
        var _texto = "";
        
        if (_porc < 100)
        {
            _texto = "[wave]" + string(_porc) + "%[/]";
            _cor = c_white;
        }
        else
        {
            _texto = "[shake][wheel]FULL[/]";
            _cor = cor_negativo;
        }  
        
        //texto
        texto_scribble(_x, _y, _texto, _xscale, _yscale, 1, , _cor);
    }
    
    sacola_infos = function(_xsacola, _ysacola)
    {
        //só desenha se tiver algum item na sacola
        if (global.sacola.peso_atual <= 0) return;
        
        var _mouse_sobre = mouse_sobre_ui(_xsacola, _ysacola, spr_sacola, global.escala_hud);
         
        if (_mouse_sobre)
        {
            //desenhando fundo
            var _mx = device_mouse_x_to_gui(0);
            var _my = device_mouse_y_to_gui(0);   
            var _wfundo = 400;
            var _hfundo = 350;
            var _xfundo = _xsacola + 80;
            var _min = display_get_gui_height() - _hfundo;
            var _max = _my - _hfundo / 1.5;
            var _yfundo = min(_min, _max);
            
            draw_sprite_stretched(spr_caixa_fundo, 0, _xfundo, _yfundo, _wfundo, _hfundo);
            
            //desenhando a barra
            var _xbar = _xfundo + 20;
            var _ybar = _yfundo + 20;
            var _wbar = sprite_get_width(spr_barra) + 40;
            var _hbar = sprite_get_height(spr_barra) + 8;
            
            var _porc = clamp(peso_desenhado / global.sacola.max_peso, 0, 1);
            
            draw_sprite_stretched(spr_barra, 0, _xbar, _ybar, _wbar, _hbar);
            draw_sprite_stretched(spr_barra, 1, _xbar, _ybar, _wbar * _porc, _hbar);
            
            //desenhando o texto da capacidade
            var _xcap = _xfundo + _wfundo / 2;
            var _ycap = _ybar + 5;
            
            if (_porc < .99)
            {
                var _texto = string("{0}kg / {1}kg", round(peso_desenhado), global.sacola.max_peso)
                texto_scribble(_xcap, _ycap, _texto, .2, , 1);
            }
            else
            {
                texto_scribble(_xcap, _ycap, "[shake][wheel]FULL[/]", .2, , 1, , cor_negativo);
            }
            
            //variaveis pro desenho dos minerios
            var _colunas = 4;
            var _espaco_x = 100;
            var _espaco_y = 70;
            var _x_inicial = _xfundo + 40;
            var _y_inicial = _ybar + 90;
            
            draw_line_width_color(_xfundo + 20, _y_inicial - 30, _xfundo + _wfundo - 20, _y_inicial - 30, 4, #1C1C33, #1C1C33);
            
            //rodando meus itens
            var _chaves = struct_get_names(global.sacola.itens);
            for (var i = 0; i < array_length(_chaves); i++)
            {
                var _item   = _chaves[i];
                var _qtd    = global.sacola.itens[$ _item];
                var _dados  = global.minerios[$ _item];
                
                //pegando a posição em grid
                var _coluna = i % _colunas;
                var _linha  = floor(i / _colunas);
                var _x = _x_inicial + (_coluna * _espaco_x);
                var _y = _y_inicial + (_linha * _espaco_y);
                
                //sprite
                draw_sprite_ext(spr_minerios_pequenos, _dados.sprite, _x, _y, global.escala_hud, global.escala_hud, 0, c_white, 1);
                
                //quantidade
                texto_scribble(_x + 20, _y, "x" + string(_qtd), .15);
            }
        }
    }
    
    desenha_sacola = function()
    {
        //so desenha na mina
        if (!array_contains(global.rooms_mina, room)) return;
        
        //efeito de se mexer
        var _mexe_y = sin(current_time / 300) * 3;
        var _x = 100;
        var _y = 620 + _mexe_y;
        
        //escalas
        var _escala_x = (global.escala_hud * escala_sacola.xscale);
        var _escala_y = (global.escala_hud * escala_sacola.yscale);
        escala_sacola.retorna(); // Processa a suavização para voltar a 1
        
        //fundo da sacola
        draw_sprite_ext(spr_sacola, 1, _x, _y, _escala_x, _escala_y, 0, c_white, 1);
        
        //adicionando os minerios na sacola de acordo com o peso
        var _porc = (global.sacola.peso_atual / global.sacola.max_peso) * 100;
        var _index = 0;
        
        //se tiver em 100%, a sacola treme
        if (_porc >= 100)
        {
            _x += random_range(-2, 2);
            _y += random_range(-2, 2);
        }
        
        //configurando porcentagem
        if (_porc > 0 && _porc < 20)         _index = 2;
        else if (_porc >= 20 && _porc < 40)  _index = 3;
        else if (_porc >= 40 && _porc < 60)  _index = 4;
        else if (_porc >= 60 && _porc < 80)  _index = 5;
        else if (_porc >= 80 && _porc < 100) _index = 6;
        else if (_porc >= 100)               _index = 7;
        
        sacola_drops_caindo(_x, _y);
        
        //minerios da sacola
        draw_sprite_ext(spr_sacola, _index, _x, _y, _escala_x, _escala_y, 0, c_white, 1);
        
        //frente da sacola
        draw_sprite_ext(spr_sacola, 0, _x, _y, _escala_x, _escala_y, 0, c_white, 1);
        
        //outras funções
        sacola_porcentagem(_x, _y);
        sacola_infos(_x, _y);
    }
    
#endregion

#region Stamina
    
    stamina_desenhada = 0;
    bloco_atual = 9;
    
    stamina_efeito = function(_porc_blocos)
    {
        //efeito de squash
        if (_porc_blocos < bloco_atual)
        {
            escala_stamina.squash(1.2, .8);
        }
        
        bloco_atual = _porc_blocos;
        
        escala_stamina.retorna();
        
        //efeito de tremer
        var _shake = 0;
        if (_porc_blocos < .4)
        {
            _shake = random_range(-2, 2);
        }
        
        return _shake;
    }
    
    stamina_info = function(_xbar, _ybar)
    {
        var _mouse_sobre = mouse_sobre_ui(_xbar, _ybar, spr_barra_stamina);
        
        if (_mouse_sobre)
        {
            var _x = device_mouse_x_to_gui(0) + 25;
            var _y = 90;
            var _texto = string("[wheel]{0} / {1}[/]", global.stamina_atual, global.stamina_max)
            
            texto_scribble(_x - 20, _y, _texto, .2, , 1, 1);
        }
    }
    
    desenha_stamina = function()
    {
        //so desenha na mina
        if (!array_contains(global.rooms_mina, room)) return;
        
        //pegando valor da stamina e dividindo em blocos
        var _porc = clamp(global.stamina_atual / global.stamina_max, 0, 1);
        var _porc_blocos = ceil(_porc * 9) / 9;
        stamina_desenhada = lerp(stamina_desenhada, _porc_blocos, .1);
        
        //cor da stamina
        var _cor = merge_colour(cor_negativo, cor_positivo, stamina_desenhada);
        
        //efeitos
        var _shake = stamina_efeito(_porc_blocos);
        
        //aplicando a escala na largura
        var _base_w = sprite_get_width(spr_barra_stamina);
        var _base_h = sprite_get_height(spr_barra_stamina) + 5;
        var _width  = _base_w * escala_stamina.xscale;
        var _height = _base_h * escala_stamina.yscale;
        
        //posição
        var _x = (display_get_gui_width() / 2) - (_width / 2) + _shake;
        var _y = 30 + ((_base_h - _height) / 2) + _shake;
        
        //desenhando a barra
        draw_sprite_stretched(spr_barra_stamina, 1, _x, _y, _width, _height);
        draw_sprite_stretched_ext(spr_barra_stamina, 2, _x, _y, _width * stamina_desenhada, _height, _cor, 1);
        draw_sprite_stretched(spr_barra_stamina, 0, _x, _y, _width, _height);
        
        //texto de empty
        if (_porc <= 0)
        {
            var _xtxt = display_get_gui_width() / 2;
            texto_scribble(_xtxt, _y + 13, "[shake][wave]EMPTY[/]", .3, , 1, 1, cor_negativo);
        }
        
        stamina_info(_x, _y)
    }
    
#endregion

#region Moeda
    
    moeda_desenhada = global.moeda;
    moeda_atual = global.moeda;
    moeda_cor = c_white;
    
    moeda_efeito = function()
    {
        if (global.moeda > moeda_atual)
        {
            //efeito squash
            escala_moeda.squash(2, 2);
            
            //efeito da cor
            moeda_cor = cor_positivo;
            
            moeda_atual = global.moeda;
        }
        
        //retornando os efeitos
        escala_moeda.retorna();
        moeda_cor = merge_colour(moeda_cor, c_white, .07);
    }
    
    desenha_moeda = function()
    {
        if (array_contains(global.rooms_mina, room)) return;
        
        //efeitos
        moeda_efeito();
        
        //desenhando fundo
        var _margem = 10;
        var _w = 250;
        var _h = 120;
        var _x = display_get_gui_width() - _w - _margem;
        var _y = _margem;
        
        draw_sprite_stretched(spr_caixa_fundo, 0, _x, _y, _w, _h);
        
        //desenhando moeda
        var _xmoeda = _x + 55;
        var _ymoeda = _y + (_h / 2) - 10;
        
        draw_sprite_ext(spr_moeda, 0, _xmoeda, _ymoeda, global.escala_hud, global.escala_hud, 0, c_white, 1);
        
        //texto dinheiro
        moeda_desenhada = lerp(moeda_desenhada, global.moeda, .1);
        var _texto = string("${0}", formata_moeda(moeda_desenhada))
        
        texto_scribble(_xmoeda + 40, _ymoeda, _texto, .2 * escala_moeda.xscale, .2 * escala_moeda.yscale, , 1, moeda_cor);
    }
    
#endregion

#region Voltar
    
    selecao_voltar = function(_x, _y)
    {
        if (mouse_sobre_ui(_x, _y, spr_voltar, global.escala_hud))
        {
            //efeito squash
            escala_voltar.atualiza(1.5, 1.5, .1);
            
            //indo pra vila
            if (mouse_check_button_pressed(mb_left))
            {
                cria_transicao_inicia(rm_vila);
                global.spawn_x = global.dest_x;
                global.spawn_y = global.dest_y;
            }
        }
        else
        {
            //retorna squash
            escala_voltar.retorna(.1);
        }
    }
    
    desenha_voltar = function()
    {
        if (!array_contains(global.rooms_vila, room)) return;
        
        var _xscale = global.escala_hud * escala_voltar.xscale;
        var _yscale = global.escala_hud * escala_voltar.yscale
        var _x = display_get_gui_width() - sprite_get_width(spr_voltar) * global.escala_hud;
        var _y = display_get_gui_height() - sprite_get_height(spr_voltar) * global.escala_hud;
        
        draw_sprite_ext(spr_voltar, 0, _x, _y, _xscale, _yscale, 0, c_white, 1);
        
        selecao_voltar(_x, _y);
    }
    
#endregion

desenha_hud = function()
{
    desenha_sacola();
    desenha_stamina();
    desenha_moeda();
    desenha_voltar();
}