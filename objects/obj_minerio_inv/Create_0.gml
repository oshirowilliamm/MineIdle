inicia_efeito_squash();

escala = global.escala_hud;
minerio = global.minerios[$ item];



selecao = function()
{
    //pegando a quantidade do item
    var _qtd = global.inventario_global[$ categoria][$item];
    
    //se existe
    if (_qtd != undefined)
    {
        //verifica se o mouse esta em cima
        if (mouse_sobre_ui(x, y, sprite, escala))
        {
            xscale = lerp(xscale, 1.5, .1);
            yscale = lerp(yscale, 1.5, .1);
            
            //mostrando as infos dos itens na balança
            with (obj_balanca) 
            {
                desenho = true;
                
            	item        = other.item;
                categoria   = other.categoria;
                sprite      = other.sprite;
                minerio     = other.minerio;
            }
        }
        else
        {
            retorna_squash();
        }
    }
}

desenha_minerio = function()
{
    EM_TRANSICAO
    
    //pegando a quantidade do item
    var _qtd = global.inventario_global[$ categoria][$item];
    
    //se existe
    if (_qtd != undefined)
    {
        draw_sprite_ext(sprite, minerio.sprite, x, y, escala * xscale, escala * yscale, 0, c_white, 1);
        texto_scribble(x + 15, y + 5, string("x{0}", _qtd), .2);
    }
    //se ainda não existe
    else
    {
        draw_sprite_ext(sprite, minerio.sprite, x, y, escala, escala, 0, c_black, 1);
        texto_scribble(x + 15, y + 5, "???", .2);
    }
}