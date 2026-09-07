function transicao_ignora_zoom_inicio()
{
    // Roda apenas no evento Draw principal
    if (event_type == ev_draw && event_number == 0)
    {
        // 1. Salva a câmera atual do jogo (com o zoom) para não perder
        global.cam_mat_view = matrix_get(matrix_view);
        global.cam_mat_proj = matrix_get(matrix_projection);

        // 2. Pega o tamanho real da sua GUI/Janela
        var _w = display_get_gui_width();
        var _h = display_get_gui_height();

        // 3. Acha onde deve ser o centro dessa nossa "câmera falsa"
        var _cam_x = 0;
        var _cam_y = 0;

        if (instance_exists(obj_transicao))
        {
            if (obj_transicao.tipo == "player" && instance_exists(obj_player))
            {
                // Foca no player
                _cam_x = obj_player.x - _w/2;
                _cam_y = obj_player.yy - _h/2;
            }
            else
            {
                // Foca no centro da câmera atual
                var _cam = view_camera[0];
                _cam_x = camera_get_view_x(_cam) + camera_get_view_width(_cam)/2 - _w/2;
                _cam_y = camera_get_view_y(_cam) + camera_get_view_height(_cam)/2 - _h/2;
            }
        }

        // 4. Cria e aplica a câmera estática sem zoom APENAS para essa layer
        var _cx = _cam_x + _w/2;
        var _cy = _cam_y + _h/2;
        
        var _mat_v = matrix_build_lookat(_cx, _cy, -16000, _cx, _cy, 0, 0, -1, 0);
        var _mat_p = matrix_build_projection_ortho(_w, _h, 1, 32000);

        matrix_set(matrix_view, _mat_v);
        matrix_set(matrix_projection, _mat_p);
    }
}

function transicao_ignora_zoom_fim()
{
    // Devolve o zoom e a visão normais pro resto do jogo continuar funcionando
    if (event_type == ev_draw && event_number == 0)
    {
        matrix_set(matrix_view, global.cam_mat_view);
        matrix_set(matrix_projection, global.cam_mat_proj);
    }
}