//criando a chunk com todas as infos
function mina_cria_chunks(_id)
{
    //criando chunk vazia
    var _chunk = 
    {
        index: _id,
        blocos: array_create(MINA_CHUNK_W * MINA_CHUNK_H)
    };
    
    //preenchendo a chunk
    mina_preenche_minerios(_chunk);
    mina_preenche_bordas(_chunk);
    
    //colocando a nova chunk na struct
    chunks[$ _id] = _chunk;
    
    //criando os tiles
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
function mina_gera_blocos(_chunk, _col)
{
    //colunas iniciais de pedra
    if (_chunk.index % global.bioma_chunks == 0)
    {
        if (_col <= 1)
        {
            return BLOCOS.pedra
        }
    }
    
    //identificando o bioma
    var _bioma_atual = floor((_chunk.index - 1) / global.bioma_chunks);   //pegando o bioma que estamos atualmente
    var _bioma_chunk = (_chunk.index - 1) % global.bioma_chunks;          //pegando a chunk dentro de um bioma
    var _bioma_blocos = global.biomas[_bioma_atual]                       //pegando os minerios de cada bioma
    
    //acumulando as chances dos minerios
    var _chance_total = 0;  //chance total acumulada de todos os minérios
    var _chances = [];      //chance única de cada minério com sua taxa de crescimento
    
    //rodando os biomas
    for (var i = 0; i < array_length(_bioma_blocos); i++)
    {
        var _bloco = _bioma_blocos[i];
        var _bloco_def = bloco_defs[_bloco];
        
        //pegando a chance de spawn do bloco multiplicado a taxa de crescimento
        var _chance_bloco = _bloco_def.chance_spawn + (_bioma_chunk * _bloco_def.crescimento);
        
        //colocando nas listas
        array_push(_chances, _chance_bloco);
        _chance_total += _chance_bloco;
    }
    
    //sorteando o bloco
    var _random = irandom(_chance_total - 1);
    var _acumulador = 0;
    
    //pega um bloco aleatorio e sua chance de spawn
    for (var i = 0; i < array_length(_bioma_blocos); i++)
    {
        //bloco que nao foi escolhido para somar com a chance do proximo bloco
        _acumulador += _chances[i];
        //caso o bloco escolhido nao for menor que a porcentagem de aparecer
        if (_random < _acumulador) return _bioma_blocos[i]; //retorna o bloco escolhido
    }
    
    //retorna a pedra do bioma por segurança
    return _bioma_blocos[0];
}





//preenchendo a chunk com minerios
function mina_preenche_minerios(_chunk)
{
    for (var i = 0; i < MINA_CHUNK_W; i++)
    {
        for (var j = 0; j < MINA_CHUNK_H; j++)
        {
            //pegando id do bloco
            var _id = mina_get_bloco_id(i, j);
            
            ///////// CRIANDO CHECKPOINTS /////////
            if (_chunk.index % global.bioma_chunks == 0)
            {
                _chunk.blocos[_id] = mina_bloco_vazio();
            }
            
            ///////// CRIANDO A MINA /////////
            else 
            {
                //pegando o tipo do bloco
                var _tipo = mina_gera_blocos(_chunk, i);
                
            	//setando a nova chunk com os blocos gerados
                _chunk.blocos[_id] = mina_novo_bloco(_tipo);
            }
        }
    }
}

//fazendo as bordas
function mina_preenche_bordas(_chunk)
{
    for (var i = 0; i < MINA_CHUNK_W; i++)
    {
        for (var j = 0; j < MINA_CHUNK_H; j++)
        {
            //cantos da mina
            //2 primeiras linhas
            var _top = j < 2;    
            //2 primeiras colunas e primeira chunk                                                  
            var _left = i < 2 && _chunk.index <= 0;       
            //2 ultimas linhas                       
            var _bottom = j >= MINA_CHUNK_H - 2;                       
            //2 ultimas colunas e ultima chunk             
            var _right = i >= MINA_CHUNK_W - 2 && _chunk.index == MINA_TOTAL_CHUNKS -1;   
            
            //verificando se o bloco esta nos cantos
            if (_top || _left || _bottom || _right)
            {
                var _id = mina_get_bloco_id(i, j);
                
                //setando os blocos como borda
                _chunk.blocos[_id] = mina_novo_bloco(BLOCOS.borda);
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