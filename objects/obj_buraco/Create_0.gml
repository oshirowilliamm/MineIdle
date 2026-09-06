tecla = noone;


entrando_mina = function()
{
    global.spawn_x = SPAWN_X_MINA;
    global.spawn_y = SPAWN_Y_MINA;
    
    cria_transicao(rm_mina);
    
    obj_player.estado = obj_player.estado_desativado;
}