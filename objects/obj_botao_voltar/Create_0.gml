escala = new efeito_escala();



voltar = function()
{
    cria_transicao(rm_vila, sq_transicao_1_loja, sq_transicao_2_loja, "tela");
    
    //corrigindo bug do spawn da vila
    if (global.dest_x == -1)
    {
        global.spawn_x = SPAWN_X_VILA;
        global.spawn_y = SPAWN_Y_VILA;
    }
    else
    {
        global.spawn_x = global.dest_x;
        global.spawn_y = global.dest_y;
    }
}