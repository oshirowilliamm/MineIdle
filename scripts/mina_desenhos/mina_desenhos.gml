//rachaduras
function mina_desenha_rachaduras(_bloco, _x, _y)
{
    if (!_bloco) return false;
    if (_bloco.index == BLOCOS.vazio || _bloco.index == BLOCOS.borda) return false;
    
    //pegando vida maxima e atual do bloco
    var _hp_max = bloco_defs[_bloco.index].hp;
    var _hp_atual = _bloco.hp;
    
    //porcentagens
    var _porc = (_hp_atual / _hp_max) * 100;
    var _1 = 80, _2 = 60, _3 = 40, _4 = 20;
    
    //validação de se a vida estiver cheia
    if (_hp_atual >= _hp_max) return false;
    
    //desenhando quebrado de acordo com a vida do bloco
    var _index = 0;
    
    if (_porc <= 100 && _porc > _1)     _index = 0; //100% da vida
    else if (_porc <= _1 && _porc > _2) _index = 1; //80% da vida
    else if (_porc <= _2 && _porc > _3) _index = 2; //60% da vida
    else if (_porc <= _3 && _porc > _4) _index = 3; //40% da vida
    else if (_porc <= _4)               _index = 4; //20% da vida
    
    //desenhando as rachaduras
    draw_sprite(spr_rachaduras, _index, _x, _y);
}

//brilho 
function mina_desenha_brilho(_bloco, _x, _y)
{
    //não desenhar:
    if (_bloco.index == BLOCOS.vazio || _bloco.index == BLOCOS.borda || _bloco.index == BLOCOS.pedra) 
        return;
    
    // Desenha o brilho por cima do bloco
    draw_sprite(spr_brilho, brilho_frame, _x, _y);
}

