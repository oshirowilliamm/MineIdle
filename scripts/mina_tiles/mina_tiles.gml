
//tile de acordo com o tipo de bloco
function mina_tile_tipo(_bloco_tipo)
{
    switch (_bloco_tipo) 
    {
        case BLOCOS.pedra:      return 1;
        case BLOCOS.roxo:       return 2;
        case BLOCOS.laranja:    return 3;  
        case BLOCOS.verde:      return 4;
        case BLOCOS.rosa:       return 5;  
        default:                return 0;
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
            
            //parede do bloco embaixo
            mina_cria_tile_parede(_bloco, _x, _y);
            
            //bloco de borda
            mina_cria_tile_borda(_chunk, _id, _bloco, _x, _y);
            mina_cria_tile_borda_parede(_id, _bloco, _x, _y);
        }
    }
}

//função para apagar ou atualizar os tiles
function mina_atualiza_tiles(_x, _y)
{
    //apagando os tiles do bloco 
    tilemap_set_at_pixel(global.tile_minerio , 0, _x, _y);
    
    //atualizando bloco de baixo
    mina_atualiza_baixo(_x, _y);
    
    //atualiza bloco de cima
    mina_atualiza_cima(_x, _y);
    
    //atualizando borda
    mina_atualiza_borda(_x, _y); //bloco principal
    mina_atualiza_borda(_x, _y - MINA_SIZE_H); //vizinho cima
    mina_atualiza_borda(_x + MINA_SIZE_W, _y); //vizinho direita
    mina_atualiza_borda(_x, _y + MINA_SIZE_H); //vizinho baixo
    mina_atualiza_borda(_x - MINA_SIZE_W, _y); //vizinho esquerda
    mina_atualiza_borda(_x + MINA_SIZE_W, _y - MINA_SIZE_H); //vizinho cima direita
    mina_atualiza_borda(_x - MINA_SIZE_W, _y - MINA_SIZE_H); //vizinho cima esquerda
    mina_atualiza_borda(_x + MINA_SIZE_W, _y + MINA_SIZE_H); //vizinho baixo direita
    mina_atualiza_borda(_x - MINA_SIZE_W, _y + MINA_SIZE_H); //vizinho baixo esquerda
}





//tile do bloco
function mina_cria_tile_bloco(_bloco, _x, _y)
{
    //se bloco existe
    if (_bloco.index == BLOCOS.vazio) exit;
    
    //pegando infos do tile do topo
    var _tile = mina_tile_tipo(_bloco.index);
    
    //desenhando o tile do topo
    tilemap_set_at_pixel(global.tile_minerio, _tile, _x, _y);
}

//tile da parede
function mina_cria_tile_parede(_bloco, _x, _y)
{
    //se bloco existe
    if (_bloco.index == BLOCOS.vazio) exit;
    
    //bloco de baixo
    var _baixo = mina_get_bloco(_x, _y + MINA_SIZE_H);
    
    if (_baixo && _baixo.index == BLOCOS.vazio)
    {
        //pegando infos do tile do topo
        var _tile = mina_tile_tipo(_bloco.index);
        
        //desenhando o tile do topo
        tilemap_set_at_pixel(global.tile_chao, _tile, _x, _y + MINA_SIZE_H);
    }
}



//checa se um bloco vizinho é borda ou não
function mina_bloco_borda(_x, _y)
{
    var _bloco = mina_get_bloco(_x, _y);
    
    //se o bloco não for uma struct (for 0, false, noone, undefined ou fora do mapa), trata como borda
    if (!is_struct(_bloco)) return true;
    
    //se o bloco for borda, retorna true
    if (_bloco.index == BLOCOS.borda) return true;
    
    //se for outra coisa retorna falso
    return false;
}

//tile da borda
function mina_cria_tile_borda(_chunk, _id, _bloco, _x, _y)
{
    //se o bloco é um bloco de borda
    if (_bloco.index != BLOCOS.borda) exit;
    
    //checando os vizinhos
    var _top            = mina_bloco_borda(_x, _y - MINA_SIZE_H);
    var _right          = mina_bloco_borda(_x + MINA_SIZE_W, _y);
    var _bottom         = mina_bloco_borda(_x, _y + MINA_SIZE_H);
    var _left           = mina_bloco_borda(_x - MINA_SIZE_W, _y);
    var _top_right      = mina_bloco_borda(_x + MINA_SIZE_W, _y - MINA_SIZE_H);
    var _top_left       = mina_bloco_borda(_x - MINA_SIZE_W, _y - MINA_SIZE_H); 
    var _bottom_right   = mina_bloco_borda(_x + MINA_SIZE_W, _y + MINA_SIZE_H);
    var _bottom_left    = mina_bloco_borda(_x - MINA_SIZE_W, _y + MINA_SIZE_H);
    
    //calculando valor do bitmask (0 a 15)
    var _valor = 0;
    if (_top)           _valor += 1;
    if (_right)         _valor += 2;
    if (_bottom)        _valor += 4;
    if (_left)          _valor += 8;
    
    //variavel para guardar o tile id
    var _tile = 0;
    
    //colocando as bordas para cada valor
    switch (_valor) 
    {
        //bloco cercado por outros
        case 0: _tile = 1; break;
        
        //bordas retas
        case 14: _tile = 12; break; //superior
        case 7:  _tile = 33; break; //esquerda
        case 13: _tile = 39; break; //direita
        case 11: _tile = 60; break; //inferior
        
        //bordas canto externo
        case 12: _tile = 13; break; //superior direita
        case 6:  _tile = 11; break; //superior esquerda
        case 9:  _tile = 61; break; //inferior direita
        case 3:  _tile = 59; break; //inferior esquerda
        
        //bordas canto interno
        case 15:
            if (!_top_right)         _tile = 29; //superior direita
            else if (!_top_left)     _tile = 27; //superior esquerda
            else if (!_bottom_right) _tile = 45; //inferior direita
            else if (!_bottom_left)  _tile = 43; //inferior esquerda
            else                     _tile = 1;  //padrão (parte escura)
        break;
        
        //default
        default: _tile = 1; break;
    }
    
    //desenhando o tile da borda
    tilemap_set_at_pixel(global.tile_bordas, _tile, _x, _y);
}

//tile da parede da borda
function mina_cria_tile_borda_parede(_id, _bloco, _x, _y)
{
    //se o bloco é um bloco de borda
    if (_bloco.index != BLOCOS.borda) exit;
    
    //pegando borda de cima
    var _top    = mina_bloco_borda(_x, _y - MINA_SIZE_H);
    var _bottom = mina_bloco_borda(_x, _y + MINA_SIZE_H);
    
    //se tiver borda em cima e n tiver borda em baixo
    if (_top == true && _bottom == false)
    {
        var _tile = 68;
        
        //desenhando o tile da borda
        tilemap_set_at_pixel(global.tile_paredes, _tile, _x, _y + 32);
    } 
}





//atualiza o bloco de cima
function mina_atualiza_cima(_x, _y)
{
    //criando a parede de cima
    var _bloco = mina_get_bloco(_x, _y - MINA_SIZE_H);
    
    //se existe e não é vazio, cria a parede
    if (_bloco && _bloco.index != BLOCOS.vazio)
    {
        var _tile_data = mina_tile_tipo(_bloco.index);
        tilemap_set_at_pixel(global.tile_chao, _tile_data, _x, _y);
    }
}

//atualiza o bloco de baixo
function mina_atualiza_baixo(_x, _y)
{
    //apagando a parede de baixo
    var _bloco= mina_get_bloco(_x, _y + MINA_SIZE_H);
    
    //se o bloco de baixo existe e esta vazio, apaga a parede
    if (_bloco && _bloco.index == BLOCOS.vazio)
    {
        tilemap_set_at_pixel(global.tile_chao, 0, _x, _y + MINA_SIZE_H);
    }
}

//atualiza a borda
function mina_atualiza_borda(_x, _y)
{
    //limpando os tiles desse bloco
    tilemap_set_at_pixel(global.tile_bordas, 0, _x, _y);
    tilemap_set_at_pixel(global.tile_paredes, 0, _x, _y + MINA_SIZE_H);
    
    //pegando o bloco
    var _bloco = mina_get_bloco(_x, _y);
    
    //validação
    if (_bloco.index != BLOCOS.borda) exit;
    
    //atualizando a borda e a parede
    mina_cria_tile_borda(noone, noone, _bloco, _x, _y);
    mina_cria_tile_borda_parede(noone, _bloco, _x, _y);
}



