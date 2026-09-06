
//função que chama a transicao
function cria_transicao(_destino = noone, _transicao1 = sq_transicao_1, _transicao2 = sq_transicao_2, _tipo = "player")
{
    //se tiver rolando uma transicao, n ativa
    if (global.transicao) return;
    
    //se o destino n existe, rola um debug
    if (!room_exists(_destino)) 
    {
        show_message("defina um destino")
        return;
    }
    
    //avisando que a transicao esta true
    global.transicao = true;
    
    //criando o objeto transição
    var _infos = {destino: _destino, transicao1: _transicao1, transicao2: _transicao2, tipo: _tipo};
    instance_create_depth(0, 0, 0, obj_transicao, _infos);
}