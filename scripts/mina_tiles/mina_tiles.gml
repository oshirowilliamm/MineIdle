//tile de acordo com o tipo de bloco
function mina_tile_tipo(_bloco_tipo)
{
    switch (_bloco_tipo) 
    {
        case BLOCOS.pedra:      return 0;
        case BLOCOS.roxo:       return 1;
        case BLOCOS.laranja:    return 2;  
        case BLOCOS.verde:      return 3;
        case BLOCOS.rosa:       return 4;  
        default:                return -1;
    }
}

//checando conexão entre o bloco e o vizinho pro bitmask
function mina_checa_conexao(_vizinho, _tipo)
{
    //se o vizinho n existe
    if (!_vizinho) return false;
    
    //se for borda, conecta so com borda
    if (_tipo == BLOCOS.borda)
    {
        return _vizinho.index == BLOCOS.borda;
    }
    
    //se for minerio, conecta com minerios
    var _minerio = mina_tile_tipo(_tipo) > -1;
    var _minerio_vizinho = mina_tile_tipo(_vizinho.index) > -1;
    
    if (_minerio && _minerio_vizinho)
    {
        return true;
    }
    
    //se for outra coisa
    return _vizinho.index == _tipo;
}

//pegando o bitmask do minerio
function mina_get_bitmask(_x, _y, _tipo)
{
    //pegando os vizinhos
    var _top    = mina_get_bloco(_x, _y - MINA_SIZE_H);
    var _right  = mina_get_bloco(_x + MINA_SIZE_W, _y);
    var _bottom = mina_get_bloco(_x, _y + MINA_SIZE_H);
    var _left   = mina_get_bloco(_x - MINA_SIZE_W, _y);
    
    ////////////// BITMASK RETAS E DIAGONAIS EXTERNAS //////////////
    var _valor = 0;
    if (mina_checa_conexao(_top, _tipo))        _valor += 1; //topo
    if (mina_checa_conexao(_right, _tipo))      _valor += 2; //direita
    if (mina_checa_conexao(_bottom, _tipo))     _valor += 4; //baixo
    if (mina_checa_conexao(_left, _tipo))       _valor += 8; //esquerda
    
    var _valor_final = _valor;
    
    ////////////// BITMASK DIAGONAIS INTERNAS //////////////
    if (_valor == 15)
    {
        //pegando os vizinhos da diagonal
        var _top_right    = mina_get_bloco(_x + MINA_SIZE_W, _y - MINA_SIZE_H);
        var _top_left     = mina_get_bloco(_x - MINA_SIZE_W, _y - MINA_SIZE_H); 
        var _bottom_right = mina_get_bloco(_x + MINA_SIZE_W, _y + MINA_SIZE_H);
        var _bottom_left  = mina_get_bloco(_x - MINA_SIZE_W, _y + MINA_SIZE_H);
        
        //pegando o valor de acordo com a diagonal
        if (!mina_checa_conexao(_top_right, _tipo))             _valor_final = 16; //superior direita
        else if (!mina_checa_conexao(_top_left, _tipo))         _valor_final = 17; //superior esquerda
        else if (!mina_checa_conexao(_bottom_right, _tipo))     _valor_final = 18; //inferior direita
        else if (!mina_checa_conexao(_bottom_left, _tipo))      _valor_final = 19; //inferior esquerda
        else                                                    _valor_final = 15; //padrão (parte escura)
    }
    
    ////////////// BITMASK PAREDE //////////////  
    var _parede = false;
    var _valor_parede = 22;
    
    //se tiver em baixo de uma borda e n tiver borda em baixo
    if (mina_checa_conexao(_top, _tipo) && !mina_checa_conexao(_bottom, _tipo)) 
    { 
        //setando que existe parede
        _parede = true;
        
        //pegando o valor da parede
        if (!mina_checa_conexao(_right, _tipo))         _valor_parede = 22; //parede com borda direita
        else if (!mina_checa_conexao(_left, _tipo))     _valor_parede = 20; //parece com borda esquerda 
        else                                            _valor_parede = 21; //padrão           
    }
    
    //retornando o valor do bloco e da parede e se tem parede
    return 
    {
        valor: _valor_final,
        parede: _parede,
        valor_parede: _valor_parede
    }
}



//cria tiles
function mina_cria_tiles(_id, _chunk)
{
    for (var i = 0; i < MINA_CHUNK_W; i++)
    {
        for (var j = 0; j < MINA_CHUNK_H; j++)
        {
            //bloco id
            var _id_bloco = mina_get_bloco_id(i,j);
            var _bloco = _chunk.blocos[_id_bloco];
            
            //posição do bloco
            var _x = mina_grid_to_pixel_x(i + _id * MINA_CHUNK_W);
            var _y = mina_grid_to_pixel_y(j);
            
            //bloco normal
            mina_cria_tile_bloco(_bloco, _x, _y);
            
            //bloco de borda
            mina_cria_tile_borda(_bloco, _x, _y);
        }
    }
}

//função para apagar ou atualizar os tiles
function mina_atualiza_tiles(_x, _y)
{
    //apagando os tiles do bloco 
    tilemap_set_at_pixel(global.tile_minerio, 0, _x, _y);
    tilemap_set_at_pixel(global.tile_paredes_minerio, 0, _x, _y + MINA_SIZE_H);
    
    //recalculando os 8 vizinhos (areas 3x3)
    for (var i = -1; i <= 1; i++)
    {
        for (var j = -1; j <= 1; j++)
        {
            //ignorando o centro
            if (i == 0 && j == 0) continue;
            
            //pegando posição do vizinho
            var _xvizinho = _x + (i * MINA_SIZE_W);
            var _yvizinho = _y + (j * MINA_SIZE_H);
            var _vizinho = mina_get_bloco(_xvizinho, _yvizinho);
            
            //se o vizinho existe e n ta vazio
            if (_vizinho && _vizinho.index != BLOCOS.vazio && _vizinho.index != BLOCOS.borda)
            {
                mina_cria_tile_bloco(_vizinho, _xvizinho, _yvizinho);
            }
        }
    }
}



//tile do bloco
function mina_cria_tile_bloco(_bloco, _x, _y)
{
    //se bloco existe
    if (_bloco.index == BLOCOS.vazio) exit;
    
    //pegando o indice da linha de acordo com o tipo do bloco
    var _linha = mina_tile_tipo(_bloco.index);
    var _bitmask = mina_get_bitmask(_x, _y, _bloco.index);
    
    //pegando o tile de acordo com o tipo
    var _tile = (_linha * 24) + _bitmask.valor + 1;
    var _tile_parede = (_linha * 24) + _bitmask.valor_parede + 1;
    
    if (_bitmask.parede)
    {
        //desenhando o tile do bloco em cima
        tilemap_set_at_pixel(global.tile_minerio, _tile, _x, _y);
        
        //desenhando o tile da parede
        tilemap_set_at_pixel(global.tile_paredes_minerio, _tile_parede, _x, _y + MINA_SIZE_H);
    }
    else
    {
        //desenhando o tile do bloco
        tilemap_set_at_pixel(global.tile_minerio, _tile, _x, _y);
    }
}

//tile da borda
function mina_cria_tile_borda(_bloco, _x, _y)
{
    //se o bloco é um bloco de borda
    if (_bloco.index != BLOCOS.borda) exit;
    
    //pegando o bitmask
    var _bitmask = mina_get_bitmask(_x, _y, BLOCOS.borda);
    
    if (_bitmask.parede)
    {
        //desenhando o tile da borda em cima
        tilemap_set_at_pixel(global.tile_bordas, _bitmask.valor + 1, _x, _y);
        
        //desenhando o tile da parede da borda
        tilemap_set_at_pixel(global.tile_paredes_borda, _bitmask.valor_parede + 1, _x, _y + MINA_SIZE_H);
    }
    else
    {
        //desenhando o tile da borda
        tilemap_set_at_pixel(global.tile_bordas, _bitmask.valor + 1, _x, _y);
    }
}




