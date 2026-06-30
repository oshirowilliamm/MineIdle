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



//controla a geração de blocos conforme a chance de spawn
function mina_gera_blocos()
{
    var _random = irandom(global.chance_spawn_total - 1); //faz um irandom(99)
    var _acumulador = 0;
    
    //pega um bloco aleatorio e sua chance de spawn
    for (var i = 0; i < array_length(global.bloco_defs); i++)
    {
        //bloco que nao foi escolhido para somar com a chance do proximo bloco
        _acumulador += global.bloco_defs[i].chance_spawn;
        //caso o bloco escolhido nao for menor que a porcentagem de aparecer
        if (_random < _acumulador) return i; //retorna o bloco escolhido
    }
    
    //retorna a pedra por segurança
    return BLOCOS.pedra;
}



//minerando
function mina_minera_bloco(_x, _y, _dano)
{
    var _bloco = mina_get_bloco(_x, _y);
    
    //validações
    if (!_bloco) return false;
    if (_bloco.index == BLOCOS.vazio) return false;
    if (_bloco.index == BLOCOS.borda) return false;
    
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
    mina_cria_drop(_xcentro, _ycentro, _bloco.index);
    
    //zerando bloco
    _bloco.index = BLOCOS.vazio;
    _bloco.hp = 0;
    
    //atualizando os tiles
    atualiza_tiles(_x, _y);
}

//cria o drop
function mina_cria_drop(_x, _y, _bloco_id)
{
    //passando informações pro drop 
    var _bloco_def = global.bloco_defs[_bloco_id];
    var _drop_infos = 
    {
        index:      _bloco_def.sprite_drop,     //mudando o sprite index do drop de acordo com o tipo do bloco
        item:       _bloco_id - 1,              //item de acordo com o tipo do bloco
    }
    
    //criando a quantidade de vezes que o bloco pedir
    repeat (_bloco_def.quantidade_drop) 
    {
        //criando o drop
        var _drop = instance_create_layer(_x, _y, "Drops", obj_drop, _drop_infos);
    }
}

//regenera o bloco
function mina_regenera_bloco()
{
    var _tempo = 5000;

    mina_blocos_visiveis(function(_bloco, _x, _y)
    {
        if (_bloco == undefined) exit;
        if (_bloco.index == BLOCOS.vazio) exit;
        
        if (_bloco.hp >= global.bloco_defs[_bloco.index].hp) exit;
        if (current_time - _bloco.tempo_dano < _tempo) exit;
        
        _bloco.hp++;
        desenha_rachadura(_x, _y);
    });
}