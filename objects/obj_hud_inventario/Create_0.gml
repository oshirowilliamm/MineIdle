//variaveis gerais
escala_max = 4;
x_geral = 0;
y_geral = display_get_gui_height() / 4;

//variaveis da ficha
escala_ficha = escala_max;
escala_texto_max = .5;
escala_texto = escala_texto_max;

//variaveis do livro
escala_livro = escala_max;
x_livro = 0;
y_livro = (display_get_gui_height() / 2) + 15;

//controle pra abrir o inventario
inventario = false;
desenhar   = false; 


desenha_livro = function()
{
    //desenhando o livro atras
    x_livro = x_geral - (sprite_get_width(spr_livro_hud) * escala_livro) + 80;
    draw_sprite_ext(spr_livro_hud, 0, x_livro, y_livro, escala_livro, escala_livro, 0, c_white, 1);
    
    desenha_itens();
    
    //desenhando a ficha
    draw_sprite_ext(spr_ficha, 0, x_geral, y_geral, escala_ficha, escala_ficha, 0, c_white, 1);
    
    //texto
    draw_set_font(fnt_ui);
    draw_set_valign(1);
    
    texto_scribble(x_geral + 10, y_geral, "Inventario", escala_texto);
    
    draw_set_font(-1);
    draw_set_valign(-1);
    
    
    //draw_rectangle(_x1, _y1, _x2, _y2, 0);
    
    //interagindo
    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);
    var _x1 = x_geral - (sprite_get_width(spr_ficha) * escala_ficha);
    var _y1 = y_geral - (sprite_get_height(spr_ficha) * escala_ficha) / 2;
    var _x2 = x_geral + (sprite_get_width(spr_ficha) * escala_ficha);
    var _y2 = y_geral + (sprite_get_height(spr_ficha) * escala_ficha) / 2;
    var _rectangle = point_in_rectangle(_mx, _my, _x1, _y1, _x2, _y2);
    
    if (_rectangle)
    {
        //selecionado
        escala_ficha = lerp(escala_ficha, escala_max * 1.5, .1);
        escala_texto = lerp(escala_texto, escala_texto_max * 1.5, .1);
        
        //abrindo inventario
        var _click = mouse_check_button_pressed(mb_left);
        if (_click) 
        {
            inventario = !inventario;
            desenhar = true;
        }
    }
    else
    {
        //não selecionado
        escala_ficha = lerp(escala_ficha, escala_max, .1);
        escala_texto = lerp(escala_texto, escala_texto_max, .1);
    }
}

desenha_itens = function()
{
    if (!desenhar) return;
    
    draw_set_font(fnt_ui);
    draw_set_valign(1);
    draw_set_halign(1);
    
    var _x = x_livro + 80;
    var _y = y_livro - 280;
    
    //desenhando os minérios normais
    for (var i = 0; i < array_length(global.inventario.minerio); i++)
    {
        var _atual = global.inventario.minerio[i];
        
        //sprite
        var _hsprite = (sprite_get_height(spr_minerios) * escala_livro);
        var _y1 = _y + (i * (_hsprite + 60));
        draw_sprite_ext(spr_minerios, i, _x, _y1, escala_livro, escala_livro, 0, c_white, 1);
        
        //quantidade
        var _texto = "X " + string(_atual.quantidade);
        var _escala = .6;
        var _yqtd = _y1 + 50;
        
        texto_scribble(_x, _yqtd, _texto, _escala);
    }
    
    //desenhando os minérios refinados
    for (var i = 0; i < array_length(global.inventario.refinado); i++)
    {
        var _atual = global.inventario.refinado[i];
        
        //sprite
        var _hsprite = (sprite_get_height(spr_refinados) * escala_livro);
        var _x2 = _x + 250;
        var _y2 = _y + (i * (_hsprite + 60)) + (_hsprite + 60);
        draw_sprite_ext(spr_refinados, i, _x2, _y2, escala_livro, escala_livro, 0, c_white, 1);
        
        //quantidade
        var _texto = "X " + string(_atual.quantidade);
        var _escala = .6;
        var _yqtd = _y2 + 50;
        
        texto_scribble(_x2, _yqtd, _texto, _escala);
    }
    
    draw_set_font(-1);
    draw_set_valign(-1);
    draw_set_halign(-1);
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