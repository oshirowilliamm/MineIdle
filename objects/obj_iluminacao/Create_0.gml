debug = false;
sombra_surface = surface_create(display_get_gui_width(), display_get_gui_height());

//infos pro desenho
camera = view_camera[0];
escala = 2;

//escuridão (sombra)
desenha_escuridao = function()
{
    if (surface_exists(sombra_surface))
    {
        //desenhando na surface
        surface_set_target(sombra_surface);
        
        var _cam = view_camera[0];
        var _escala = 2;
        
        //desenhando o retangulo preto
        draw_set_colour(c_black);
        draw_set_alpha(.99);
        draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), 0);
        draw_set_alpha(1);
        draw_set_colour(c_white);
        
        //iluminação
        gpu_set_blendmode(bm_subtract);
        
        luz_player();
        luz_tocha();
        luz_checkpoint();
        
        gpu_set_blendmode(bm_normal);
        
        surface_reset_target();
    }
    //cria a surface se n foi criada
    else
    {
        sombra_surface = surface_create(display_get_gui_width(), display_get_gui_height());
    }
    
    draw_surface(sombra_surface, 0, 0);
}

//luz do player
luz_player = function()
{
    //pegando posição do player
    if (!instance_exists(obj_player)) exit;
    var _xplayer = (obj_player.x - camera_get_view_x(camera)) * escala;
    var _yplayer = (obj_player.yy - camera_get_view_y(camera)) * escala;
    
    var _flick = random_range(-0.01, 0.01); //flick
    var _escala = global.alcance_lanterna + _flick; //escala da lanterna (alcance)
    var _brilho = global.brilho_lanterna + (_flick * 2); //brilho
    
    //desenhando a luz
    draw_sprite_ext(spr_circulo_luz, 0, _xplayer, _yplayer, _escala, _escala, 0, c_yellow, _brilho);
}

//luz da tocha
luz_tocha = function()
{
    //iluminação da tocha
    if (instance_exists(obj_tocha))
    {
        var _num = instance_number(obj_tocha);
        
        for (var i = 0; i < _num; i++)
        {
            var _inst = instance_find(obj_tocha, i);
            
            //posição da tocha
            var _xtocha = (_inst.x - camera_get_view_x(camera)) * escala;
            var _ytocha = (_inst.y - camera_get_view_y(camera)) * escala;
            
            var _flick = random_range(-0.01, 0.01); //flick
            var _escala = 2 + _flick; //escala da lanterna (alcance)
            var _brilho = 2 + (_flick * 2); //brilho
            
            //desenhando a luz
            draw_sprite_ext(spr_circulo_luz, 0, _xtocha, _ytocha, _escala, _escala, 0, c_white, _brilho);
        } 
    }
}

//luz do checkpoint
luz_checkpoint = function()
{
    if (instance_exists(obj_ilumina_checkpoint))
    {
        var _num = instance_number(obj_ilumina_checkpoint);
        
        for (var i = 0; i < _num; i++)
        {
            var _inst = instance_find(obj_ilumina_checkpoint, i);
            
            //posição da tocha
            var _xcheck = (_inst.x - camera_get_view_x(camera)) * escala;
            var _ycheck = (_inst.y - camera_get_view_y(camera)) * escala;
            
            var _flick = random_range(-0.01, 0.01); //flick
            var _escala = 7 + _flick; //escala da lanterna (alcance)
            var _brilho = 7 + (_flick * 2); //brilho
            
            //desenhando a luz
            draw_sprite_ext(spr_circulo_luz, 0, _xcheck, _ycheck, _escala, _escala, 0, c_white, _brilho);
        } 
    }
}