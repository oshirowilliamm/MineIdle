
escala = global.escala_hud;

x_geral = 0;
y_geral = display_get_gui_height() / 2 - 200;

//variaveis do livro
x_livro = 0;
y_livro = (display_get_gui_height() / 2) + 60;

//variaveis do texto
texto_xscale = .15;
texto_yscale = .15;
espaco_x = 130;
espaco_y = 110;

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
    //se tiver nas lojas
    if (array_contains(global.rooms_vila, room))
    {
        x_geral = 450;
        inventario = true;
        desenhar = true;
        return;
    }
    
    //se tiver na vila
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

desenha_linhas = function()
{
    if (!desenhar) return;
    
    var _total_linhas = 5;
    
    var _x1 = x_livro + 48;
    var _x2 = x_livro + 420;
    var _yinicial = y_livro - 280;
    
    if (room != rm_refinacao)
    {
        for (var i = 0; i < _total_linhas; i++)
        {
            var _y =  _yinicial + (i * espaco_y) + 50;
            draw_line_width_colour(_x1, _y, _x2, _y, 4, #DEC6A4, #DEC6A4);
        }
    }
    else
    {
        for (var i = 0; i < _total_linhas - 1; i++)
        {
            _x1 = x_livro;
            _x2 = x_livro + 295;
            var _y = _yinicial + (i * espaco_y) + 140;
            draw_line_width_colour(_x1, _y, _x2, _y, 4, #DEC6A4, #DEC6A4);
        }
    }
}

desenha_inventario = function()
{
    //sprite do livro
    if (room != rm_refinacao)
    {
        x_livro = x_geral - (sprite_get_width(spr_livro) * escala) + 80;
        draw_sprite_ext(spr_livro, 0, x_livro, y_livro, escala, escala, 0, c_white, 1);
    }
    else
    {
        draw_sprite_ext(spr_livro, 0, x_livro - 120, y_livro, escala, escala, 0, c_white, 1);
    }
    
    //linhas de divisória
    desenha_linhas();
    
    //selo
    draw_sprite_ext(spr_selo, 0, x_livro + 235, y_livro + 243, escala, escala, 0, c_white, 1);
    
    //interagindo
    if (mouse_sobre_ui(x_livro, y_livro, spr_livro, escala))
    {
        //abrindo o livro
        inventario = true;
        desenhar = true;
    }
    else
    {
        inventario = false;
    }
}

cria_pagina = function()
{
    if (!desenhar) return;
    if (pagina_criada) return;
    
    //posição dos minerios
    var _x = x_livro + 105;
    var _yinicial   = y_livro - 280;
    
    var _pagina = global.paginas_livro[pagina_atual];
    
    //desenhando todos os minerios
    for (var i = 0; i < array_length(_pagina); i++)
    {
        var _item = _pagina[i];
        
        //centralizando so a pedra
        if (string_pos("_pedra", _item) != 0)
        {
            if (room != rm_refinacao)
            {
                var _infos = {item: _item, categoria: "minerios", sprite: spr_minerios};
                instance_create_depth(_x + espaco_x, _yinicial, -9999, obj_minerio_inv, _infos);
            }
        }
        //resto dos minerios
        else
        {
            //livro da vila
            if (room != rm_refinacao)
            {
                var _yatual = _yinicial + (i * espaco_y);
                
                //////// BRUTOS /////////
                var _infos = {item: _item, categoria: "minerios", sprite: spr_minerios};
                instance_create_depth(_x, _yatual, -9999, obj_minerio_inv, _infos);
                
                //////// PUROS /////////
                var _item_puro = _item + "_puro";
                
                _infos = {item: _item_puro, categoria: "puros", sprite: spr_puros};
                instance_create_depth(_x + espaco_x, _yatual, -9999, obj_minerio_inv, _infos);
                
                //////// REFINADOS /////////   
                var _item_refinado = _item + "_refinado";
                
                _infos = {item: _item_refinado, categoria: "refinados", sprite: spr_refinados};
                instance_create_depth(_x + espaco_x * 2, _yatual, -9999, obj_minerio_inv, _infos);
            }
            //livro da refinação
            else
            {
                var _yatual = _yinicial - 20 + (i * espaco_y);
                
                //////// BRUTOS /////////
                var _infos = {item: _item, categoria: "minerios", sprite: spr_minerios};
                instance_create_depth(_x, _yatual, -9999, obj_minerio_inv, _infos);
                
                //////// PUROS /////////
                var _item_puro = _item + "_puro";
                
                _infos = {item: _item_puro, categoria: "puros", sprite: spr_puros};
                instance_create_depth(_x + espaco_x, _yatual, -9999, obj_minerio_inv, _infos);
            }
        }
    }
    
    pagina_criada = true;
}