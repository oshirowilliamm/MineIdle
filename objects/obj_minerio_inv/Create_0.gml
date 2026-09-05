escala_efeito = new efeito_escala();

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

y_efeito = y;




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
            //se tem mais que 0
            if (_qtd > 0)
            {
                escala_efeito.atualiza(1.2);
                y_efeito = lerp(y_efeito, ystart - 15, .1);
                
                //interação
                if (room == rm_shop) 
                {
                    interage_shop();
                }
                else if (room == rm_refinacao) 
                {
                    interage_refina();
                }
            }
            //n tem nada
            else
            {
                escala_efeito.retorna();
                y_efeito = lerp(y_efeito, ystart, .1);
            }
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
        escala_efeito.retorna();
        y_efeito = lerp(y_efeito, ystart, .1);
    }
}

interage_refina = function()
{
    if (mouse_check_button_pressed(mb_left))
    {
        //mostrando o item na cesta
        with (obj_cesta) 
        {
            //se cliquei em um minerio diferente do que estava na cesta
            if (item != noone && item != other.item)
            {
                //devolvendo os itens
                global.inventario_global[$ categoria][$ item] += qtd;
                
                //zera o qtd
                qtd = 0;
            }
            
            //adicionando minerio
            qtd++;
            global.inventario_global[$ other.categoria][$ other.item]--;
            
            //mostrando o minério
            desenho = true;
            
            //dando as infos para a cesta
            item        = other.item;
            categoria   = other.categoria;
            sprite      = other.sprite;
            minerio     = other.minerio;
            
            //efeito na cesta
            escala_efeito.squash(.9, 1.5);
        }
        
        //mandando quantidade de pedras necessárias
        obj_alimente.categoria = categoria;
        obj_alimente.qtd = minerio.pedras;
        
        //efeitos
        escala_efeito.squash(.6, 1.4);
        y_efeito = ystart - 30;
    }
}

interage_shop = function()
{
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
        //tirando o minerio
        global.inventario_global[$ categoria][$item]--;
        
        //ganhando dinheiro
        global.moeda += minerio.valor;
        
        //efeitos
        escala_efeito.squash(.6, 1.4);
        y_efeito = ystart - 30;
        obj_balanca.aplica_efeitos();
    }
}

desenha_minerio = function()
{
    var _xscale = escala * escala_efeito.xscale;
    var _yscale = escala * escala_efeito.yscale;
    
    //pegando a quantidade do item
    var _qtd = global.inventario_global[$ categoria][$item];
    
    //se existe
    if (_qtd != undefined)
    {
        //se tem mais que 0
        if (_qtd > 0)
        {
            draw_sprite_ext(sprite, minerio.sprite, x, y_efeito, _xscale, _yscale, 0, c_white, 1);
            texto_scribble(x + 15, y + 5, string("x{0}", _qtd), .2);
        }
        //se n tem
        else
        {
            draw_sprite_ext(sprite, minerio.sprite, x, y_efeito, _xscale, _yscale, 0, c_gray, .5);
            texto_scribble(x + 15, y + 5, string("x{0}", _qtd), .2, , , , c_gray, .5);
        }
        
    }
}