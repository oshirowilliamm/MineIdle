//função que chama a transicao
function cria_transicao(_destino = noone, _tipo = "player", _x = -1, _y = -1)
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
    var _infos = {destino: _destino, transicao1: sq_transicao_1, transicao2: sq_transicao_2, tipo: _tipo};
    instance_create_depth(0, 0, 0, obj_transicao, _infos);
    
    //se o destino for a vila é diferente
    if (_destino == rm_vila)
    {
        //sem destino guardado, nasce no spawn padrao da vila
        if (global.dest_x == -1)
        {
            global.spawn_x = SPAWN_X_VILA;
            global.spawn_y = SPAWN_Y_VILA;
        }
        //spawn de cada loja
        else
        {
            global.spawn_x = global.dest_x;
            global.spawn_y = global.dest_y;
            
            global.dest_x = -1;
            global.dest_y = -1;
        }
    }
    //definindo spawn de outros destinos
    else
    {
        global.spawn_x = _x;
        global.spawn_y = _y;
    }
}   