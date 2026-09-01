var _mouse_sobre = position_meeting(mouse_x, mouse_y, id);
var _mouse_click = mouse_check_button_pressed(mb_left);

if (_mouse_sobre)
{
    tween(id, "image_xscale", 1.2, tween_animation.elastic_out);
    tween(id, "image_yscale", 1.2, tween_animation.elastic_out);
    
    if (_mouse_click)
    {
        cria_transicao_inicia(destino);
        global.spawn_x = spawn_x;
        global.spawn_y = spawn_y;
    }
}
else
{
    tween(id, "image_xscale", 1, tween_animation.back, 30);
    tween(id, "image_yscale", 1, tween_animation.back, 30);
}