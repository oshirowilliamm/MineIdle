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
texto_xscale = .15;
texto_yscale = .15;

//variaveis de controle
inventario = false;
desenhar = false;

//controle para criar a pagina somente uma vez
pagina_criada = false;

//pagina que muda o bioma
pagina_atual = 0;

info = noone;



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
        if (x_geral <= 0.5) 
        {
            desenhar = false;
            
            //se a pagina estava criada, nos a destruimos e destrancamos
            if (pagina_criada)
            {
                instance_destroy(obj_minerio_inv);
                pagina_criada = false;
            }
        }
    }
}

desenha_inventario = function()
{
    //sprite do livro
    x_livro = x_geral - (sprite_get_width(spr_livro_hud) * escala) + 80;
    draw_sprite_ext(spr_livro_hud, 0, x_livro, y_livro, escala, escala, 0, c_white, 1);
    
    //sprite da ficha
    draw_sprite_ext(spr_ficha, 0, x_geral, y_geral, ficha_xscale * xscale, ficha_yscale * yscale, 0, c_white, 1);   
    
    //texto
    texto_scribble(x_geral + 8, y_geral, "Inventory", texto_xscale * xscale, texto_yscale * yscale, , 1);
    
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

cria_pagina = function()
{
    if (!desenhar) return;
    if (pagina_criada) return;
    
    //posição dos minerios
    var _xbruto     = x_livro + 75;
    var _xlimpo     = _xbruto + 130;
    var _xrefinado  = _xlimpo + 130;
    var _yinicial   = y_livro - 250;
    
    var _pagina = global.paginas_livro[pagina_atual];
    
    //desenhando todos os minerios
    for (var i = 0; i < array_length(_pagina); i++)
    {
        //centralizando so a pedra
        if (string_pos("_pedra", _pagina[i]) != 0)
        {
            var _infos = {item: _pagina[i], categoria: "minerios", sprite: spr_minerios};
            instance_create_depth(_xlimpo, _yinicial, -9999, obj_minerio_inv, _infos);
        }
        //resto dos minerios
        else
        {
            //definindo o y
            var _yatual = _yinicial + (i * 120);
            
            //////// BRUTOS /////////
            var _item_bruto = _pagina[i];
            
            var _infos = {item: _item_bruto, categoria: "minerios", sprite: spr_minerios};
            instance_create_depth(_xbruto, _yatual, -9999, obj_minerio_inv, _infos);
            
            //////// LIMPOS /////////
            var _item_limpo = _item_bruto + "_limpo";
            
            _infos = {item: _item_limpo, categoria: "limpos", sprite: spr_limpos};
            instance_create_depth(_xlimpo, _yatual, -9999, obj_minerio_inv, _infos);
            
            //////// REFINADOS /////////      
            var _item_refinado = _item_bruto + "_refinado";
            
            _infos = {item: _item_refinado, categoria: "refinados", sprite: spr_refinados};
            instance_create_depth(_xrefinado, _yatual, -9999, obj_minerio_inv, _infos);
        }
    }
    
    pagina_criada = true;
}