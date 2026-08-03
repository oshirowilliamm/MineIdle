escala = 2;
sprite_index = sprite;
frame_tecla = 0;

desenha_ir = function()
{
    if (!instance_exists(obj_player)) exit;
    
    //pegando distancia do player
    var _dist = point_distance(x, y, obj_player.x, obj_player.y);
    
    //só mostra as infos se estiver perto
    if (_dist > 60) exit;
    
    //desenho
    var _x = x;
    var _y = y - 40;
    frame_tecla = draw_animation(frame_tecla, spr_tecla);
    draw_sprite_ext(spr_tecla, frame_tecla, _x, _y, escala, escala, 0, c_white, 1);
    
    //indo pra room
    if (keyboard_check_pressed(ord("E")))
    {
        room_goto(destino);
    }
}