//efeitos
inicia_efeito_squash();


desenha_hud = function()
{
    desenha_sacola();
}

#region Sacola
    
    itens_caindo = [];
    peso_atual = global.sacola.peso_atual;
    peso_desenhado = 0;
    escala_sacola = global.escala_hud;
    
    desenha_sacola = function()
    {
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
        var _porc = (peso_atual / global.sacola.max_peso) * 100;
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
        
        drops_caindo(_x, _y);
        
        //minerios da sacola
        draw_sprite_ext(spr_sacola, _index, _x, _y, _escala_x, _escala_y, 0, c_white, 1);
        
        //frente da sacola
        draw_sprite_ext(spr_sacola, 0, _x, _y, _escala_x, _escala_y, 0, c_white, 1);
        
        //outras funções
        texto_peso(_x, _y);
        sacola_infos(_x, _y);
    }
    
    drops_caindo = function(_xsacola, _ysacola)
    {
        //rodando a lista de tras pra frente pra poder deletar mais facil
        for (var i = array_length(itens_caindo) - 1; i >= 0; i--)
        {
            var _atual = itens_caindo[i];
            
            //aplicando velocidade
            _atual.vspd += .5;
            _atual.y += _atual.vspd;
            
            //desenhando a sprite
            draw_sprite_ext(spr_minerios_pequenos, _atual.frame, _xsacola, _atual.y, escala_sacola, escala_sacola, 0, c_white, 1);
            
            //apagando se chegou na sacola
            if (_atual.y >= _ysacola)
            {
                peso_atual += _atual.peso;
                
                //efeito
                efeito_squash(1.5, .5);
                var _txt = instance_create_depth(0, 0, -9999, obj_texto_voador, {xx: _xsacola, yy: _ysacola});
                _txt.texto = "[wave]+" + string(_atual.peso) + "kg[/]";
                
                //deletando o item da array
                array_delete(itens_caindo, i, 1);
            }
        }
    }
    
    texto_peso = function(_xsacola, _ysacola)
    {
        //posição do texto
        var _xscale = .5 * xscale;
        var _yscale = .5 * yscale;
        var _x = _xsacola + 5;
        var _y = _ysacola - 20;
        var _cor = c_white;
        
        //porcentagem
        peso_desenhado = lerp(peso_desenhado, peso_atual, .1);
        var _porc = string(round((peso_desenhado / global.sacola.max_peso) * 100));
        var _texto = "";
        
        if (_porc < 100)
        {
            _texto = "[wave]" + string(_porc) + "%[/]";
            _cor = c_white;
        }
        else
        {
            _texto = "[shake][pulse]FULL[/]";
            _cor = c_red;
        }  
        
        //texto
        texto_sombra(_x, _y, _texto, 4, _xscale, _yscale, 1, , _cor);
    }
    
    sacola_infos = function(_xsacola, _ysacola)
    {
        //so desenha se tiver algum item na sacola
        if (global.sacola.peso_atual <= 0) return;
        
        //mouse
        var _mx = device_mouse_x_to_gui(0);
        var _my = device_mouse_y_to_gui(0);
        
        //posição da sacola
        var _x1 = _xsacola - (sprite_get_width(spr_sacola) / 2) * escala_sacola;
        var _y1 = _ysacola - (sprite_get_height(spr_sacola) / 2) * escala_sacola;
        var _x2 = _xsacola + (sprite_get_width(spr_sacola) / 2) * escala_sacola;
        var _y2 = _ysacola + (sprite_get_height(spr_sacola) / 2) * escala_sacola;
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
            var _wdrops = (sprite_get_width(spr_minerios_pequenos) * escala_sacola);
            var _hdrops = (sprite_get_height(spr_minerios_pequenos) * escala_sacola);
            var _margem = escala_sacola * 5;
            var _desenhados = 0; //calcula a posição y dos itens
            
            //desenhando minérios
            for (var i = 0; i < array_length(global.sacola.itens); i++)
            {
                var _item = global.sacola.itens[i];
                
                //se ja pegou o item
                if (_item <= 0) continue;
                
                //desenhando sprite dos minerios
                var _xdrop = _xfundo + _wdrops;
                var _ydrop = _yfundo + _hdrops + (_desenhados * (_hdrops + _margem));
                draw_sprite_ext(spr_minerios_pequenos, i, _xdrop, _ydrop, escala_sacola, escala_sacola, 0, c_white, 1);
                
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
