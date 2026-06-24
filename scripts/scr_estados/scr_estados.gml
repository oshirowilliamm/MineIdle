//máquina de estados
function estado() constructor 
{
    //iniciando o estado
    static inicia= function() {};
    //rodando o estado
    static roda = function() {};
    //finalizando o estado
    static finaliza = function() {};
}

//funções para controlar a máquina de estados
function inicia_estado(_estado)
{
    //salvando estado atual
    estado_atual = _estado;
    
    //iniciando
    estado_atual.inicia();
}

function roda_estado()
{
    estado_atual.roda();
}

function troca_estado(_estado)
{
    //finalizando estado atual
    estado_atual.finaliza();
    
    //rodando prox estado
    estado_atual = _estado;
    
    //iniciando prox estado
    estado_atual.inicia();
}

function define_sprite(_dir = 0, _spr_side, _spr_front, _spr_back)
{
    var _sprite;
    
    switch (_dir) 
    {
        //direita
    	case 0: 
            _sprite = _spr_side; 
            xscale = 1;
        break;
    
        //cima
        case 1: 
            _sprite = _spr_back; 
        break;
    
        //esquerda
        case 2: 
            _sprite = _spr_side; 
            xscale = -1;
        break;
    
        //baixo
        case 3: 
            _sprite = _spr_front; 
        break;
    }
    
    return _sprite;
}