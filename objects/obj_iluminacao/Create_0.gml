depth = -999;

cam = view_camera[0];
sombra_surface = surface_create(camera_get_view_width(cam), camera_get_view_height(cam));

//escuridão (sombra)
desenha_escuridao = function()
{
    var _cam_x = camera_get_view_x(cam);
    var _cam_y = camera_get_view_y(cam);
    var _cam_w = camera_get_view_width(cam);
    var _cam_h = camera_get_view_height(cam);
    
    if (surface_exists(sombra_surface))
    {
        //desenhando na surface
        surface_set_target(sombra_surface);
        
        var _cam = view_camera[0];
        var _escala = 2;
        
        //desenhando a escuridao
        draw_clear(#040404);
        
        //iluminação
        gpu_set_blendmode(bm_add);
        
        luz_player(_cam_x, _cam_y);
        //luz_tocha();
        //luz_checkpoint();
        
        gpu_set_blendmode(bm_normal);
        
        surface_reset_target();
    }
    //cria a surface se n foi criada
    else
    {
        sombra_surface = surface_create(_cam_w, _cam_h);
    }
    
    gpu_set_blendmode_ext(bm_dest_colour, bm_zero);
    draw_surface(sombra_surface, _cam_x, _cam_y);
    gpu_set_blendmode(bm_normal);
}

//luz do player
luz_player = function(_cam_x, _cam_y)
{
    if (!instance_exists(obj_player)) return;
    
    //pegando posição do player
    var _xplayer = obj_player.x - _cam_x;
    var _yplayer = obj_player.yy - _cam_y;
    
    var _flick = random_range(-0.01, 0.01); //flick
    var _escala = global.alcance_lanterna + _flick; //escala da lanterna (alcance)
    var _brilho = (global.alcance_lanterna * 2) + (_flick * 2);
    
    //desenhando a luz
    draw_sprite_ext(spr_circulo_luz, 0, _xplayer, _yplayer, _escala, _escala, 0, #f0eca4, _brilho);
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