//efeitos
inicia_efeito_squash();


desenha_hud = function()
{
    desenha_sacola();
    desenha_stamina();
    desenha_moeda();
}

#region Sacola
    
    itens_caindo = [];
    peso_desenhado = 0;
    escala_sacola = global.escala_hud;
    
    desenha_sacola = function()
    {
        //so desenha na mina
        if (!array_contains(global.rooms_mina, room)) return;
        
        //efeito de se mexer
        var _mexe_y = sin(current_time / 300) * 3;
        var _x = 100;
        var _y = 620 + _mexe_y;
        
        //escalas
        var _escala_x = (escala_sacola * xscale);
        var _escala_y = (escala_sacola * yscale);
        
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
            draw_sprite_ext(spr_minerios_pequenos, _item.frame, _xsacola, _item.y, escala_sacola, escala_sacola, 0, c_white, 1);
            
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
                efeito_squash(1.5, .5);
                var _txt = instance_create_depth(0, 0, -9999, obj_texto_voador, {xx: _xsacola, yy: _ysacola});
                _txt.texto = "[wave]+" + string(_item.peso) + "kg[/]";
                
                //deletando o item da array
                array_delete(itens_caindo, i, 1);
            }
        }
    }
    
    sacola_porcentagem = function(_xsacola, _ysacola)
    {
        //posição do texto
        var _xscale = .4 * xscale;
        var _yscale = .4 * yscale;
        var _x = _xsacola + 5;
        var _y = _ysacola - 20;
        var _cor = c_white;
        
        //porcentagem
        peso_desenhado = lerp(peso_desenhado, global.sacola.peso_atual, .1);
        var _porc = string(round((peso_desenhado / global.sacola.max_peso) * 100));
        var _texto = "";
        
        if (_porc < 100)
        {
            _texto = "[wheel]" + string(_porc) + "%[/]";
            _cor = c_white;
        }
        else
        {
            _texto = "[shake][pulse]FULL[/]";
            _cor = #e41818;
        }  
        
        //texto
        texto_scribble(_x, _y, _texto, _xscale, _yscale, 1, , _cor);
    }
    
    sacola_infos = function(_xsacola, _ysacola)
    {
        //só desenha se tiver algum item na sacola
        if (global.sacola.peso_atual <= 0) return;
        
        var _mouse_sobre = mouse_sobre_ui(_xsacola, _ysacola, spr_sacola, escala_sacola);
         
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
            
            draw_sprite_stretched(spr_fundo_infos, 0, _xfundo, _yfundo, _wfundo, _hfundo);
            
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
            var _ycap = _ybar - 5;
            
            if (_porc < .99)
            {
                texto_scribble(_xcap - 20, _ycap, string("{0}kg", round(peso_desenhado)), .2, , 2); //capacidade atual
                texto_scribble(_xcap, _ycap, " / ", .3, , 1); // "/"
                texto_scribble(_xcap + 20, _ycap, string("{0}kg", global.sacola.max_peso), .2); //capacidade maxima
            }
            else
            {
                texto_scribble(_xcap, _ycap, "[shake][pulse]FULL[/]", .2, , 1, , #e41818);
            }
            
            //variaveis pro desenho dos minerios
            var _colunas = 4;
            var _espaco_x = 100;
            var _espaco_y = 70;
            var _x_inicial = _xfundo + 40;
            var _y_inicial = _ybar + 90;
            
            draw_line_width_color(_xfundo + 20, _y_inicial - 30, _xfundo + _wfundo - 20, _y_inicial - 30, 4, #190606, #190606);
            
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
                draw_sprite_ext(spr_minerios_pequenos, _dados.sprite, _x, _y, escala_sacola, escala_sacola, 0, c_white, 1);
                
                //quantidade
                texto_scribble(_x + 20, _y - 10, "x" + string(_qtd), .2);
            }
        }
    }
    
#endregion

#region Stamina
    
    stamina_desenhada = 0;
    bloco_atual = 9;
    stamina_xscale = 1;
    stamina_yscale = 1;
    
    desenha_stamina = function()
    {
        //so desenha na mina
        if (!array_contains(global.rooms_mina, room)) return;
        
        //pegando valor da stamina e dividindo em blocos
        var _porc = clamp(global.stamina_atual / global.stamina_max, 0, 1);
        var _porc_blocos = ceil(_porc * 9) / 9;
        stamina_desenhada = lerp(stamina_desenhada, _porc_blocos, .1);
        
        //cor da stamina
        var _cor = merge_colour(#d50000, #4dcb1f, stamina_desenhada);
        
        //efeito de squash
        if (_porc_blocos < bloco_atual)
        {
            stamina_efeito_squash(1.2, .8);
        }
        
        bloco_atual = _porc_blocos;
        stamina_retorna_squash(.1);
        
        //efeito de tremer
        var _shake = 0;
        if (_porc_blocos < .4)
        {
            _shake = random_range(-2, 2);
        }
        
        //aplicando a escala na largura
        var _base_w = sprite_get_width(spr_barra_stamina);
        var _base_h = sprite_get_height(spr_barra_stamina) + 5;
        var _width  = _base_w * stamina_xscale;
        var _height = _base_h * stamina_yscale;
        
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
            texto_scribble(_xtxt, _y + 13, "[shake][wave]EMPTY[/]", .3, , 1, 1, #e41818);
        }
        
        stamina_info(_x, _y)
    }
    
    stamina_efeito_squash = function(_xscale, _yscale)
    {
        stamina_xscale = _xscale;
        stamina_yscale = _yscale;
    }
    
    stamina_retorna_squash = function(_qtd)
    {
        stamina_xscale = lerp(stamina_xscale, 1, _qtd);
        stamina_yscale = lerp(stamina_yscale, 1, _qtd);
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
    
#endregion

#region Moeda
    
    frame_moeda = 0;
    moeda_desenhada = 0;
    
    desenha_moeda = function()
    {
        if (room != rm_vila) return;
        
        //desenhando moeda
        var _x = display_get_gui_width() / 2 - sprite_get_width(spr_moeda) - 20;
        var _y = 60;
        
        draw_sprite_ext(spr_moeda, 0, _x, _y, global.escala_hud, global.escala_hud, 0, c_white, 1);
        
        //texto dinheiro
        moeda_desenhada = lerp(moeda_desenhada, global.moeda, .1);
        texto_scribble(_x + 50, _y, round(moeda_desenhada), .3, , , 1);
    }
    
#endregion