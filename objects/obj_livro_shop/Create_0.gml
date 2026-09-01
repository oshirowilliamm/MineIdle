inicia_efeito_squash();

escala = global.escala_hud;
pagina_atual = 0;

//controle para criar a pagina somente uma vez
pagina_criada = false;



cria_pagina = function()
{
    if (pagina_criada) return;
    
    //posição dos minerios
    var _xbruto     = 75;
    var _xlimpo     = _xbruto + 130;
    var _xrefinado  = _xlimpo + 130;
    var _yinicial   = display_get_gui_height() / 2 -250;
    
    var _pagina = global.paginas_livro[pagina_atual];
    
    //desenhando todos os minerios  
    for (var i = 0; i < array_length(_pagina); i++)
    {
        //definindo o y
        var _yatual = _yinicial + (i * 120);
        
        //////// BRUTOS /////////
        var _item_bruto = _pagina[i];
        
        var _infos = {item: _item_bruto, categoria: "minerios", sprite: spr_minerios};
        instance_create_depth(_xbruto, _yatual, -9999, obj_minerio_inv, _infos);
        
        //////// LIMPOS /////////
        var _item_limpo = _item_bruto + "_limpo";
        
        //eliminando a pedra da categoria
        if (global.minerios[$ _item_limpo] != undefined)
        {
            _infos = {item: _item_limpo, categoria: "limpos", sprite: spr_limpos};
            instance_create_depth(_xlimpo, _yatual, -9999, obj_minerio_inv, _infos);
        }
        
        //////// REFINADOS /////////      
        var _item_refinado = _item_bruto + "_refinado";
        
        //eliminando a pedra da categoria
        if (global.minerios[$ _item_refinado] != undefined)
        {
            _infos = {item: _item_refinado, categoria: "refinados", sprite: spr_refinados};
            instance_create_depth(_xrefinado, _yatual, -9999, obj_minerio_inv, _infos);
        }
    }
    
    pagina_criada = true;
}

desenha_itens = function(_minerio, _categoria, _x, _y, _sprite)
{
    var _item = global.minerios[$ _minerio];
    
    var _inventario = global.inventario_global[$ _categoria]; //pegando a categoria pelo inventario
    var _qtd = _inventario[$ _minerio]; //pegando a quantidade do minério e vendo se ele existe
    var _mouse_sobre_item = noone; //pegando se o item esta com mouse em cima ou não
    
    //mouse em cima do item
    if (mouse_sobre_ui(_x, _y, _sprite, escala))
    {
        //fazendo o efeito squash nesse minerio em especifico
        xscale = lerp(xscale, 1.5, .1);
        yscale = lerp(yscale, 1.5, .1);
        
        //se o item existir, eu aviso 
        if (_qtd != undefined) _mouse_sobre_item = _item;
    }
    
    //escala do item
    var _xscale = escala * xscale;
    var _yscale = escala * yscale;
    
    //se existir
    if (_qtd != undefined)
    {
        draw_sprite_ext(_sprite, _item.sprite, _x, _y, _xscale, _yscale, 0, c_white, 1);
        var _texto = "x" + string(_qtd);
        texto_scribble(_x + 10, _y, _texto, .3);
    }
    //se n existir
    else
    {
        draw_sprite_ext(_sprite, _item.sprite, _x, _y, escala, escala, 0, c_black, 1);
        texto_scribble(_x + 10, _y, "???", .3);
    }
    
    //retornando o mouse sobre
    return _mouse_sobre_item;
}

item_sobre = function(_item, _categoria, _x, _y)
{
    //mouse em cima
    if (_item != noone)
    {
        texto_scribble(_x, _y, "ok");
    }
    //mouse fora
    else
    {
        xscale = lerp(xscale, 1, .1);
        yscale = lerp(yscale, 1, .1);
    }
}