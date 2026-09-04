cam = view_camera[0];

//medidas base
cam_width = camera_get_view_width(cam);
cam_height  = camera_get_view_height(cam);

//zoom
zoom_min     = .2;
zoom_max     = 2.5;
zoom_atual   = .5;
zoom_destino = .5;
zoom_speed   = .15; //speed do lerp do zoom

//arrastar
mouse_x_prev = 0;
mouse_y_prev = 0;
arrastando   = false;




centraliza_camera = function()
{
    if (instance_exists(obj_upgrade))
    {
        //pegando o tamanho da cam
        var _w = cam_width * zoom_atual;
        var _h = cam_height * zoom_atual;
        
        //centralizando
        var _x = stamina_max.x - _w / 2;
        var _y = stamina_max.y - 20 - _h / 2;
        
        //travando os valores
        _x = clamp(_x, 0, room_width - _w);
        _y = clamp(_y, 0, room_height - _h);
        
        //aplicando o tamanho e a posição
        camera_set_view_size(cam, _w, _h);
        camera_set_view_pos(cam, _x, _y);
    }
}

processa_zoom = function()
{
    //lendo scroll
    var _scroll = mouse_wheel_down() - mouse_wheel_up();
    
    if (_scroll != 0)
    {
        //aplicando o zoom
        zoom_destino += _scroll * zoom_speed;
        zoom_destino = clamp(zoom_destino, zoom_min, zoom_max);
    }
    
    //suavizando o zoom
    zoom_atual = lerp(zoom_atual, zoom_destino, zoom_speed);
    
    //novo tamanho do view
    var _novo_w = cam_width * zoom_atual;
    var _novo_h = cam_height  * zoom_atual;
    
    //posicao relativa do mouse na tela (0.0 a 1.0)
    var _porc_x = window_mouse_get_x() / window_get_width();
    var _porc_y = window_mouse_get_y() / window_get_height();
    
    //desloca a camera para aproximar onde o mouse aponta
    var _cam_w = camera_get_view_width(cam);
    var _cam_h = camera_get_view_height(cam);
    
    var _cam_x = camera_get_view_x(cam) + (_cam_w - _novo_w) * _porc_x;
    var _cam_y = camera_get_view_y(cam) + (_cam_h - _novo_h) * _porc_y;
    
    return 
    { 
        x: _cam_x, 
        y: _cam_y, 
        width: _novo_w, 
        height: _novo_h 
    };
}

processa_arrasto = function(_cam_x, _cam_y, _cam_w, _cam_h)
{
    var _janela_mx = window_mouse_get_x();
    var _janela_my = window_mouse_get_y();
    
    //inicio do clique
    if (mouse_check_button_pressed(mb_right)) 
    {
        arrastando = true;
        mouse_x_prev = _janela_mx;
        mouse_y_prev = _janela_my;
    }
    
    //durante o movimento
    if (mouse_check_button(mb_right) && arrastando) 
    {
        var _delta_x = _janela_mx - mouse_x_prev;
        var _delta_y = _janela_my - mouse_y_prev;
        
        //proporcao pixel tela para pixel room
        var _fator_x = _cam_w / window_get_width();
        var _fator_y = _cam_h / window_get_height();
        
        _cam_x -= _delta_x * _fator_x;
        _cam_y -= _delta_y * _fator_y;
        
        mouse_x_prev = _janela_mx;
        mouse_y_prev = _janela_my;
    }
    
    //fim do clique
    if (mouse_check_button_released(mb_right)) 
    {
        arrastando = false;
    }
    
    return 
    { 
        x: _cam_x, 
        y: _cam_y 
    };
}

camera_funcionamento = function()
{
    //calcula o zoom e foco
    var _z = processa_zoom();
    
    //calcula o arrasto da camera
    var _pos = processa_arrasto(_z.x, _z.y, _z.width, _z.height);
    
    //travamento nos limites da room
    var _x_final = clamp(_pos.x, 0, room_width - _z.width);
    var _y_final = clamp(_pos.y, 0, room_height - _z.height);
    
    //aplicação na camera
    camera_set_view_size(cam, round(_z.width), round(_z.height));
    camera_set_view_pos(cam, round(_x_final), round(_y_final));
}