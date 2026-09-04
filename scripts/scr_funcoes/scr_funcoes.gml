//deixando jogo aleatorio
randomise();

function restart()
{
    if (keyboard_check_pressed(ord("R"))) 
    {
        //moeda
        global.moeda = 50;
        
        //inventario da sacola
        global.sacola = 
        {
            max_peso: 50,
            peso_atual: 0,
            
            itens: {},
        };
        
        //inventario global (da vila)
        global.inventario_global =
        {
            minerios: {},
            limpos: {},
            refinados: {},
        }
        
        //stamina
        global.stamina_max = 50;
        global.stamina_atual = global.stamina_max;
        
        //lanterna do player
        global.alcance_lanterna = .3;
        global.brilho_lanterna = 1;
        
        //picareta
        global.picareta = 
        {
            dano: 5,
            cooldown: 15
        };
        
        global.upgrades =
        {
            stamina_max: new cria_upgrade("Stamina", "Aumenta a stamina em 10", 0, 10, function()
            {
                global.stamina_max += 10;
            }),
            
            capacidade_max: new cria_upgrade("Capacidade", "Aumenta a capacidade em 10", 1, 20, function()
            {
                global.sacola.max_peso += 10;
            }),
            
            alcance_lanterna: new cria_upgrade("Alcance da Lanterna", "Aumenta o alcance da lanterna em 1", 2, 30, function()
            {
                global.alcance_lanterna += .1;
            }),
        }
        
        room_restart();
    }
}


//toca audio
function toca_som(_snd, _pitch = .1)
{
    var _p = random_range(1 - _pitch, 1 + _pitch);
    audio_play_sound(_snd, 0, 0, , , _p);
}


//sombra
function desenha_sombra(_scale = .5)
{
	//garatindo que o y sempre esteja no pe
	var _y = y - sprite_yoffset + sprite_height; 
	draw_sprite_ext(spr_sombra, 0, x, _y, _scale, _scale, 0, c_white, .25);
}


function mouse_sobre_ui(_x, _y, _sprite, _escala_x = 1, _escala_y = _escala_x)
{
    //mouse
    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);    
    
    //tamanho da sprite
    var _w  = sprite_get_width(_sprite) * _escala_x;
    var _h  = sprite_get_height(_sprite) * _escala_y;
    var _ox = sprite_get_xoffset(_sprite) * _escala_x;
    var _oy = sprite_get_yoffset(_sprite) * _escala_y;
    
    //posição
    var _x1 = _x - _ox;
    var _y1 = _y - _oy;
    var _x2 = _x1 + _w;
    var _y2 = _y1 + _h;
    
    //retangulo
    return point_in_rectangle(_mx, _my, _x1, _y1, _x2, _y2);
}


function cria_persistentes(_player = true, _controller = true, _hud = true, _debug = true)
{
    //player
    if (!instance_exists(obj_player) && _player) 
    {
        //definindo posição do player
        if (array_contains(global.rooms_mina, room))
        {
            global.spawn_x = 20;
            global.spawn_y = 270;
        }
        else
        {
            global.spawn_x = 928;
            global.spawn_y = 530;
        }
        
        //criando a layer
        if (!layer_exists("Player"))
        {
            layer_create(0, "Player");
        }
        
        instance_create_layer(global.spawn_x, global.spawn_y, "Player", obj_player);
    }
    
    //controller
    if (!instance_exists(obj_controller) && _controller) 
    {
        instance_create_layer(0, 0, "HUD", obj_controller);
    }
    
    //hud
    if (!instance_exists(obj_hud) && _hud) 
    {
        instance_create_layer(0, 0, "HUD", obj_hud);
    }
    
    //debug
    if (!instance_exists(obj_debug) && _debug) 
    {
        instance_create_layer(0, 0, "HUD", obj_debug);
    }
}


//converte uma posição da room em uma posição da gui
function room_to_gui(_x, _y, _cam = view_camera[0])
{
    var _cam_x = camera_get_view_x(_cam);
    var _cam_y = camera_get_view_y(_cam);
    var _cam_w = camera_get_view_width(_cam);
    var _cam_h = camera_get_view_height(_cam);
    
    var _gui_w = display_get_gui_width();
    var _gui_h = display_get_gui_height();
    
    //convertendo
    var _xgui = ((_x - _cam_x) / _cam_w) * _gui_w;
    var _ygui = ((_y - _cam_y) / _cam_h) * _gui_h;
    
    return
    {
        x: _xgui,
        y: _ygui
    }
}