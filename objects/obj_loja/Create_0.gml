sprite_index = sprite;
tecla = noone;


entrando_loja = function()
{
    if (!instance_exists(obj_player)) exit;
    
    //pegando distancia do player
    var _dist = point_distance(x, y_origem, obj_player.x, obj_player.y);
    
    //só mostra as infos se estiver perto
    if (_dist <= 40)
    {
        //criando a tecla
        if (!instance_exists(tecla))
        {
            tecla = instance_create_depth(obj_player.x, obj_player.y - 40, -999, obj_tecla);
        }
        
        //indo pra room
        if (keyboard_check_pressed(ord("E")))
        {
            cria_transicao_inicia(destino);
            
            //desativando o player
            obj_player.estado = obj_player.estado_desativado;
        }
    }
    //destruindo a tecla
    else
    {
        if (instance_exists(tecla))
        {
            instance_destroy(tecla);
        }
    }
}