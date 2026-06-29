enum BLOCOS 
{
	vazio = -1,
    pedra,
    roxo,
    verde,
    azul,
    amarelo
}

function mina_sistema() constructor
{
    //informações bases
    size_w  = 32;           //tamanho horizontal da celula
    size_h  = 32;           //tamanho vertical da celula
    chunk_x = 7 * size_w;   //posição x inicial
    chunk_y = 64;           //posição y inicial
    chunk_w = 16;           //qtd de colunas
    chunk_h = 20;           //qtd de linhas
    total_chunks = 50;      //total de chunks
    margem = 2;             //margem de colunas extras
    seletor_index = 0;      //controlando animação do seletor
    
    //informações de armazenamento
    chunks = {};
    bloco_defs = {};
    chance_spawn_total = 0;
    
    #region Inicialização dos Blocos
        
        //iniciando os blocos do jogo
        static ini_defs = function()
        {
            //metodo rapido pra adicionar uma nova definição de bloco
            var _add_def = function(_id, _nome, _hp, _spr_drop, _qtd, _spawn)
            {
                //atributos dos blocos
                bloco_defs[_id] =
                {
                    nome:   _nome, 
    				hp: _hp, 
                    sprite_drop: _spr_drop, 
    				quantidade_drop: _qtd, 
    				chance_spawn: _spawn, //tem a ver com chance de geração
                }
                
                //adicionando o chance de spawn total
                chance_spawn_total += _spawn;
            }
            
            //adicionando as definições dos blocos
            _add_def(BLOCOS.pedra,    "Pedra",    10,  0, 1, 50);
            _add_def(BLOCOS.roxo,     "Roxo",     20,  1, 1, 15);
            _add_def(BLOCOS.verde,    "Verde",    40,  2, 1, 10);
            _add_def(BLOCOS.azul,	  "Azul",	  50,  3, 1, 5);
    		_add_def(BLOCOS.amarelo,  "Amarelo",  100, 4, 1, 1);
        }
        
    #endregion
    
    #region Funções Matemáticas
        
        //pega uma coordenada em pixel e transforma num grid id 
        static pixel_to_grid_x = function(_x) 
        { 
            return floor((_x - chunk_x) / size_w); //faz pixel / tamanho
        } 
        static pixel_to_grid_y = function(_y) 
        { 
            return floor((_y - chunk_y) / size_h); 
        }
        
    	//pega uma coordenada em grid id e transforma em pixel
        static grid_to_pixel_x = function(_x) 
        { 
            return chunk_x + (_x * size_w); //faz pixel * tamanho
            
        } 
        static grid_to_pixel_y = function(_y) 
        { 
            return chunk_y + (_y * size_h); 
        }
        
    	//pega um grid id e transforma em chunk id
        static get_chunk_id = function(_x) 
        { 
            return floor(pixel_to_grid_x(_x) / chunk_w); //pega o pixel e divide pelo tamanho de colunas da chunk
        }
    	//pega a coluna do chunk
        static get_chunk_col = function(_x) 
        { 
            return _x % chunk_w; //pega o resto da divisão entre o pixel e o tamanho de colunas da chunk
        } 
        //pega o id do bloco
        static get_bloco_id = function(_x, _y) 
        { 
            /* 
                pegando as coordenadas de cada bloco de uma array 1d 
                formula -> id = (linha x largura do chunk) + coluna
            */
            return _y * chunk_w + _x; 
        }
        
    #endregion
    
    #region Funções de Ajuda
        
        //função para pegar id do tile de acordo com o tipo de bloco
        static get_tile_id = function(_bloco_tipo)
        {
            switch (_bloco_tipo) 
            {
            	case BLOCOS.pedra:      return 1;
                case BLOCOS.roxo:      return 2;
                case BLOCOS.verde:      return 3;  
                case BLOCOS.azul:       return 4;
                case BLOCOS.amarelo:   return 5;  
                default:                return 0;
            }
        }
        
        //função para pegar um bloco especifico de uma chunk, de acordo com uma posição em pixel
        static get_bloco = function(_x, _y)
        {
            //pegando chunk do bloco
            var _chunk_id = get_chunk_id(_x);
            
            //validação da existencia do chunk
            if (!variable_struct_exists(chunks, _chunk_id)) return false;
            
            //pegando posição da grid
            var _xgrid = pixel_to_grid_x(_x);
            var _ygrid = pixel_to_grid_y(_y);
            
            //validação de bloco fora do chunk verticalmente
            if (_ygrid < 0 || _ygrid >= chunk_h) return false;
            
            //acessando o chunk
            var _chunk_atual = chunks[$ _chunk_id];
            
            //pegando o id do bloco
            var _col = get_chunk_col(_xgrid);
            var _bloco_id = get_bloco_id(_col, _ygrid);

            //retornando a struct do bloco (com id e hp)
            return _chunk_atual.blocos[_bloco_id];
        }
        
    #endregion
    
    #region Funções de Geração  
        
        //função para gerar os blocos de forma aleatória considerando as chances de spawn
        static gera_blocos = function() 
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
        
        //função para chamar os chunks na camera
        static carrega_chunks = function()
        {
            //informações da camera
            var _vx = camera_get_view_x(view_camera[0]);
            var _vw = camera_get_view_width(view_camera[0]);
            
            //pegando o primeiro e o ultimo chunk que aparece na camera
            var _chunk1 = get_chunk_id(_vx);
            var _chunk2 = get_chunk_id(_vx + _vw);
            
            //garantindo a margem do chunk e que ele não vai ser menor que 0
            var _left_chunk     = max(0, _chunk1 - margem);
            var _right_chunk    = max(0, _chunk2 + margem);
            
            //rodando as chunks da tela
            for (var _id = _left_chunk; _id <= _right_chunk; _id++)
            {
                //validação de não criar chunks a mais que o total permitido
                if (_id >= total_chunks) continue;
                    
                //checando se a chunk já existe
                if (!variable_struct_exists(chunks, _id))
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
                blocos: array_create(chunk_w * chunk_h)
            };
            
            //infos do tile
            //criando a colisão com tiles apenas se existe a camada de tiles
            if (layer_exists("tl_minerios"))
            {
                var _tile_id = layer_tilemap_get_id("tl_minerios");
            } 
            else 
            {
            	var _tile_id = -1;
            }
            
            //prencheendo a grid
            for (var i = 0; i < chunk_w; i++)
            {
                for (var j = 0; j < chunk_h; j++)
                {
                    //criando o bloco
                    var _bloco_tipo = gera_blocos();
                    var _bloco_id = get_bloco_id(i, j);
                    
                    //pegando posição para o tile
                    var _xtile = grid_to_pixel_x(i + (_id * chunk_w));
                    var _ytile = grid_to_pixel_y(j);
                    
                    //pegando minerio do tile
                    var _tile_data = get_tile_id(_bloco_tipo);
                    
                    //setando o tile de colisão
                    tilemap_set_at_pixel(_tile_id, _tile_data, _xtile, _ytile);
                    
                    //setando informações do bloco e do hp na chunk
                    _novo_chunk.blocos[_bloco_id] =
                    {
                        id: _bloco_tipo,
                        hp: bloco_defs[_bloco_tipo].hp,
                        tempo_dano: 0
                    };
                }
            }
            
            //colocando o novo chunk na struct dos chunks
            chunks[$ _id] = _novo_chunk;
            
            //debug
            show_debug_message("Chunk Gerado: ID:" + string(_id));
            
            //retornando o novo chunk
            return _novo_chunk;
        }
        
    #endregion
    
    #region Funções de Interação com os Blocos
        
        //função pra minerar os blocos
        static minera_bloco = function(_x, _y, _dano)
        {
            //pegando o bloco
            var _bloco = get_bloco(_x, _y);
            if (!_bloco) return false;
            
            //verifica se o minério não está vazio
            if (_bloco.id != BLOCOS.vazio)
            {
                //aplicando dano
                _bloco.hp -= _dano;
                
                //guardando esse dano no bloco
                _bloco.tempo_dano = current_time;
                
                //perdendo stamina do player
                global.stamina_atual -= global.stamina_dano;
                
                //fazendo rachaduras no bloco
                bloco_rachadura(_x, _y);
                
                //quebrando bloco
                if (_bloco.hp <= 0)
                {
                    //criando o drop
                    var _xcentro = grid_to_pixel_x(pixel_to_grid_x(_x)) + size_w / 2;
                    var _ycentro = grid_to_pixel_y(pixel_to_grid_y(_y)) + size_h / 2;
                    cria_drop(_xcentro, _ycentro, _bloco.id);
                    
                    //setando o bloco como vazio
                    _bloco.id = BLOCOS.vazio;
                    _bloco.hp = 0;
                    
                    //apagando os tiles
                    if (layer_exists("tl_minerios") && layer_exists("tl_rachaduras"))
                    {
                        var _id_tile_minerios= layer_tilemap_get_id("tl_minerios");
                        var _id_tile_rachaduras = layer_tilemap_get_id("tl_rachaduras");
                        tilemap_set_at_pixel(_id_tile_minerios, 0, _x, _y);
                        tilemap_set_at_pixel(_id_tile_rachaduras, 0, _x, _y);
                    } 
                }
                
                //avisa que a picareta acertou um bloco não vazio
                return true;
            }
            
            //avisando que bateu em nada
            return false;
        }
        
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
        
        //função para rachaduras do bloco
        static bloco_rachadura = function(_x, _y)
        {
            //pegando o bloco
            var _bloco = get_bloco(_x, _y);
            if (!_bloco) return false;
            
            //pegando vida maxima e atual do bloco
            var _hp_max = bloco_defs[_bloco.id].hp;
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
            if (layer_exists("tl_rachaduras")) 
            {
                var _tile_id = layer_tilemap_get_id("tl_rachaduras");
                tilemap_set_at_pixel(_tile_id, _index, _x, _y);
            }
        }
        
        //função para criar o drop 
        static cria_drop = function(_x, _y, _bloco_id)
        {
           //passando informações pro drop 
            var _bloco_def = bloco_defs[_bloco_id];
            var _drop_infos = 
            {
                index:      _bloco_def.sprite_drop,     //mudando o sprite index do drop de acordo com o tipo do bloco
                tipo:       _bloco_id,                  //tipo de bloco
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
            var _chunk1 = get_chunk_id(_vx);
            var _chunk2 = get_chunk_id(_vx + _vw);
            var _left_chunk     = max(0, _chunk1 - margem);
            var _right_chunk    = max(0, _chunk2 + margem);
            
            //rodando as chunks da tela
            for (var _id = _left_chunk; _id <= _right_chunk; _id++)
            {
                //validação da existência do chunk
                if (!variable_struct_exists(chunks, _id)) continue;
                   
                var _chunk_atual = chunks[$ _id];
                
                //acessando os blocos
                for (var i = 0; i < array_length(_chunk_atual.blocos); i++)
                {
                    //pegando o bloco
                    var _bloco = _chunk_atual.blocos[i];
                    //tempo pra regenerar em milissegundos
                    var _tempo = 5 * 1000;
                    
                    //validações
                    if (_bloco.id == BLOCOS.vazio)                  continue; //bloco vazio
                    if (_bloco.hp >= bloco_defs[_bloco.id].hp)      continue; //vida cheia
                    if (current_time - _bloco.tempo_dano < _tempo ) continue; //tempo de espera
                    
                    //regenerando vida
                    _bloco.hp++;
                    
                    //regenerando rachaduras
                    var _col = i % chunk_w;
                    var _row = floor(i / chunk_w);
                    var _xbloco = grid_to_pixel_x(_col + (_id * chunk_w));
                    var _ybloco = grid_to_pixel_y(_row);
                    
                    bloco_rachadura(_xbloco, _ybloco);
                }
            }
        }
        
    #endregion
    
    #region Desenho
        
        //desenhando as interações com o bloco
        static desenha_interacao = function()
        {
            //pegando a linha de mineracao
            var _linha = linha_mineracao();
            
            //pegando o bloco
            var _bloco = get_bloco(_linha.x, _linha.y);
            if (!_bloco) return false;
            
            //pegando a posição exata (canto superior esquerdo) para desenhar o seletor
            var _x = grid_to_pixel_x(pixel_to_grid_x(_linha.x));
            var _y = grid_to_pixel_y(pixel_to_grid_y(_linha.y));
            
            //posição do seletor
            var _xseletor = _x - 5;
            var _yseletor = _y - 6;
            
            //fazendo a animação do seletor
            seletor_index += .1;
            
            //verifica se o bloco não está vazio
            if (_bloco.id != BLOCOS.vazio)
            {
                //desenhando seletor
                draw_sprite(spr_seletor, seletor_index, _xseletor, _yseletor);
                
                //debug para ver a vida do bloco
                //draw_text(_x, _y, string(_hp_max) + " " + string(_hp_atual));
            }
        }
        
        //arrumando bug de tiles nao aparecendo quando a room acaba
        static ajusta_tamanho_tile = function()
        {
            //pegando largura total da room em celulas
            var _largura_room = total_chunks * chunk_w * size_w + chunk_x;
            
            //tile minerios
            if (layer_exists("tl_minerios")) {
                var _tile_id_minerios = layer_tilemap_get_id("tl_minerios");
                tilemap_set_width(_tile_id_minerios, _largura_room);
            }
            
            //tile rachaduras
            if (layer_exists("tl_rachaduras")) {
                var _tile_id_rachaduras = layer_tilemap_get_id("tl_rachaduras");
                tilemap_set_width(_tile_id_rachaduras, _largura_room);
            }
        }
        
    #endregion
    
    //ajustando o tamanho da room pros tiles
    ajusta_tamanho_tile();
    
    //chamando o blocos defs
    ini_defs();
}