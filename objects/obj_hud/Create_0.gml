//efeitos
inicia_efeito_squash();


desenha_hud = function()
{
    desenha_sacola();
}

#region Sacola
    
    itens_caindo = [];
    peso_atual = global.sacola.peso_atual;
    escala_sacola = global.escala_hud;
    
    desenha_sacola = function()
    {
        var _x = 100;
        var _y = 640;
        
        //fundo da sacola
        draw_sprite_ext(spr_sacola, 1, _x, _y, escala_sacola * xscale, escala_sacola * yscale, 0, c_white, 1);
        
        
        //adicionando os minerios na sacola de acordo com o peso
        var _porc = (peso_atual / global.sacola.max_peso) * 100;
        var _index = 0;
        
        //configurando porcentagem
        if (_porc > 0 && _porc < 20)         _index = 2;
        else if (_porc >= 20 && _porc < 40)  _index = 3;
        else if (_porc >= 40 && _porc < 60)  _index = 4;
        else if (_porc >= 60 && _porc < 80)  _index = 5;
        else if (_porc >= 80 && _porc < 100) _index = 6;
        else if (_porc >= 100)               _index = 7;
        
        drops_caindo(_x, _y);
        
        //minerios da sacola
        draw_sprite_ext(spr_sacola, _index, _x, _y, escala_sacola * xscale, escala_sacola * yscale, 0, c_white, 1);
        
        //frente da sacola
        draw_sprite_ext(spr_sacola, 0, _x, _y, escala_sacola * xscale, escala_sacola * yscale, 0, c_white, 1);
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
                efeito_squash(1.5, .5);
                array_delete(itens_caindo, i, 1);
            }
        }
    }
     
#endregion
