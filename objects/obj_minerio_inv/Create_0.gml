inicia_efeito_squash();

escala = global.escala_hud;
minerio = global.minerios[$ item];

//posicao inicial
if (room == rm_vila)
{
    x_inicial = x - obj_inventario.x_livro;
    y_inicial = y - obj_inventario.y_livro;
}

//efeito de shakes
shake = false;
shake_timer = 10;
shake_x = 0;




segue_inventario = function()
{
    if (room != rm_vila) return;
    
    x = obj_inventario.x_livro + x_inicial;
    y = obj_inventario.y_livro + y_inicial;
}

selecao = function()
{
    //pegando a quantidade do item
    var _qtd = global.inventario_global[$ categoria][$item];
    
    //verifica se o mouse esta em cima
    if (mouse_sobre_ui(x, y, sprite, escala))
    {
        //se foi descoberto
        if (_qtd != undefined)
        {
            //efeito squash apenas se tem mais que 0
            if (_qtd > 0)
            {
                xscale = lerp(xscale, 1.5, .1);
                yscale = lerp(yscale, 1.5, .1);
            }
            else
            {
                retorna_squash();
            }
            
            //função de venda
            interage_shop();
        }
        //se n foi descoberto
        else
        {
            //efeito de shake
            if (mouse_check_button_pressed(mb_left))
            {
                shake = true;
            }
        }
    }
    else
    {
        retorna_squash();
    }
}

efeito_shake = function()
{
    //efeito de shake no item não descoberto
    if (shake)
    {
        //diminuindo o timer
        shake_timer--;
        
        //efeito de tremer
        if (shake_timer > 0)
        {
            shake_x = dsin(shake_timer * 50) * 3;
        }
        //resetando o shake
        else
        {
            shake_timer = 10;
            shake = false;
            shake_x = 0;
        }
    }
}

interage_shop = function()
{
    if (room != rm_shop) return;
    
    //mostrando as infos dos itens na balança
    with (obj_balanca) 
    {
        desenho = true;
        
        item        = other.item;
        categoria   = other.categoria;
        sprite      = other.sprite;
        minerio     = other.minerio;
    }
    
    //vendendo minerio
    if (mouse_check_button_pressed(mb_left))
    {
        var _qtd = global.inventario_global[$ categoria][$item];
        
        if (_qtd > 0) 
        {
            //tirando o minerio
            global.inventario_global[$ categoria][$item]--;
            
            //ganhando dinheiro
            global.moeda += minerio.valor;
            
            //efeitos
            efeito_squash(1, 1);
            obj_balanca.aplica_efeitos();
        }
    }
}

desenha_minerio = function()
{
    //pegando a quantidade do item
    var _qtd = global.inventario_global[$ categoria][$item];
    
    //se existe
    if (_qtd != undefined)
    {
        //se tem mais que 0
        if (_qtd > 0)
        {
            draw_sprite_ext(sprite, minerio.sprite, x, y, escala * xscale, escala * yscale, 0, c_white, 1);
            texto_scribble(x + 15, y + 5, string("x{0}", _qtd), .2);
        }
        //se n tem
        else
        {
            draw_sprite_ext(sprite, minerio.sprite, x, y, escala * xscale, escala * yscale, 0, c_gray, .5);
            texto_scribble(x + 15, y + 5, string("x{0}", _qtd), .2, , , , c_gray, .5);
        }
        
    }
    //se ainda não existe
    else
    {
        draw_sprite_ext(sprite, minerio.sprite, x + shake_x, y + shake_x, escala, escala, 0, c_black, 1);
        texto_scribble(x + 15 + shake_x, y + 5 + shake_x, "???", .2);
    }
}