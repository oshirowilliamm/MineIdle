if (pode_ir)
{
    //definindo o spawn do player
    global.spawn_x = destino_x;
    global.spawn_y = destino_y;
    
    //criando a transicao
    cria_transicao_inicia(destino);
    
    //desativando o player
    other.estado = other.estado_desativado;
    
    pode_ir = false
}