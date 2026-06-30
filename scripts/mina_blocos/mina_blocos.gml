//pega o bloco de uma chunk (n eh global)
function mina_get_bloco(_x, _y)
{
    //pegando chunk do bloco
    var _chunk_id = mina_get_chunk_id(_x);
    
    //validação da existencia do chunk
    if (!variable_struct_exists(global.chunks, _chunk_id)) return false;
    
    //pegando posição da grid
    var _xgrid = mina_pixel_to_grid_x(_x);
    var _ygrid = mina_pixel_to_grid_y(_y);
    
    //validação de bloco fora do chunk verticalmente
    if (_ygrid < 0 || _ygrid >= MINA_CHUNK_H) return false;
    
    //acessando o chunk
    var _chunk_atual = global.chunks[$ _chunk_id];
    
    //pegando o id do bloco
    var _col = mina_get_chunk_col(_xgrid);
    var _bloco_id = mina_get_bloco_id(_col, _ygrid);
    
    //retornando a struct do bloco (com id e hp)
    return _chunk_atual.blocos[_bloco_id];
}

//minerando
function mina_minera_bloco(_x, _y, _dano)
{
    var _bloco = mina_get_bloco(_x, _y);
    
    //validações
    if (!_bloco) return false;
    if (_bloco.id == BLOCOS.vazio) return false;
    if (_bloco.id == BLOCOS.borda) return false;
    
    //funções
    //aplicando dano
    mina_dano_bloco(_bloco, _dano);
    
    //quebrando o bloco
    if (_bloco.hp <= 0 )
        mina_quebra_bloco(_x, _y, _bloco);
    
    return true;
}

//dano do bloco
function mina_dano_bloco(_bloco, _dano)
{
    //dano
    _bloco.hp -= _dano;
    
    //tempo que foi aplicado esse dano, pra regeneração
    _bloco.tempo_dano = current_time;
    
    //stamina
    global.stamina_atual -= global.stamina_dano;
}

//quebrando o bloco
function mina_quebra_bloco(_x, _y, _bloco)
{
    //posição central do bloco
    var _xcentro = mina_grid_to_pixel_x(mina_pixel_to_grid_x(_x)) + MINA_SIZE_W / 2;
    var _ycentro = mina_grid_to_pixel_y(mina_pixel_to_grid_y(_y)) + MINA_SIZE_H / 2;
    
    //criando drop
    cria_drop(_xcentro, _ycentro, _bloco.id);
    
    //zerando bloco
    _bloco.id = BLOCOS.vazio;
    _bloco.hp = 0;
    
    //atualizando os tiles
    atualiza_tiles(_x, _y);
}