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

//variavel pra criar a receita na refinação
receita = noone;



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
                if (room == rm_shop) interage_shop();
                else if (room == rm_refinacao) interage_refina();
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
        //mostrando o item no prato
        with (obj_prato) 
        {
            //mostrando o minério
            desenho = true;
            
            //dando as infos para a cesta
            item        = other.item;
            categoria   = other.categoria;
            sprite      = other.sprite;
            minerio     = other.minerio;
            
            //efeito no prato
            escala_efeito.squash(1.5, .8);
        }
        
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
        //resetando o efeito do custo
        if (item != other.item)
        {
            valor_desenhado = 0;
        }
        
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
        var _qtd_venda = 0;
        
        //definindo o modo de venda
        if (global.modo_venda == "MAX")
        {
            _qtd_venda = _qtd;
        }
        else
        {
            _qtd_venda = min(_qtd, global.modo_venda);
        }
        
        //tirando o minerio
        global.inventario_global[$ categoria][$item] -= _qtd_venda;
        
        //ganhando dinheiro
        global.moeda += minerio.get_valor() * _qtd_venda;
        
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
    
    //fundo
    draw_sprite_ext(spr_livro_slot, 0, x, y, escala, escala, 0, c_white, 1);
    
    //desenhando os itens descobertos
    if (_qtd != undefined)
    {
        var _texto = string("{0}", _qtd);
        var _recuo = 35;
        
        //se tem mais que 0
        if (_qtd > 0)
        {
            draw_sprite_ext(sprite, minerio.sprite, x, y_efeito, _xscale, _yscale, 0, c_white, 1);
            texto_scribble(x + _recuo, y + _recuo, _texto, .2,, 1, 1);
        }
        //se n tem
        else
        {
            draw_sprite_ext(sprite, minerio.sprite, x, y_efeito, _xscale, _yscale, 0, c_gray, .5);
        }
    }
    //se n foi descoberto
    else
    {
        draw_sprite_ext(sprite, minerio.sprite, x, y_efeito, _xscale, _yscale, 0, c_black, .3);
        texto_scribble(x, y, "?", .4,, 1, 1);
    }
}