escala = 4;
inventario = false;


desenha_mochila = function()
{
    var _x = 30;
    var _y = 150;
    
    //interagindo
    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);
    var _x1 = _x - (sprite_get_width(spr_mochila) * escala) / 2;
    var _y1 = _y - (sprite_get_height(spr_mochila) * escala) / 2;
    var _x2 = _x + (sprite_get_width(spr_mochila) * escala) / 2;
    var _y2 = _y + (sprite_get_height(spr_mochila) * escala) / 2;
    var _rectangle = point_in_rectangle(_mx, _my, _x1, _y1, _x2, _y2);
    
    if (_rectangle)
    {
        //selecionado
        draw_sprite_ext(spr_mochila, 1, _x, _y, escala, escala, 0, c_white, 1);
        
        //abrindo inventario
        var _click = mouse_check_button_pressed(mb_left);
        if (_click) inventario = !inventario;
    }
    else
    {
        //não selecionado
        draw_sprite_ext(spr_mochila, 0, _x, _y, escala, escala, 0, c_white, 1);
    }
}

abre_inventario = function()
{
    if (!inventario) exit;
        
    //desenhando o fundo
    draw_sprite_stretched(spr_fundo, 0, 0, 0, 300, 1000);
}