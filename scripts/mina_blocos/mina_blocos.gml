//pega o bloco de uma chunk (n eh global)
function mina_get_bloco(_x, _y)
{
    //pegando chunk do bloco
    var _chunk_id = mina_get_chunk_id(_x);
    
    //validação da existencia do chunk
    if (!variable_struct_exists(chunks, _chunk_id)) return false;
    
    //pegando posição da grid
    var _xgrid = mina_pixel_to_grid_x(_x);
    var _ygrid = mina_pixel_to_grid_y(_y);
    
    //validação de bloco fora do chunk verticalmente
    if (_ygrid < 0 || _ygrid >= MINA_CHUNK_H) return false;
    
    //acessando o chunk
    var _chunk_atual = chunks[$ _chunk_id];
    
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
    if (_bloco.index == BLOCOS.vazio) return false;
    
    //funções
    //aplicando dano
    mina_dano_bloco(_bloco, _dano, _x, _y);
    
    //quebrando o bloco
    if (_bloco.hp <= 0 )
        mina_quebra_bloco(_x, _y, _bloco);
    
    return true;
}

//dano do bloco
function mina_dano_bloco(_bloco, _dano, _x, _y)
{
    //dano
    _bloco.hp -= _dano;
    
    //tempo que foi aplicado esse dano, pra regeneração
    _bloco.tempo_dano = current_time;
    
    //stamina
    global.stamina_atual -= global.stamina_dano;
    
    //colocando o bloco como machucado pra regeneração
    if (!variable_struct_exists(_bloco, "machucado") || _bloco.machucado == false) {
        array_push(blocos_machucados, _bloco);
        _bloco.machucado = true;
    }
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
    _bloco.machucado = false;
    
    //atualizando os tiles
    mina_atualiza_tiles(_x, _y);
}





//cria o drop
function mina_cria_drop(_x, _y, _bloco_id)
{
    //passando informações pro drop 
    var _bloco_def = bloco_defs[_bloco_id];
    var _drop_infos = 
    {
        index:      _bloco_def.sprite_drop,     //mudando o sprite index do drop de acordo com o tipo do bloco
        item:       _bloco_id,                  //item de acordo com o tipo do bloco
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
    //tempo em milissegundos
    var _tempo = 1000;
    
    //rodando os blocos machucados
    for (var i = array_length(blocos_machucados) - 1; i >= 0; i--)
    {
        //pegando o bloco
        var _bloco = blocos_machucados[i];
        
        //validação pra bloco vazio
        if (_bloco.index == BLOCOS.vazio) 
        {
            _bloco.machucado = false;
            array_delete(blocos_machucados, i, 1);
            continue;
        }
        
        //pegando a vida maxima do bloco
        var _hp_max = bloco_defs[_bloco.index].hp;
        
        //se passou o tempo de dano do bloco
        if (current_time - _bloco.tempo_dano >= _tempo)
        {
            //regenerando a vida
            _bloco.hp = _hp_max;
            
            //tirando da lista se ja curou
            if (_bloco.hp >= _hp_max)
            {
                _bloco.machucado = false;
                array_delete(blocos_machucados, i, 1);
            }
        }
    }
}

//função para pegar a linha de mineração
function linha_mineracao()
{
    //validação da existência do player
    if(!instance_exists(obj_player)) exit;
    
    //distancia do lengthdir
    var _dist = 36;
    
    //pegando a direção da linha de acordo com a direção do player
    switch (obj_player.dir) 
    {
        //cima
        case 1:
            _dist -= 5;
        break;
        //baixo
        case 3:
            _dist += 7;
        break;
    } 
    
    //pegando direção do player pro mouse
    var _dir = point_direction(obj_player.x, obj_player.yy, mouse_x, mouse_y);
    
    //traça uma linha de visão do player com a distancia de 32 pixels e direção do mouse
    var _x = obj_player.x + lengthdir_x(_dist, _dir);
    var _y = obj_player.yy + lengthdir_y(_dist, _dir);
    
    //retornando as posições da linha
    return
    {
        x: _x,
        y: _y
    };
}