//tile de acordo com o tipo de bloco
function mina_tile_tipo(_bloco_tipo)
{
    switch (_bloco_tipo) 
    {
        case BLOCOS.pedra:      return 1;
        case BLOCOS.roxo:       return 2;
        case BLOCOS.verde:      return 3;  
        case BLOCOS.azul:       return 4;
        case BLOCOS.amarelo:    return 5;  
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

//tile da borda
function mina_cria_tile_borda(_bloco, _x, _y)
{
    //se o bloco é um bloco de borda
    if (_bloco.index != BLOCOS.borda) exit;
    
    
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