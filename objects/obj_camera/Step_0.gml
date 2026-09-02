//dados da camera
var _cam_x = camera_get_view_x(cam);
var _cam_y = camera_get_view_y(cam);
var _cam_w = camera_get_view_width(cam);
var _cam_h = camera_get_view_height(cam);

////////// ZOOM //////////
var _scroll = mouse_wheel_down() - mouse_wheel_up();

if (_scroll != 0)
{
    // Altera o índice do array com a roda do mouse
    zoom_indice += _scroll;
    
    // Trava para não passar dos limites do array
    zoom_indice = clamp(zoom_indice, 0, array_length(zoom_niveis) - 1);
    
    // Define o novo valor de destino
    zoom_destino = zoom_niveis[zoom_indice];
}

// Suavização opcional entre os níveis (se quiser instantâneo, basta usar zoom_atual = zoom_destino;)
zoom_atual = lerp(zoom_atual, zoom_destino, zoom_speed);

// NOVO TAMANHO DA CÂMERA
var _novo_w = largura * zoom_atual;
var _novo_h = altura  * zoom_atual;

//pegamos a posição do mouse na TELA (0.0 a 1.0) usando o tamanho da janela
var _porcentagem_x = window_mouse_get_x() / window_get_width();
var _porcentagem_y = window_mouse_get_y() / window_get_height();

//descobrimos a diferença entre o tamanho atual da câmera e o tamanho novo
var _diff_w = _cam_w - _novo_w;
var _diff_h = _cam_h - _novo_h;

//movemos a câmera somando essa diferença multiplicada pela posição do mouse
_cam_x += _diff_w * _porcentagem_x;
_cam_y += _diff_h * _porcentagem_y;

//aplicando novo tamanho da camera
camera_set_view_size(cam, round(_novo_w), round(_novo_h));



////////// ARRASTAR //////////
//tamanho da janela
var _janela_mx = window_mouse_get_x();
var _janela_my = window_mouse_get_y();

//se clicar esta arrastando
if (mouse_check_button_pressed(mb_left)) 
{
    if (!position_meeting(mouse_x, mouse_y, obj_upgrade_velho))
    {
        arrastando = true;
        mouse_x_prev = _janela_mx;
        mouse_y_prev = _janela_my;
    }
}

//enquanto estiver segurando o botão
if (mouse_check_button(mb_left) && arrastando) 
{
    //descobre quantos pixels reais o mouse moveu na tela
    var _delta_x = _janela_mx - mouse_x_prev;
    var _delta_y = _janela_my - mouse_y_prev;
    
    //converte a distância do monitor para a distância do mundo escalada pelo Zoom
    var _fator_zoom_x = _novo_w / window_get_width();
    var _fator_zoom_y = _novo_h / window_get_height();
    
    //movemos a câmera na direção OPOSTA (-=) ao movimento do mouse
    _cam_x -= _delta_x * _fator_zoom_x;
    _cam_y -= _delta_y * _fator_zoom_y;
    
    //atualiza a posição prévia para o próximo frame
    mouse_x_prev = _janela_mx;
    mouse_y_prev = _janela_my;
}

//quando soltar o botão
if (mouse_check_button_released(mb_left)) 
{
    arrastando = false;
}

// Aplicando novo tamanho da câmera
camera_set_view_size(cam, _novo_w, _novo_h);

// Limitando a câmera na sala
_cam_x = clamp(_cam_x, 0, room_width - _novo_w);
_cam_y = clamp(_cam_y, 0, room_height - _novo_h);

// Posição final da câmera sempre arredondada
camera_set_view_pos(cam, round(_cam_x), round(_cam_y));