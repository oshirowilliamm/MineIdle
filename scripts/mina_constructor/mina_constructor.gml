function mina_sistema() constructor
{
    #region Funções de Geração  
        
        //função para gerar os blocos de forma aleatória considerando as chances de spawn
        static gera_blocos = function() 
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
        
        //função para chamar os chunks na camera
        static carrega_chunks = function()
        {
            //informações da camera
            var _vx = camera_get_view_x(view_camera[0]);
            var _vw = camera_get_view_width(view_camera[0]);
            
            //pegando o primeiro e o ultimo chunk que aparece na camera
            var _chunk1 = mina_get_chunk_id(_vx);
            var _chunk2 = mina_get_chunk_id(_vx + _vw);
            
            //garantindo a margem do chunk e que ele não vai ser menor que 0
            var _left_chunk     = max(0, _chunk1 - MINA_MARGEM);
            var _right_chunk    = max(0, _chunk2 + MINA_MARGEM);
            
            //rodando as chunks da tela
            for (var _id = _left_chunk; _id <= _right_chunk; _id++)
            {
                //validação de não criar chunks a mais que o total permitido
                if (_id >= MINA_TOTAL_CHUNKS) continue;
                    
                //checando se a chunk já existe
                if (!variable_struct_exists(global.chunks, _id))
                {
                    //criando a chunk
                    cria_chunk(_id);
                }
            }
        }
        
        //criando a chunk
        static cria_chunk = function(_id)
        {
            //criando um novo chunk com seus atributos
            var _novo_chunk = 
            {
                id: _id,
                blocos: array_create(MINA_CHUNK_W * MINA_CHUNK_H)
            };
            
            //prencheendo a grid
            for (var i = 0; i < MINA_CHUNK_W; i++)
            {
                for (var j = 0; j < MINA_CHUNK_H; j++)
                {
                    //criando o bloco
                    var _bloco_tipo = gera_blocos();
                    var _bloco_id = mina_get_bloco_id(i, j);
                    
                    //criando as bordas da mina
                    //infos das bordas (boolean)
                    var _top    = (j == 0);
                    var _bottom = (j == MINA_CHUNK_H - 1);
                    var _left   = (_id == 0 && i == 0);
                    var _right  = (_id == MINA_TOTAL_CHUNKS - 1 && i == MINA_CHUNK_W - 1);
                    
                    //se a posição esta na posição da parede, cria a parede
                    if (_top || _bottom || _left || _right)
                    {
                        _bloco_tipo = BLOCOS.borda;
                    }
                    
                    //setando informações da struct do bloco na chunk
                    _novo_chunk.blocos[_bloco_id] =
                    {
                        id: _bloco_tipo,
                        hp: global.bloco_defs[_bloco_tipo].hp,
                        tempo_dano: 0
                    };
                }
            }
            
            //colocando o novo chunk na struct dos chunks
            global.chunks[$ _id] = _novo_chunk;
            
            //criando os tiles dos minerios
            cria_tiles(_id, _novo_chunk);
            
            //debug
            show_debug_message("Chunk Gerado: ID:" + string(_id));
            
            //retornando o novo chunk
            return _novo_chunk;
        }
        
    #endregion
    
    #region Funções de Interação com os Blocos
        
        minera_bloco = mina_minera_bloco;
        
        //função para pegar a linha de mineração
        static linha_mineracao = function()
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
        
        //função para criar o drop 
        static cria_drop = function(_x, _y, _bloco_id)
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
        
        //função para regenerar a vida dos blocos
        static regenera_bloco = function()
        {
            //rodando as chunks visiveis igual no carrega chunks
            var _vx = camera_get_view_x(view_camera[0]);
            var _vw = camera_get_view_width(view_camera[0]);
            var _chunk1 = mina_get_chunk_id(_vx);
            var _chunk2 = mina_get_chunk_id(_vx + _vw);
            var _left_chunk     = max(0, _chunk1 - MINA_MARGEM);
            var _right_chunk    = max(0, _chunk2 + MINA_MARGEM);
            
            //rodando as chunks da tela
            for (var _id = _left_chunk; _id <= _right_chunk; _id++)
            {
                //validação da existência do chunk
                if (!variable_struct_exists(global.chunks, _id)) continue;
                   
                var _chunk_atual = global.chunks[$ _id];
                
                //acessando os blocos
                for (var i = 0; i < array_length(_chunk_atual.blocos); i++)
                {
                    //pegando o bloco
                    var _bloco = _chunk_atual.blocos[i];
                    //tempo pra regenerar em milissegundos
                    var _tempo = 5 * 1000;
                    
                    //validações
                    if (_bloco.id == BLOCOS.vazio)                  continue; //bloco vazio
                    if (_bloco.hp >= global.bloco_defs[_bloco.id].hp)      continue; //vida cheia
                    if (current_time - _bloco.tempo_dano < _tempo ) continue; //tempo de espera
                    
                    //regenerando vida
                    _bloco.hp++;
                    
                    //regenerando rachaduras
                    var _col = i % MINA_CHUNK_W;
                    var _row = floor(i / MINA_CHUNK_W);
                    var _xbloco = mina_grid_to_pixel_x(_col + (_id * MINA_CHUNK_W));
                    var _ybloco = mina_grid_to_pixel_y(_row);
                    
                    desenha_rachadura(_xbloco, _ybloco);
                }
            }
        }
        
    #endregion
    
    #region Funções de Tile
        
        //função para pegar o tile de acordo com o tipo de bloco
        static get_tile_tipo = function(_bloco_tipo)
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
        
        //função para criar os tiles
        static cria_tiles = function(_id, _chunk)
        {
            //pegando id do tile
            var _id_minerio = layer_exists("tl_minerios") ? layer_tilemap_get_id("tl_minerios") : -1;
            var _id_chao = layer_exists("tl_chao") ? layer_tilemap_get_id("tl_chao") : -1;
            if (_id_minerio == -1) return;
            
            //rodando os blocos
            for (var i = 0; i < MINA_CHUNK_W; i++)
            {
                for (var j = 0; j < MINA_CHUNK_H; j++)
                {
                    //pegando o bloco
                    var _bloco_id = mina_get_bloco_id(i, j);
                    var _bloco = _chunk.blocos[_bloco_id];
                    
                    if (_bloco.id != BLOCOS.vazio)
                    {
                        //pegando infos do tile do topo
                        var _tile_data = get_tile_tipo(_bloco.id);
                        var _xtile = mina_grid_to_pixel_x(i + (_id * MINA_CHUNK_W));
                        var _ytile = mina_grid_to_pixel_y(j);
                        
                        //desenhando o tile do topo
                        tilemap_set_at_pixel(_id_minerio, _tile_data, _xtile, _ytile);
                        
                        //se n tiver na ultima linha
                        if (j < MINA_CHUNK_H - 1)
                        {
                            var _bloco_abaixo_id = mina_get_bloco_id(i, j + 1);
                            var _bloco_abaixo = _chunk.blocos[_bloco_abaixo_id];
                            
                            //se o bloco abaixo for vazio, desenha a parede
                            if (_bloco_abaixo.id == BLOCOS.vazio) 
                            {
                                tilemap_set_at_pixel(_id_chao, _tile_data, _xtile, _ytile + MINA_SIZE_H);
                            }
                        }
                    }
                }
            }
        }
        
        //função para apagar ou atualizar os tiles
        static atualiza_tiles = function(_x, _y)
        {
            var _id_minerio = layer_exists("tl_minerios") ? layer_tilemap_get_id("tl_minerios") : -1;
            var _id_racha = layer_exists("tl_rachaduras") ? layer_tilemap_get_id("tl_rachaduras") : -1;
            var _id_chao = layer_exists("tl_chao") ? layer_tilemap_get_id("tl_chao") : -1;
            if (_id_minerio == -1) return;
            
            //apagando os tiles
            tilemap_set_at_pixel(_id_minerio, 0, _x, _y);
            tilemap_set_at_pixel(_id_racha, 0, _x, _y);
            
            //apagando a parede de baixo
            var _ybaixo = _y + MINA_SIZE_H;
            var _bloco_abaixo = mina_get_bloco(_x, _ybaixo);
            
            //se o bloco de baixo existe e esta vazio, apaga a parede
            if (_bloco_abaixo && _bloco_abaixo.id == BLOCOS.vazio)
            {
                tilemap_set_at_pixel(_id_chao, 0, _x, _ybaixo);
            }
            
            //criando a parede de cima
            var _bloco_cima = mina_get_bloco(_x, _y - MINA_SIZE_H);
            
            //se existe e não é vazio, cria a parede
            if (_bloco_cima && _bloco_cima.id != BLOCOS.vazio)
            {
                var _tile_data = get_tile_tipo(_bloco_cima.id);
                tilemap_set_at_pixel(_id_chao, _tile_data, _x, _y);
            }
        }
        
        //arrumando bug de tiles nao aparecendo quando a room acaba
        static ajusta_tamanho_tile = function()
        {
            //pegando largura total da room em celulas
            var _largura_room = MINA_TOTAL_CHUNKS * MINA_CHUNK_W * MINA_SIZE_W + MINA_CHUNK_X;
            
            //id dos tiles
            var _id_minerios = layer_exists("tl_minerios") ? layer_tilemap_get_id("tl_minerios") : -1;
            var _id_rachaduras = layer_exists("tl_rachaduras") ? layer_tilemap_get_id("tl_rachaduras") : -1;
            var _id_chao = layer_exists("tl_chao") ? layer_tilemap_get_id("tl_chao") : -1;
            
            //definindo largura dos tiles
            tilemap_set_width(_id_minerios, _largura_room);
            tilemap_set_width(_id_rachaduras, _largura_room);
            tilemap_set_width(_id_chao, _largura_room);
        }
        
    #endregion
    
    #region Funções de Desenho
        
        //função para rachaduras do bloco
        static desenha_rachadura = function(_x, _y)
        {
            //pegando o bloco
            var _bloco = mina_get_bloco(_x, _y);
            if (!_bloco) return false;
            
            //pegando vida maxima e atual do bloco
            var _hp_max = global.bloco_defs[_bloco.id].hp;
            var _hp_atual = _bloco.hp;
            
            //porcentagens
            var _porc = (_hp_atual / _hp_max) * 100;
            var _1 = 80;
            var _2 = 60;
            var _3 = 40;
            var _4 = 20;
            
            //desenhando quebrado de acordo com a vida do bloco
            var _index = 0;
            
            if (_porc <= 100 && _porc > _1)     _index = 0; //100% da vida
            else if (_porc <= _1 && _porc > _2) _index = 1; //80% da vida
            else if (_porc <= _2 && _porc > _3) _index = 2; //60% da vida
            else if (_porc <= _3 && _porc > _4) _index = 3; //40% da vida
            else if (_porc <= _4)               _index = 4; //20% da vida
            
            //desenhando as rachaduras
            var _tile_id = layer_exists("tl_rachaduras") ? layer_tilemap_get_id("tl_rachaduras") : -1;
            tilemap_set_at_pixel(_tile_id, _index, _x, _y);
        }
        
        //função para colocar brilho 
        static desenha_brilho = function(_x, _y, _bloco_id)
        {
            //não desenhar em pedra
            if (_bloco_id == BLOCOS.pedra) exit;
                
            var _frames = sprite_get_number(spr_brilho);
            var _frame_atual = (current_time / 100) % _frames;
            
            // O pulo do gato: Blend Mode Aditivo
            gpu_set_blendmode(bm_add);
            
            // Desenha o brilho por cima do bloco
            draw_sprite(spr_brilho, _frame_atual, _x, _y);
            
            // Resetar o blend mode para não estragar o resto do desenho
            gpu_set_blendmode(bm_normal);
        }
        
    #endregion
    
    //ajustando o tamanho da room pros tiles
    ajusta_tamanho_tile();
    
    //iniciando as definições dos blocos
    mina_ini_defs();
}