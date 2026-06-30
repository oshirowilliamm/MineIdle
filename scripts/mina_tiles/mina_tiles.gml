//desenha o bloco
function mina_desenha_bloco(_x, _y, _tipo)
{
    //pegando infos do tile
    var _id = layer_tilemap_get_id("tl_minerios");
    var _tile = get_tile_tipo(_tipo);
    
    //setando o tile
    tilemap_set_at_pixel(_id, _tile, _x, _y);
}

//apagando o bloco
function mina_apaga_bloco(_x, _y)
{
    //pegando infos do tile
    var _id = layer_tilemap_get_id("tl_minerios");
    
    //setando o tile
    tilemap_set_at_pixel(_id, 0, _x, _y);
}

//apaga rachadura
function mina_apaga_rachadura(_x, _y)
{
    //pegando infos do tile
    var _id = layer_tilemap_get_id("tl_rachaduras");
    
    //setando o tile
    tilemap_set_at_pixel(_id, 0, _x, _y);
}

//desenhando a parede do bloco
function mina_desenha_parede(_x,_y,_tipo)
{
    //pegando infos do tile
    var _id = layer_tilemap_get_id("tl_chao");
    var _tile = get_tile_tipo(_tipo);
    
    //setando o tile
    tilemap_set_at_pixel(_id, _tile, _x, _y);
}

//apaga parede
function mina_apaga_parede(_x, _y)
{
    //pegando infos do tile
    var _id = layer_tilemap_get_id("tl_chao");
    
    //setando o tile
    tilemap_set_at_pixel(_id, 0, _x, _y);
}

//atualiza os vizinhos do bloco quando for quebrado
function mina_atualiza_vizinhos(_x, _y)
{
    //pegando os blocos
    var _cima = mina_get_bloco(_x, _y - MINA_SIZE_H);
    var _baixo = mina_get_bloco(_x, _y + MINA_SIZE_H);
    
    //apagando de cima
    if (_cima && _cima.index != BLOCOS.vazio)
    {
        mina_apaga_parede(_x, _y - MINA_SIZE_H);
    }
    
    //apagando de baixo
    if (_baixo && _baixo.index != BLOCOS.vazio)
    {
        mina_apaga_parede(_x, _y + MINA_SIZE_H);
    }
}

//atualiza o tile
function mina_atualiza_tile(_x, _y)
{
    mina_apaga_bloco(_x, _y);
    mina_apaga_rachadura(_x, _y);
    mina_atualiza_vizinhos(_x, _y);
}

function mina_desenha_bloco_chunk(_chunk,_col,_row)
{
    var _id = mina_get_bloco_id(_col,_row);
    var _bloco = _chunk.blocos[_id];
    
    if (_bloco.index == BLOCOS.vazio) return;
    
    var _x = mina_grid_to_pixel_x(_col + (_chunk.index * MINA_CHUNK_W));
    var _y = mina_grid_to_pixel_y(_row);
    
    mina_desenha_bloco(_x, _y, _bloco.index);
}

function mina_cria_tiles(_id, _chunk)
{
    for (var i = 0; i < MINA_CHUNK_W; i++)
    {
        for (var j = 0; j< MINA_CHUNK_H; i++)
        {
            mina_desenha_bloco_chunk();
        }
    }
}