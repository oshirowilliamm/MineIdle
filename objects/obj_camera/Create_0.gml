cam = view_camera[0];

// Medidas base
largura_base = camera_get_view_width(cam);
altura_base  = camera_get_view_height(cam);

// Zoom Contínuo
zoom_min     = .2;  // Limite máximo de aproximação
zoom_max     = 2.5;  // Limite máximo de afastamento
zoom_atual   = .5;
zoom_destino = .5;
zoom_speed   = .15; // Quão suave o zoom acompanha o scroll
zoom_step    = .15; // Quantidade de zoom por "click" do scroll

// Arrastar
mouse_x_prev = 0;
mouse_y_prev = 0;
arrastando   = false;

// Centralizar câmera por padrão
var _x = (room_width / 2) - (largura_base / 2);
var _y = (room_height / 2) - (altura_base / 2);
camera_set_view_pos(cam, _x, _y);





camera_funcionamento = function()
{
    // Lendo dados atuais da câmera
    var _cam_x = camera_get_view_x(cam);
    var _cam_y = camera_get_view_y(cam);
    var _cam_w = camera_get_view_width(cam);
    var _cam_h = camera_get_view_height(cam);
    
    // zoom
    var _scroll = mouse_wheel_down() - mouse_wheel_up();
    
    if (_scroll != 0)
    {
        // Adiciona ou subtrai do destino (zoom fluido)
        zoom_destino += _scroll * zoom_step;
        
        // Trava nos limites permitidos
        zoom_destino = clamp(zoom_destino, zoom_min, zoom_max);
    }
    
    // Suavização do zoom
    zoom_atual = lerp(zoom_atual, zoom_destino, zoom_speed);
    
    // Calculando novo tamanho
    var _novo_w = largura_base * zoom_atual;
    var _novo_h = altura_base  * zoom_atual;
    
    // Zoom guiado pela posição do mouse na tela (0.0 a 1.0)
    var _porc_x = window_mouse_get_x() / window_get_width();
    var _porc_y = window_mouse_get_y() / window_get_height();
    
    // Aplica o deslocamento para o zoom focar no mouse
    _cam_x += (_cam_w - _novo_w) * _porc_x;
    _cam_y += (_cam_h - _novo_h) * _porc_y;
    
    var _janela_mx = window_mouse_get_x();
    var _janela_my = window_mouse_get_y();
    
    // Início do arrasto
    if (mouse_check_button_pressed(mb_right)) 
    {
        // Só arrasta se não estiver clicando em um nó/UI
        if (!position_meeting(mouse_x, mouse_y, obj_upgrade_velho))
        {
            arrastando = true;
            mouse_x_prev = _janela_mx;
            mouse_y_prev = _janela_my;
        }
    }
    
    // Durante o arrasto
    if (mouse_check_button(mb_right) && arrastando) 
    {
        var _delta_x = _janela_mx - mouse_x_prev;
        var _delta_y = _janela_my - mouse_y_prev;
        
        // Conversão de escala (pixel da tela -> pixel da room)
        var _fator_x = _novo_w / window_get_width();
        var _fator_y = _novo_h / window_get_height();
        
        _cam_x -= _delta_x * _fator_x;
        _cam_y -= _delta_y * _fator_y;
        
        mouse_x_prev = _janela_mx;
        mouse_y_prev = _janela_my;
    }
    
    // Fim do arrasto
    if (mouse_check_button_released(mb_right)) 
    {
        arrastando = false;
    }
    
    // Evita que a câmera saia da room
    _cam_x = clamp(_cam_x, 0, room_width - _novo_w);
    _cam_y = clamp(_cam_y, 0, room_height - _novo_h);
    
    // Aplica o tamanho e a posição de uma vez só (arredondado para evitar screen tearing)
    camera_set_view_size(cam, round(_novo_w), round(_novo_h));
    camera_set_view_pos(cam, round(_cam_x), round(_cam_y));
}