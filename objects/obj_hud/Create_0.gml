//infos de debug
debug = false;
show_debug_overlay(true);

//escala das sprites
escala = 4;

//infos para os drops caindo
frame = 0;
itens_caindo = [];
peso_atual = global.peso_atual;


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
                
                //colocando os itens da sacola no inventario
                for (var i = 0; i < array_length(global.inventario.minerio); i++)
                {
                    //colocando no inventario
                    global.inventario.minerio[i].quantidade += global.inventario_sacola.minerio[i];
                    
                    //resetando a sacola
                    global.inventario_sacola.minerio[i] = 0;
                }
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
        if (room == rm_mina) 
        {
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
        }
        //reiniciando a sacola quando entrar na vila
        else 
        {   
            peso_atual = 0;
        	global.peso_atual = 0;
            //limpando lista
            itens_caindo = [];
        }
        
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
            draw_sprite_ext(spr_minerios_pequenos, _item.frame, _xsacola, _item.y, escala, escala, 0, c_white, 1);
            
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
            var _wdrops = (sprite_get_width(spr_minerios_pequenos) * escala);
            var _hdrops = (sprite_get_height(spr_minerios_pequenos) * escala);
            var _margem = escala * 5;
            var _desenhados = 0; //calcula a posição y dos itens
            
            //desenhando minérios
            for (var i = 0; i < array_length(global.inventario_sacola.minerio); i++)
            {
                var _item = global.inventario_sacola.minerio[i];
                
                //se ja pegou o item
                if (_item <= 0) continue;
                
                //desenhando sprite dos minerios
                var _xdrop = _xfundo + _wdrops;
                var _ydrop = _yfundo + _hdrops + (_desenhados * (_hdrops + _margem));
                draw_sprite_ext(spr_minerios_pequenos, i, _xdrop, _ydrop, escala, escala, 0, c_white, 1);
                
                //somando itens ja desenhados
                _desenhados++;
                
                //desenhando texto do valor
                var _xtxt = _xdrop + _wdrops;
                var _ytxt = _ydrop - (_hdrops - 10);
                draw_text(_xtxt, _ytxt, "=");
                draw_text(_xdrop + _wdrops * 2, _ytxt, _item);
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
        var _x = display_get_gui_width() / 2 - sprite_get_width(spr_moeda) - 20;
        var _y = 60;
        
        //desenhando moedas
        frame = draw_animation(frame, spr_moeda);
        draw_sprite_ext(spr_moeda, frame, _x, _y, escala, escala, 0, c_white, 1);
        
        //texto da moeda
        draw_set_halign(0);
        draw_set_valign(1);
        
        draw_text(_x + 40, _y, global.moeda);
        
        draw_set_valign(-1);
        draw_set_halign(-1);
        draw_set_font(-1);
    }
    
    //desenhando o inventario
    desenha_inventario = function()
    {
        draw_set_font(fnt_ui);
        
        //não desenha na mina nem no upgrades
        if (room == rm_mina || room == rm_upgrade) exit;
        
        //margens
        var _xmargem = 50;
        var _ymargem = 20;
        var _fundo_margem = 10; 
        
        ////// PEGANDO AS COLUNAS ///////
        var _colunas = 0;
        
        //pegando os minerios e refinados
        for (var i = 0; i < array_length(global.inventario.minerio); i++)
        {
            //pegando os minerios descobertos
            var _minerio_descoberto = global.inventario.minerio[i].descoberto;
            var _refinado_descoberto = false;
            
            //pegando os refinados descobertos
            var j = i - 1;
            
            if (j >= 0 && j < array_length(global.inventario.refinado))
            {
                _refinado_descoberto = global.inventario.refinado[j].descoberto;
            }
            
            //adicionando uma coluna pra cada minerio ou refinado descoberto
            if (_minerio_descoberto || _refinado_descoberto) 
            {
                _colunas++;
            }
        }
        
        ////// PEGANDO POSIÇÃO CENTRALIZADA ///////
        var _hminerio = sprite_get_height(spr_minerios) * escala;
        var _wminerio = sprite_get_width(spr_minerios) * escala;
        var _slot_minerio = _wminerio + 150;
        
        //largura total dos itens descobertos
        var _largura_total = _colunas * _slot_minerio;
        
        //posição base  
        var _xcentro = (display_get_gui_width() / 2) + 70;
        var _x = _xcentro - (_largura_total / 2);
        var _y = 660;
        var _yrefinado = _y - 70;
        
        ////// DESENHANDO AS COLUNAS ///////
        var _coluna_atual = 0;
        
        for (var i = 0; i < array_length(global.inventario.minerio); i++)
        {
            //pegando o minerio
            var _minerio = global.inventario.minerio[i];   
            var _minerio_descoberto = _minerio.descoberto;
            
            //pegando o refinado
            var _refinado = 0;
            var _refinado_descoberto = false;
            var j = i - 1;
            
            if (j >= 0 && j < array_length(global.inventario.refinado))
            { 
                _refinado = global.inventario.refinado[j];
                _refinado_descoberto = _refinado.descoberto;
            }
            
            //só mostra o item se ja foi descoberto
            if (_minerio_descoberto == false && _refinado_descoberto == false) continue;
            
            //pegando o x da coluna
            var _xcoluna = _x + (_coluna_atual * _slot_minerio);
            
            ////// DESENHANDO OS REFINADOS E MINÉRIOS ///////
            if (_refinado_descoberto)
            {
                //posição da quantidade
                var _xquant = _xcoluna + _xmargem;
                var _yquant = _yrefinado - _ymargem;
                
                //posição do fundo
                var _xfundo = _xcoluna - (_wminerio / 2) - _fundo_margem;
                var _yfundo = _yrefinado - (_hminerio / 2) - _fundo_margem;
                var _wfundo = _wminerio + string_width(_refinado.quantidade) + _xmargem;
                var _hfundo = (_hminerio + _fundo_margem * 2) * 2 - 15;
                
                //fundo
                draw_sprite_stretched_ext(spr_fundo, 0, _xfundo, _yfundo, _wfundo, _hfundo, c_white, .5);
                
                //desenhando o refinado
                draw_sprite_ext(spr_refinados, j, _xcoluna, _yrefinado, escala, escala, 0, c_white, 1);
                draw_text(_xquant, _yquant, _refinado.quantidade);
                
                //desenhando o minerio
                draw_sprite_ext(spr_minerios, i, _xcoluna, _y, escala, escala, 0, c_white, 1);
                _yquant = _y - _ymargem;
                draw_text(_xquant, _yquant, _minerio.quantidade);
            }      
            
            ////// DESENHANDO SÓ OS MINÉRIOS ///////
            else if (_minerio_descoberto)
            {
                //posição da quantidade
                var _xquant = _xcoluna + _xmargem;
                var _yquant = _y - _ymargem;
                
                //posição do fundo
                var _xfundo = _xcoluna - (_wminerio / 2) - _fundo_margem;
                var _yfundo = _y - (_hminerio / 2) - _fundo_margem;
                var _wfundo = _wminerio + string_width(_minerio.quantidade) + _xmargem;
                var _hfundo = _hminerio + _fundo_margem * 2;
                
                //fundo
                draw_sprite_stretched_ext(spr_fundo, 0, _xfundo, _yfundo, _wfundo, _hfundo, c_white, .5);
                
                //sprite do item
                draw_sprite_ext(spr_minerios, i, _xcoluna, _y, escala, escala, 0, c_white, 1);
                
                //quantidade
                draw_text(_xquant, _yquant, _minerio.quantidade);
            }
            
            //avançando a coluna pro prox desenho
            _coluna_atual++;     
        }
        
        draw_set_font(-1);
    }
    
    //desenhando o botao de voltar
    desenha_voltar = function()
    {
        if (room == rm_vila || room == rm_mina) exit;
        
        var _x = display_get_gui_width() - (sprite_get_width(spr_voltar) * escala) / 2 - 20;
        var _y = sprite_get_height(spr_voltar) * escala;
        
        //interagindo
        var _mx = device_mouse_x_to_gui(0);
        var _my = device_mouse_y_to_gui(0);
        var _x1 = _x - (sprite_get_width(spr_voltar) * escala) / 2;
        var _y1 = _y - (sprite_get_height(spr_voltar) * escala) / 2;
        var _x2 = _x + (sprite_get_width(spr_voltar) * escala) / 2;
        var _y2 = _y + (sprite_get_height(spr_voltar) * escala) / 2;
        var _rectangle = point_in_rectangle(_mx, _my, _x1, _y1, _x2, _y2);
        
        if (_rectangle)
        {
            //selecionado
            draw_sprite_ext(spr_voltar, 1, _x, _y, escala, escala, 0, c_white, 1);
            
            //indo pra vila
            if (mouse_check_button_pressed(mb_left))
            {
                room_goto(rm_vila);
            }
        }
        else
        {
            //não selecionado
            draw_sprite_ext(spr_voltar, 0, _x, _y, escala, escala, 0, c_white, 1);
        }
    }
    
#endregion