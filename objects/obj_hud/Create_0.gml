debug = false;
frame = 0;
itens_caindo = [];
peso_atual = global.peso_atual;
escala = 4;

//tocando soundtrack
//audio_play_sound(snd_mina_soundtrack, 100, 1);

#region Mina
    
    //desenhando a barra de stamina
    desenha_stamina = function()
    {
        //só desenha na mina
        if (room != rm_mina) exit;
        
        //pegando valor da stamina
        var _stamina = (global.stamina_atual / global.stamina_max);
        
        //variaveis pro draw
        var _x = display_get_gui_width() / 3;
        var _y = 20;
        
        //mudando cor
        var _cor = merge_colour(c_red, c_lime, _stamina);
        
        //mudando largura da stamina
        var _width = _stamina * sprite_get_width(spr_barra_stamina);
        var _height = sprite_get_height(spr_barra_stamina);
        
        //fundo da stamina
        draw_sprite(spr_barra_stamina, 1, _x, _y);
        //barra da stamina
        draw_sprite_stretched_ext(spr_barra_stamina, 0, _x, _y, _width, _height, _cor, 1);
    }
    
    //desenhando botão pra ir para vila
    desenha_botao_voltar = function()
    {
        draw_set_font(fnt_ui);
        
        //so desenha na mina
        if (room != rm_mina) exit;
            
        //posição do botão
        var _x = display_get_gui_width() - 100;
        var _y = 640;
        
        //variaveis do retangulo e mouse
        var _mx = device_mouse_x_to_gui(0);
        var _my = device_mouse_y_to_gui(0);
        var _x1 = _x - (sprite_get_width(spr_botao_voltar) * escala) / 2;
        var _y1 = _y - (sprite_get_height(spr_botao_voltar) * escala / 2) / 2;
        var _x2 = _x + (sprite_get_width(spr_botao_voltar) * escala) / 2;
        var _y2 = _y + (sprite_get_height(spr_botao_voltar) * escala / 2) / 2;
        var _rectangle = point_in_rectangle(_mx, _my, _x1, _y1, _x2, _y2);
        
        //seleção
        var _index = 0;
        
        if (_rectangle)
        {
            _index = 1;
            
            //clicando
            if (mouse_check_button_pressed(mb_left))
            {
                room_goto(rm_vila);
            }
        }
        else
        {
            _index = 0;
        }
        
        //desenhando botão
        draw_sprite_ext(spr_botao_voltar, _index, _x, _y, escala, escala / 2, 0, c_white, 1); 
        
        //desenhando texto
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text(_x, _y, "Vila");
        draw_set_halign(-1);
        draw_set_valign(-1);
        draw_set_font(-1);
    }
    
    //desenhando a sacola que guarda os itens
    desenha_sacola = function()
    {
        draw_set_font(fnt_ui);
        
        //só desenha na mina
        if (room != rm_mina) exit;
        
        //variaveis pro draw
        var _x = 100;
        var _y = 640;
        
        //desenhando fundo da sacola
        draw_sprite_ext(spr_sacola, 1, _x, _y, escala, escala, 0, c_white, 1);
        
        //adicionando minerio de acordo com o peso
        var _porc = (peso_atual / global.peso_max) * 100;
        var _index = 0;
        
        //configurando porcentagem
        if (_porc > 0 && _porc < 20)         _index = 2;
        else if (_porc >= 20 && _porc < 40)  _index = 3;
        else if (_porc >= 40 && _porc < 60)  _index = 4;
        else if (_porc >= 60 && _porc < 80)  _index = 5;
        else if (_porc >= 80 && _porc < 100) _index = 6;
        else if (_porc >= 100)               _index = 7;
        
        //desenhando os drops caindo
        sacola_drops(_x, _y);
        
        //desenhando os minerios no saquinho
        draw_sprite_ext(spr_sacola, _index, _x, _y, escala, escala, 0, c_white, 1);
        
        //desenhando frente da sacola
        draw_sprite_ext(spr_sacola, 0, _x, _y, escala, escala, 0, c_white, 1);
        
        //texto de peso
        var _peso_atual = string_format(global.peso_atual / 1000, 1, 1);
        var _peso_max = string_format(global.peso_max / 1000, 1, 1) + "kg";
        
        //mudando de cor quando chegar no maximo
        var _cor = c_white;
        if (global.peso_atual >= global.peso_max) _cor = c_red;
        
        draw_text_colour(_x + 80, _y + 20, _peso_atual + "/" + _peso_max, _cor, _cor, _cor, _cor, 1);
        
        //desenhando as infos da sacola
        sacola_infos(_x, _y);
        
        draw_set_font(-1);
    }
    
    //desenhando o drop caindo na sacola
    sacola_drops = function(_xsacola, _ysacola)
    {
        //rodando a lista de tras pra frente pra poder deletar mais facil
        for (var i = array_length(itens_caindo) - 1; i >= 0; i--)
        {
            var _item = itens_caindo[i];
            
            //aplicando velocidade
            _item.vspd += .2;
            _item.y += _item.vspd;
            
            //desenhando a sprite
            draw_sprite_ext(spr_drops_sacola, _item.frame, _xsacola, _item.y, escala, escala, 0, c_white, 1);
            
            //apagando se chegou na sacola
            if (_item.y >= _ysacola)
            {
                peso_atual += _item.peso;
                array_delete(itens_caindo, i, 1);
            }
        }
    }
    
    //desenhando as infos da sacola
    sacola_infos = function(_xsacola, _ysacola)
    {
        //só desenha se tiver algum item na sacola
        if (global.peso_atual <= 0) exit;
        
        //mouse
        var _mx = device_mouse_x_to_gui(0);
        var _my = device_mouse_y_to_gui(0);
        
        //posição da sacola
        var _x1 = _xsacola - (sprite_get_width(spr_sacola) / 2) * escala;
        var _y1 = _ysacola - (sprite_get_height(spr_sacola) / 2) * escala;
        var _x2 = _xsacola + (sprite_get_width(spr_sacola) / 2) * escala;
        var _y2 = _ysacola + (sprite_get_height(spr_sacola) / 2) * escala;
        var _rectangle = point_in_rectangle(_mx, _my, _x1, _y1, _x2, _y2);
         
        if (_rectangle)
        {
            //desenhando fundo
            var _wfundo = 200;
            var _hfundo = 300;
            var _xfundo = max(0, _mx - _wfundo / 2);
            var _yfundo = _my - _hfundo;
            draw_sprite_stretched(spr_fundo, 0, _xfundo, _yfundo, _wfundo, _hfundo);
            
            //variaveis pro desenho do drop
            var _wdrops = (sprite_get_width(spr_drops_sacola) * escala);
            var _hdrops = (sprite_get_height(spr_drops_sacola) * escala);
            var _margem = escala * 5;
            var _desenhados = 0; //calcula a posição y dos itens
            
            //desenhando minérios
            for (var i = 0; i < array_length(global.inventario); i++)
            {
                var _item = global.inventario[i];
                
                //se ja pegou o item
                if (_item.quantidade <= 0) continue;
                
                //desenhando sprite dos minerios
                var _xdrop = _xfundo + _wdrops;
                var _ydrop = _yfundo + _hdrops + (_desenhados * (_hdrops + _margem));
                draw_sprite_ext(spr_drops_sacola, i, _xdrop, _ydrop, escala, escala, 0, c_white, 1);
                
                //somando itens ja desenhados
                _desenhados++;
                
                //desenhando texto do valor
                var _xtxt = _xdrop + _wdrops;
                var _ytxt = _ydrop - (_hdrops - 10);
                draw_text(_xtxt, _ytxt, "=");
                draw_text(_xdrop + _wdrops * 2, _ytxt, _item.quantidade);
            }
        }
    }
    
#endregion

#region Vila
    
    //desenhando a moeda
    desenha_moeda = function()
    {
        draw_set_font(fnt_ui);
        
        //não desenha a moeda na mina
        if (room == rm_mina) exit;
        
        //variaveis pro draw
        var _x = 60;
        var _y = 60;
        
        //desenhando moedas
        frame = draw_animation(frame, spr_moeda);
        draw_sprite_ext(spr_moeda, frame, _x, _y, escala, escala, 0, c_white, 1);
        
        //texto da moeda
        draw_set_valign(fa_middle);
        
        draw_text(_x + 40, _y, global.moeda);
        
        draw_set_valign(-1);
        draw_set_font(-1);
    }
    
    //desenhando o inventario
    desenha_inventario = function()
    {
        draw_set_font(fnt_ui);
        
        //não desenha na mina
        if (room == rm_mina) exit;
        
        //posição do botão
        var _x = 80;
        var _y = 670;
        
        //variaveis do retangulo e mouse
        var _mx = device_mouse_x_to_gui(0);
        var _my = device_mouse_y_to_gui(0);
        var _x1 = _x - (sprite_get_width(spr_botao_voltar) * escala) / 2;
        var _y1 = _y - (sprite_get_height(spr_botao_voltar) * escala / 2) / 2;
        var _x2 = _x + (sprite_get_width(spr_botao_voltar) * escala) / 2;
        var _y2 = _y + (sprite_get_height(spr_botao_voltar) * escala / 2) / 2;
        var _rectangle = point_in_rectangle(_mx, _my, _x1, _y1, _x2, _y2);
        var _click = mouse_check_button_pressed(mb_left);
        
        //seleção
        var _index = 0;
        
        if (_rectangle)
        {
            _index = 1;
        }
        else
        {
            _index = 0;
        }
        
        //desenhando botão
        draw_sprite_ext(spr_botao_voltar, _index, _x, _y, escala, escala / 2, 0, c_white, 1); 
        
        //desenhando texto
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text(_x, _y, "Banco");
        draw_set_halign(-1);
        draw_set_valign(-1);
        draw_set_font(-1);
        
        //clicando
        if (_rectangle && _click)
        {
            show_message("o")
        }
    }
    
#endregion