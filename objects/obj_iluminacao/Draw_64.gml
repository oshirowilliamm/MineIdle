if (surface_exists(sombra_surface))
{
    //desenhando na surface
    surface_set_target(sombra_surface);
    
    var _cam = view_camera[0];
    var _escala = 2;
    
    //pegando posição do player
    if (!instance_exists(obj_player)) exit;
    var _xplayer = (obj_player.x - camera_get_view_x(_cam)) * _escala;
    var _yplayer = (obj_player.yy - camera_get_view_y(_cam)) * _escala;
    
    //desenhando o retangulo preto
    draw_set_colour(c_black);
    draw_set_alpha(.99);
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), 0);
    draw_set_alpha(1);
    draw_set_colour(c_white);
    
    gpu_set_blendmode(bm_subtract);
    
    //iluminação da tocha
    var _raio_tocha = 96;
    
    if (instance_exists(obj_tocha))
    {
        var _num = instance_number(obj_tocha);
        
        for (var i = 0; i < _num; i++)
        {
            var _inst = instance_find(obj_tocha, i);
            
            //posição da tocha
            var _xtocha = (_inst.x - camera_get_view_x(_cam)) * _escala;
            var _ytocha = (_inst.y - camera_get_view_y(_cam)) * _escala;
            
            //circulo de iluminação
            draw_set_alpha(.7);
            draw_circle(_xtocha, _ytocha, _raio_tocha + irandom(1), 0);
            
            //circulo mais afastado
            draw_set_alpha(.5)
            draw_circle(_xtocha, _ytocha, (_raio_tocha * 2) + irandom(1), 0);
            draw_set_alpha(1);
        } 
    }
    
    //iluminação do player
    var _raio_player = 64;
    
    //circulo de iluminação 1
    draw_set_alpha(.7);
    draw_circle(_xplayer, _yplayer, _raio_player + irandom(1), 0);
    
    //circulo de iluminação 2
    //draw_set_alpha(.5)
    //draw_circle(_xplayer, _yplayer, (_raio_player * 2) + irandom(1), 0);
    //
    ////circulo de iluminação 3
    //draw_set_alpha(.3)
    //draw_circle(_xplayer, _yplayer, (_raio_player * 4) + irandom(1), 0);
    draw_set_alpha(1);
    
    gpu_set_blendmode(bm_normal);
    
    surface_reset_target();
}
//cria a surface se n foi criada
else
{
    sombra_surface = surface_create(display_get_gui_width(), display_get_gui_height());
}

draw_surface(sombra_surface, 0, 0);