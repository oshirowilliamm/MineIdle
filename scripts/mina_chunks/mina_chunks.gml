//criando a chunk com todas as infos
function mina_cria_chunks(_id)
{
    //criando chunk vazia
    var _chunk = 
    {
        index: _id,
        blocos: array_create(MINA_CHUNK_W * MINA_CHUNK_H)
    };
    
    //preenchendo a chunk com minerios e bordas
    mina_preenche_chunk(_chunk);
    mina_cria_bordas(_chunk);
    
    //colocando a nova chunk na struct
    chunks[$ _id] = _chunk;
    
    //tiles
    mina_cria_tiles(_id, _chunk);
    
    show_debug_message("Chunk criada: " + string(_id));
    
    return _chunk;
}

//carregando as chunks na camera
function mina_carrega_chunks()
{
    //pgeando as chunks que aparecem na tela
    var _inicio = mina_chunks_camera().inicio;
    var _fim    = mina_chunks_camera().fim;
    
    //rodando as chunks da tela
    for (var i = _inicio; i <= _fim; i++)
    {
        //validações
        if (i >= MINA_TOTAL_CHUNKS) continue; //esta dentro do total de chunks
        if (variable_struct_exists(chunks, i)) continue; //chunk existe
        
        //cria a chunk
        mina_cria_chunks(i);
    }
}

//controla a geração de blocos conforme a chance de spawn
function mina_gera_blocos()
{
    var _random = irandom(chance_spawn_total - 1); //faz um irandom(99)
    var _acumulador = 0;
    
    //pega um bloco aleatorio e sua chance de spawn
    for (var i = 0; i < array_length(bloco_defs); i++)
    {
        //bloco que nao foi escolhido para somar com a chance do proximo bloco
        _acumulador += bloco_defs[i].chance_spawn;
        //caso o bloco escolhido nao for menor que a porcentagem de aparecer
        if (_random < _acumulador) return i; //retorna o bloco escolhido
    }
    
    //retorna a pedra por segurança
    return BLOCOS.pedra;
}





//preenchendo a chunk com as infos
function mina_preenche_chunk(_chunk)
{
    for (var i = 0; i < MINA_CHUNK_W; i++)
    {
        for (var j = 0; j < MINA_CHUNK_H; j++)
        {
            //pegando o tipo do bloco
            var _tipo = mina_gera_blocos();
            
            //pegando id do bloco
            var _id = mina_get_bloco_id(i, j);
            
            //setando a nova chunk com os blocos gerados
            _chunk.blocos[_id] = mina_novo_bloco(_tipo);
        }
    }
}

//criando as bordas
function mina_cria_bordas(_chunk)
{
    for (var i = 0; i < MINA_CHUNK_W; i++)
    {
        for (var j = 0; j < MINA_CHUNK_H; j++)
        {
            //infos das bordas (boolean)
            var _top    = (j == 0);
            var _bottom = (j == MINA_CHUNK_H - 1);
            var _left   = (_chunk.index == 0 && i == 0);
            var _right  = (_chunk.index == MINA_TOTAL_CHUNKS - 1 && i == MINA_CHUNK_W - 1);
            
            //se a posição esta na posição da parede, cria a parede
            if (_top || _bottom || _left || _right)
            {
                //pegando bloco
                var _id = mina_get_bloco_id(i, j);
                
                //setando bloco como borda
                _chunk.blocos[_id].index = BLOCOS.borda;
                _chunk.blocos[_id].hp = bloco_defs[BLOCOS.borda].hp;
            }
        }
    }
}

//pegando as chunks que aparecem na camera
function mina_chunks_camera()
{
    //informações da camera
    var _vx = camera_get_view_x(view_camera[0]);
    var _vw = camera_get_view_width(view_camera[0]);
    
    //pegando o primeiro e o ultimo chunk que aparece na camera
    var _chunk1 = mina_get_chunk_id(_vx);
    var _chunk2 = mina_get_chunk_id(_vx + _vw);
    
    //garantindo a margem do chunk e que ele não vai ser menor que 0
    var _inicio = max(0, _chunk1 - MINA_MARGEM);
    var _fim    = max(0, _chunk2 + MINA_MARGEM);
    
    return
    {
        inicio  : _inicio,
        fim     : _fim
    }
}