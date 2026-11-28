//offset da camera
altura = 30;

//variaveis da camera e zoom da refinação
cam = view_camera[0];
cam_width = camera_get_view_width(cam);
cam_height = camera_get_view_height(cam);
zoom = .8;
foco = 0;




atualiza_camera = function()
{
    if (!instance_exists(obj_player)) return;
    
    //indo pro destino do foco
    var _destino = global.refinacao_aberta ? 1 : 0;
    foco = lerp(foco, _destino, .05);
    
    //ponto A: camera normal no sapo
    var _x = clamp(obj_player.x - cam_width / 2, 0, room_width - cam_width);
    var _y = clamp(obj_player.y - altura - cam_height / 2, 0, room_height - cam_height);
    
    //ponto B: camera na lesma, ja com o tamanho final
    if (instance_exists(obj_lesma))
    {
        var _w = cam_width * zoom;
        var _h = cam_height * zoom;
        var _xlesma = clamp(obj_lesma.x - 60 - _w / 2, 0, room_width - _w);
        var _ylesma = clamp(obj_lesma.y - 60 - _h / 2, 0, room_height - _h);
        
        //misturando A e B
        _x = lerp(_x, _xlesma, foco);
        _y = lerp(_y, _ylesma, foco);
    }
    
    //aplicando o tamanho e a posição
    var _zoom = lerp(1, zoom, foco);
    camera_set_view_size(cam, cam_width * _zoom, cam_height * _zoom);
    camera_set_view_pos(cam, _x, _y);
}

atualiza_camera();