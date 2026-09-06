sprite_index = sprite;
tecla = noone;




entra_loja = function()
{
    cria_transicao_inicia(destino);
    
    //desativando o player
    obj_player.estado = obj_player.estado_desativado;
    
    //definindo a posição do player quando voltar
    global.dest_x = dest_x;
    global.dest_y = dest_y;
}