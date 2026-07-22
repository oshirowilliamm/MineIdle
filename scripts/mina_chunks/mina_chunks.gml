//criando a chunk com todas as infos
function mina_cria_chunks(_id)
{
    //criando chunk vazia
    var _chunk = 
    {
        index: _id,
        blocos: array_create(MINA_CHUNK_W * MINA_CHUNK_H)
    };
    
    mina_preenche_minerios(_chunk); //preenchendo os minerios da chunk
    mina_preenche_bordas(_chunk); //bordas da mina inteira
    mina_cria_checkpoint(_chunk); //criando checkpoints
    mina_cria_tiles(_id, _chunk); //criando os tiles
    
    //colocando a nova chunk na struct
    chunks[$ _id] = _chunk;
    
    //atualizando os tiles (pro autotile)
    if (_id > 0) mina_cria_tiles(_id - 1, chunks[$ (_id - 1)]);
    
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

//controla a geração de blocos (define o tipo do bloco)
function mina_gera_blocos(_chunk, _col)
{ 
    ////////////// COLUNAS INICIAIS DE PEDRA //////////////
    if (_chunk.index % global.bioma_chunks == 1)
    {
        if (_col <= 1)
        {
            return BLOCOS.pedra
        }
    }
    
    ////////////// CHANCE POR BIOMA //////////////
    //pegando o bioma que estamos atualmente
    var _bioma_atual = floor((_chunk.index - 1) / global.bioma_chunks); 
    
    //se o bioma atual for inválido, retorna pedra
    if (_bioma_atual < 0 || _bioma_atual >= array_length(global.biomas))
    {
        return BLOCOS.pedra;
    }
    
    //pegando a chunk dentro de um bioma
    var _bioma_chunk = (_chunk.index - 1) % global.bioma_chunks;    
    
    //pegando os minerios de cada bioma
    var _bioma_blocos = global.biomas[_bioma_atual].conteudo        
    
    //acumulando as chances dos minerios
    var _chance_total = 0;  //chance total acumulada de todos os minérios
    var _chances = [];      //chance única de cada minério com sua taxa de crescimento
    
    //rodando os biomas
    for (var i = 0; i < array_length(_bioma_blocos); i++)
    {
        var _bloco = _bioma_blocos[i];
        
        //pegando a chance de spawn do bloco multiplicado a taxa de crescimento
        var _chance_bloco = _bloco.chance + (_bioma_chunk * _bloco.cresc);
        
        //colocando nas listas
        array_push(_chances, _chance_bloco);
        _chance_total += _chance_bloco;
    }
    
    ////////////// CHANCE POR BLOCO //////////////
    //sorteando o bloco
    var _random = irandom(_chance_total - 1);
    var _acumulador = 0;
    
    //pega um bloco aleatorio e sua chance de spawn
    for (var i = 0; i < array_length(_bioma_blocos); i++)
    {
        //bloco que nao foi escolhido para somar com a chance do proximo bloco
        _acumulador += _chances[i];
        
        //caso o bloco escolhido nao for menor que a porcentagem de aparecer
        if (_random < _acumulador) 
        {
            return _bioma_blocos[i].index; //retorna o bloco escolhido
        }
    }
}

//decorando chunks de checkpoint
function mina_cria_checkpoint(_chunk)
{
    if (_chunk.index % global.bioma_chunks == 0)
    {
        //posição inicial da chunk
        var _x = _chunk.index * MINA_CHUNK_W * MINA_SIZE_W;
        var _y = 0;
        
        //////////// CHECKPOINT INICIAL ////////////
        //if (_chunk.index == 0)
        //{
            ////criando transição de sala
            //var _xtrans = _x + MINA_SIZE_W;
            //var _ytrans = _y + (MINA_CHUNK_H * MINA_SIZE_H) / 2;
            //var _trans = instance_create_layer(_xtrans, _ytrans, "Decoracoes", obj_transicao);
            //_trans.image_blend = c_maroon;
            //
            ////criando tochas
            //var _xtocha = _x + MINA_SIZE_W * 4;
            //var _ytocha = _ytrans - MINA_SIZE_H * 2;
            //instance_create_layer(_xtocha, _ytocha, "Decoracoes", obj_tocha);
            //instance_create_layer(_xtocha, _ytocha + MINA_SIZE_H * 4, "Decoracoes", obj_tocha);
            //instance_create_layer(_xtocha + MINA_SIZE_W * 6, _ytocha, "Decoracoes", obj_tocha);
            //instance_create_layer(_xtocha + MINA_SIZE_W * 6, _ytocha + MINA_SIZE_H * 4, "Decoracoes", obj_tocha);
        //}
        
        //////////// CHECKPOINTS ////////////
    }
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
            
            ///////// CRIANDO CHECKPOINTS (CHUNKS VAZIAS) /////////
            //cria um checkpoint nas chunks (0, 11, 22, 33, etc)
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
                //se o bloco for pedra, gera normalmente
                if (_tipo == 1 )
                {
                    _chunk.blocos[_id] = mina_novo_bloco(_tipo);
                }
                //se for minérios, gera veias
                else 
                {
                	_chunk.blocos[_id] = mina_minerios_veias(_chunk, i, j, _tipo);
                }
            }
        }
    }
}

//espalhamento dos minérios
function mina_minerios_veias(_chunk, i, j, _tipo)
{
    var _idir = [1, -1, 0, 0, 1, 1, -1, -1]; //direção coluna (i)
    var _jdir = [0, 0, -1, 1, 1, -1, 1, -1]; //direção linha (j)
    
    //rodando a matriz
    for (var k = 0; k < 8; k++)
    {
        //posição do vizinho
        var _x = i + _idir[k];
        var _y = j + _jdir[k];
        
        //validação se o vizinho esta nos limites da chunk
        if (_x >= 0 && _x < MINA_CHUNK_W && _y >= 0 && _y < MINA_CHUNK_H)
        {
            var _vizinho_id = mina_get_bloco_id(_x, _y);
            var _bloco      = _chunk.blocos[_vizinho_id];
            
            //validação se o bloco existe
            if (!is_struct(_bloco)) continue;
            
            //validação de blocos vazios e borda
            if (_bloco.index != BLOCOS.vazio && _bloco.index != BLOCOS.borda)
            {
                //chance de em % do vizinho virar o minério
                if (irandom(99) < 20)
                {
                    _chunk.blocos[_vizinho_id] = mina_novo_bloco(_tipo);
                }
            }
        }
    }
    
    //retornando o bloco atual tbm
    return mina_novo_bloco(_tipo);
}

//fazendo as bordas
function mina_preenche_bordas(_chunk)
{
    for (var i = 0; i < MINA_CHUNK_W; i++)
    {
        for (var j = 0; j < MINA_CHUNK_H; j++)
        {
            //se a chunk for a primeira
            if (_chunk.index == 0)
            {
                ////cantos da mina
                //var _top = j < 9;    
                //var _bottom = j > 14;       
                //
                ////verificando se o bloco esta nos cantos
                //if (_top || _bottom)
                //{
                    //var _id = mina_get_bloco_id(i, j);
                    //
                    ////setando os blocos como borda
                    //_chunk.blocos[_id] = mina_novo_bloco(BLOCOS.borda);
                //}
                //
                ////abertura na mina
                //if (i < 2) //primeiras colunas
                //{
                    //_top = j < 11;
                    //_bottom = j > 12;
                    //
                    //if (_top || _bottom)
                    //{
                        //var _id = mina_get_bloco_id(i, j);
                        //
                        ////setando os blocos como borda
                        //_chunk.blocos[_id] = mina_novo_bloco(BLOCOS.borda);
                    //}
                //}
            }
            //todas as outras chunks
            else
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