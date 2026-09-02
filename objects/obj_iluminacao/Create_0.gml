depth = -999;

cam = view_camera[0];
sombra_surface = surface_create(camera_get_view_width(cam), camera_get_view_height(cam));



//luz do player
luz_player = function(_cam_x, _cam_y)
{
    if (!instance_exists(obj_player)) return;
    
    with (obj_player) 
    {
    	//pegando posição do player
        var _x = x - _cam_x;
        var _y = yy - _cam_y;
        
        var _flick = random_range(-0.01, 0.01);
        var _brilho = (global.alcance_lanterna * 2) + (_flick * 2);
        var _escala = global.alcance_lanterna + _flick;
        
        //se tiver na vila, o alcance fica grandão
        if (room == rm_vila)
        {
            _escala = 8;
            _brilho = 1;
        }
        
        //desenhando a luz
        draw_sprite_ext(spr_circulo_luz, 0, _x, _y, _escala, _escala, 0, cor_luz, _brilho);
    }
}

//luz de um ponto
luz_ponto = function(_cam_x, _cam_y)
{
    if (!instance_exists(obj_ilumina_ponto)) return
    
    with (obj_ilumina_ponto) 
    {
        //posição
        var _x = x - _cam_x;
        var _y = y - _cam_y;
        
    	//desenhando a luz
        draw_sprite_ext(spr_circulo_luz, 0, _x, _y, alcance, alcance, 0, cor_luz, brilho);
    }
}

//luz do poste
luz_poste = function(_cam_x, _cam_y, alpha = 1)
{
    if (!instance_exists(obj_ilumina_poste)) return
    
    with (obj_ilumina_poste) 
    {
        //posição
        var _x = x - _cam_x;
        var _y = y - _cam_y;
        
    	var _flick = random_range(-0.02, 0.02);
        var _escala = .8 + _flick;
        var _brilho = (1 + (_flick * 2)) * alpha;
        
        //desenhando a luz
        draw_sprite_ext(spr_circulo_luz, 0, _x, _y, _escala, _escala, 0, cor_poste, _brilho);
    }
}

//luz da tocha
luz_tocha = function(_cam_x, _cam_y)
{
    //iluminação da tocha
    if (!instance_exists(obj_tocha)) return
    
    with (obj_tocha) 
    {
    	//posição
        var _x = x - _cam_x;
        var _y = y - _cam_y;
        
        var _flick = random_range(-0.01, 0.01);
        var _escala = 2 + _flick;
        var _brilho = 1 + (_flick * 2);
        
        //desenhando a luz
        draw_sprite_ext(spr_circulo_luz, 0, _x, _y, _escala, _escala, 0, cor_luz, _brilho);
    }
}

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
        draw_clear(cor_sombra);
        
        //iluminação
        gpu_set_blendmode(bm_add);
        
        luz_player(_cam_x, _cam_y);
        luz_ponto(_cam_x, _cam_y);
        
        gpu_set_blendmode(bm_normal);
        luz_poste(_cam_x, _cam_y);
        
        surface_reset_target();
    }
    //cria a surface se n foi criada
    else
    {
        sombra_surface = surface_create(_cam_w, _cam_h);
    }
    
    //aplicando a surface
    gpu_set_blendmode_ext(bm_dest_colour, bm_zero);
    draw_surface(sombra_surface, _cam_x, _cam_y);
    
    //desenhando o poste acima da surface
    gpu_set_blendmode(bm_add);
    luz_poste(0, 0, .2);
    
    gpu_set_blendmode(bm_normal);
}