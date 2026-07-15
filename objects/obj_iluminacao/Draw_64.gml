if (surface_exists(sombra_surface))
{
    //desenhando na surface
    surface_set_target(sombra_surface);
    
    //pegando posição do player
    if (!instance_exists(obj_player)) exit;
    var _xplayer = obj_player.x - camera_get_view_x(view_camera[0]);
    var _yplayer = obj_player.y - camera_get_view_y(view_camera[0]);
    world
    
    //desenhando o retangulo preto
    draw_set_colour(c_black);
    draw_set_alpha(.8);
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), 0);
    draw_set_alpha(1);
    draw_set_colour(c_white);
    
    //tirando um circulo da surface
    gpu_set_blendmode(bm_subtract);
    draw_circle(_xplayer, _yplayer, 24, 0);
    gpu_set_blendmode(bm_normal);
    
    surface_reset_target();
}
//cria a surface se n foi criada
else
{
    sombra_surface = surface_create(display_get_gui_width(), display_get_gui_height());
}

draw_surface(sombra_surface, 0, 0);