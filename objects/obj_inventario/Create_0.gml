//efeitos
inicia_efeito_squash();


x_geral = 0;
y_geral = display_get_gui_height() / 4;
escala = global.escala_hud;

//variaveis da ficha
ficha_xscale = escala;
ficha_yscale = escala;

//variaveis do livro
x_livro = 0;
y_livro = (display_get_gui_height() / 2) + 10;

//variaveis do texto
texto_xscale = .2;
texto_yscale = .2;

//variaveis de controle
inventario = false;
desenhar = false;
pagina_atual = 0;



desenha_inventario = function()
{
    //sprite do livro
    x_livro = x_geral - (sprite_get_width(spr_livro_hud) * escala) + 80;
    draw_sprite_ext(spr_livro_hud, 0, x_livro, y_livro, escala, escala, 0, c_white, 1);
    
    desenha_pagina();
    
    //sprite da ficha
    draw_sprite_ext(spr_ficha, 0, x_geral, y_geral, ficha_xscale * xscale, ficha_yscale * yscale, 0, c_white, 1);   
    
    //texto
    texto_scribble(x_geral + 10, y_geral, "Inventário", texto_xscale * xscale, texto_yscale * yscale, , 1);
    
    //interagindo
    if (mouse_sobre_ui(x_geral, y_geral, spr_ficha, ficha_xscale, ficha_yscale))
    {
        xscale = lerp(xscale, 1.5, .1);
        yscale = lerp(yscale, 1.5, .1);
        
        //clicando
        if (mouse_check_button_pressed(mb_left))
        {
            inventario = !inventario;
            desenhar = true;
        }
    }
    else
    {
        retorna_squash();
    }
}

desenha_pagina = function()
{
    if (!desenhar) return;
    
    var _xbruto     = x_livro + 75;
    var _xlimpo     = _xbruto + 130;
    var _xrefinado  = _xlimpo + 130;
    var _yinicial   = y_livro - 250;
    
    //desenhando todos os minerios
    var _minerios_bioma = global.paginas_livro[pagina_atual];
    
    for (var i = 0; i < array_length(_minerios_bioma); i++)
    {
        var _yatual = _yinicial + (i * 120);
        
        //desenhando os minerios brutos
        var _item_bruto = _minerios_bioma[i];
        
        desenha_itens(_item_bruto, "minerios", _xbruto, _yatual, spr_minerios);
        
        //desenhando os minerios limpos
        var _item_limpo = _item_bruto + "_limpo";
        
        if (global.minerios[$ _item_limpo] != undefined)
        {
            desenha_itens(_item_limpo, "limpos", _xlimpo, _yatual, spr_limpos);
        }
        
        //desenhando os minerios refinados         
        var _item_refinado = _item_bruto + "_refinado";
        
        if (global.minerios[$ _item_refinado] != undefined)
        {
            desenha_itens(_item_refinado, "refinados", _xrefinado, _yatual, spr_refinados);
        }
    }
}

desenha_itens = function(_minerio, _categoria, _x, _y, _sprite)
{
    var _item = global.minerios[$ _minerio];
    
    //pegando a categoria pelo inventario
    var _inventario = global.inventario_global[$ _categoria];
    
    //pegando a quantidade do minério e vendo se ele existe
    var _qtd = _inventario[$ _minerio];
    
    //se existir
    if (_qtd != undefined)
    {
        draw_sprite_ext(_sprite, _item.sprite, _x, _y, escala, escala, 0, c_white, 1);
        var _texto = "x" + string(_qtd);
        texto_scribble(_x + 10, _y, _texto, .3);
    }
    //se n existir
    else
    {
        draw_sprite_ext(_sprite, _item.sprite, _x, _y, escala, escala, 0, c_black, 1);
        texto_scribble(_x + 10, _y, "???", .3);
    }
}

abre_inventario = function()
{
    if (inventario)
    {
        //puxando o livro
        x_geral = lerp(x_geral, 450, .1);
    }
    else
    {
        //devolvendo o livro
        x_geral = lerp(x_geral, 0, .1);
        
        //esconde os itens
        if (x_geral <= 0.5) desenhar = false;
    }
}