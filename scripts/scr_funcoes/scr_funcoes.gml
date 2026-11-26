//deixando jogo aleatorio
randomise();


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


//detecta o mouse sobre alguma coisa no draw gui
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


//cria os objetos persistentes no começo da room
function cria_persistentes(_player = true, _controller = true, _hud = true, _debug = true)
{
    //player
    if (!instance_exists(obj_player) && _player) 
    {
        //definindo posição do player na mina
        if (array_contains(global.rooms_mina, room))
        {
            global.spawn_x = SPAWN_X_MINA;
            global.spawn_y = SPAWN_Y_MINA;
        }
        //na vila
        else
        {
            global.spawn_x = SPAWN_X_VILA;
            global.spawn_y = SPAWN_Y_VILA;
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
    if (DEBUG_MODE && !instance_exists(obj_debug) && _debug) 
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

//converte uma posição da gui em uma posição da room
function gui_to_room(_x, _y, _cam = view_camera[0])
{
    var _cam_x = camera_get_view_x(_cam);
    var _cam_y = camera_get_view_y(_cam);
    var _cam_w = camera_get_view_width(_cam);
    var _cam_h = camera_get_view_height(_cam);
    
    var _gui_w = display_get_gui_width();
    var _gui_h = display_get_gui_height();
    
    //convertendo
    var _xroom = _cam_x + (_x / _gui_w) * _cam_w;
    var _yroom = _cam_y + (_y / _gui_h) * _cam_h;
    
    return
    {
        x: _xroom,
        y: _yroom
    }
}


//tween para o image_xscale e image_yscale
function tween_scale (_dest, _anim, _time = 60)
{
    tween(id, "image_xscale", _dest, _anim, _time);
    tween(id, "image_yscale", _dest, _anim, _time);
}


//mensagem de debug: vai pro console e aparece na tela (obj_debug)
//uso: log_debug("bloco quebrado: " + tipo_bloco);
function log_debug(_texto)
{
    if (!DEBUG_MODE) return;
    
    _texto = string(_texto);
    show_debug_message("[debug] " + _texto);
    
    if (instance_exists(obj_debug)) obj_debug.adiciona_log(_texto);
}

/*function pega_receita(_item, _categoria)
{
    var _dados = global.minerios[$ _item];
    var _resultado = "";
    var _result_categoria = "";
    
    //transformando bruto em puro
    if (_categoria == "minerios")
    {
        _resultado = _item + "_puro";
        _result_categoria = "puros";
    }
    //transformando puro em refinado
    else if (_categoria == "puros")
    {
        _resultado = string_replace(_item, "_puro", "_refinado");
        _result_categoria = "refinados";
    }
    //acaba
    else
    {
        return undefined;
    }
    
    //retornando o resultado e a receita
    return
    {
        resultado: _resultado,
        categoria_resultado: _result_categoria,
        custo_pedras: _dados.pedras,
        custo_minerio: _dados.qtd_refina,
    }
}
*/