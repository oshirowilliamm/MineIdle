escala_efeito = new efeito_escala();

escala = global.escala_hud;
minerio = global.minerios[$ item];

//posicao inicial
x_inicial = x - obj_inventario.x_livro;
y_inicial = y - obj_inventario.y_livro;

//efeito de shakes
shake = false;
shake_timer = 10;
shake_x = 0;

y_efeito = y;

//variaveis para qnd for refinação
bloqueado = false;
minerio_alpha = 1
minerio_cor = c_white;




segue_inventario = function()
{
    x = obj_inventario.x_livro + x_inicial;
    y = obj_inventario.y_livro + y_inicial;
}

bloqueando_item = function()
{
    bloqueado = false;
    
    if (global.refinacao_aberta)
    {
        //tirando a interação das pedras e dos refinados
        if (string_pos("_pedra", item) != 0 || categoria == "refinados")
        {
            bloqueado = true;
        }
        
        //bloqueando se n tem espaço na fila
        if (obj_lesma.tem_espaco(item) == false)
        {
            bloqueado = true;
        }
    }
    
    //mudando cor e alpha de acordo com o bloqueado
    if (bloqueado)
    {
        minerio_alpha = .5;
        minerio_cor = c_gray;
    }
    else
    {
        minerio_alpha = 1;
        minerio_cor = c_white;
    }
}



interage_shop = function()
{
    //efeitos
    escala_efeito.atualiza(1.2);
    y_efeito = lerp(y_efeito, ystart - 15, .1);
    
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
    if (global.mouse_pressed)
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
        global.dados.moeda += minerio.get_valor() * _qtd_venda;
        
        //efeitos
        escala_efeito.squash(.6, 1.4);
        y_efeito = ystart - 30;
        obj_balanca.aplica_efeitos();
    }
}

interage_refina = function()
{
    //tirando a pedra e os refinados
    if (!bloqueado)
    {
        //efeitos
        escala_efeito.atualiza(1.2);
        y_efeito = lerp(y_efeito, ystart - 15, .1);
        
        //avisando a lesma
        obj_lesma.boca_aberta = true;
        
        //clicando
        if (global.mouse_clicado)
        {
            //criando o minerio que vai pra boca
            var _struct = {sprite: sprite, index: minerio.sprite, item: item};
            instance_create_depth(x, y, depth - 1, obj_minerio_boca, _struct);
            
            //tirando o minerio
            global.inventario_global[$ categoria][$item]--;
            
            //colocando o minerio na fila
            obj_lesma.entra_fila(item, sprite, minerio.sprite);
            
            //efeitos
            escala_efeito.squash(.6, 1.4);
            y_efeito = ystart - 30;
        }
    }
    else
    {
        escala_efeito.retorna();
        y_efeito = lerp(y_efeito, ystart, .1);
    }
}

interage_vila = function()
{
    //efeitos
    escala_efeito.atualiza(1.2);
    y_efeito = lerp(y_efeito, ystart - 15, .1);
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
                //interação
                if (room == rm_shop)
                {
                    interage_shop();
                }
                else if (global.refinacao_aberta)
                {
                    interage_refina();
                }
                else
                {
                    interage_vila();
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
            if (global.mouse_pressed)
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
            draw_sprite_ext(sprite, minerio.sprite, x, y_efeito, _xscale, _yscale, 0, minerio_cor, minerio_alpha);
            texto_scribble(x + _recuo, y + _recuo, _texto,,, 1, 1);
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
        texto_scribble(x, y, "?",,, 1, 1);
    }
}