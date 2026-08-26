escala_max = 4;
escala_atual = escala_max;
inventario = false;


desenha_mochila = function()
{
    var _x = 0;
    var _y = display_get_gui_height() / 2;
    
    //interagindo
    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);
    var _x1 = _x - (sprite_get_width(spr_ficha) * escala_atual);
    var _y1 = _y - (sprite_get_height(spr_ficha) * escala_atual) / 2;
    var _x2 = _x + (sprite_get_width(spr_ficha) * escala_atual);
    var _y2 = _y + (sprite_get_height(spr_ficha) * escala_atual) / 2;
    var _rectangle = point_in_rectangle(_mx, _my, _x1, _y1, _x2, _y2);
    
    if (_rectangle)
    {
        //selecionado
        escala_atual = lerp(escala_atual, escala_max * 1.5, .1);
        
        //abrindo inventario
        var _click = mouse_check_button_pressed(mb_left);
        if (_click) inventario = !inventario;
    }
    else
    {
        //não selecionado
        escala_atual = lerp(escala_atual, escala_max, .1);
    }
    
    //desenhando a mochila
    draw_sprite_ext(spr_ficha, 0, _x, _y, escala_atual, escala_atual, 0, c_white, 1);
    
    
    //draw_rectangle(_x1, _y1, _x2, _y2, 0);
}

abre_inventario = function()
{
    if (!inventario) exit;
        
    //desenhando o fundo
    draw_sprite_stretched(spr_fundo, 0, 0, 0, 300, 1000);
}