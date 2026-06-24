enum BLOCOS 
{
	vazio = -1,
    terra,
    pedra,
    ferro,
    ouro,
    ametista
}

function mina_sistema() constructor
{
    //informações bases
    size_w  = 64;           //tamanho horizontal
    size_h  = 64;           //tamanho vertical
    chunk_x = 10 * size_w;  //posição x inicial
    chunk_y = 0;            //posição y inicial
    chunk_w = 16;           //qtd de colunas
    chunk_h = 12;           //qtd de linhas
    total_chunks = 2;       //total de chunks
    margem = 2;             //margem de colunas extras
    
    //informações de armazenamento
    chunks = {};
    bloco_defs = [];
    peso_total = 0;
    
    #region Inicialização dos Blocos
        
        //struct rapido para blocos vazios
        static bloco_vazio = 
        {
            id: BLOCOS.vazio,
            hp: 0
        }
        
        //iniciando os blocos do jogo
        static ini_defs = function()
        {
            //metodo rapido pra adicionar uma nova definição de bloco
            var _add_def = function(_id, _nome, _spr, _hp, _spr_drop, _qtd, _peso)
            {
                //atributos dos blocos
                bloco_defs[_id] =
                {
                    nome:   _nome, 
    				sprite: _spr,
    				hp: _hp, 
                    sprite_drop: _spr_drop, 
    				quantidade_drop: _qtd, 
    				peso: _peso, //tem a ver com chance de geração
    				solid: true //uso na colisão
                }
                
                //adicionando o peso total
                peso_total += _peso;
            }
            
            //adicionando as definições dos blocos
            _add_def(BLOCOS.terra,    "terra",    spr_terra,     1,  0, 1, 35);
            _add_def(BLOCOS.pedra,    "pedra",    spr_pedra,     1,  1, 1, 50);
            _add_def(BLOCOS.ferro,    "ferro",    spr_ferro,     15, 2, 1, 5);
            _add_def(BLOCOS.ouro,	  "ouro",	  spr_ouro,		 15, 3, 1, 5);
    		_add_def(BLOCOS.ametista, "ametista", spr_ametista,  28, 4, 1, 1);
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
            return _x mod chunk_w; //pega o resto da divisão entre o pixel e o tamanho de colunas da chunk
        } 
        static get_chunk_row = function(_y) 
        { 
            return _y mod chunk_h; //pega o resto da divisão entre o pixel e o tamanho de linhas da chunk
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
    
    #region Funções de Geração  
        
        //função para gerar os blocos de forma aleatória considerando os pesos
        static gera_blocos = function() 
        {
            var _random = irandom(peso_total - 1); //faz um irandom(99)
            var _acumulador = 0;
            
            //pega um bloco aleatorio e seu peso
            for (var i = 0; i < array_length(bloco_defs); i++)
            {
                //bloco que nao foi escolhido para somar com o peso do proximo bloco
                _acumulador += bloco_defs[i].peso;
                //caso o bloco escolhido nao for menor que a porcentagem de aparecer
                if (_random < _acumulador) return i; //retorna o bloco escolhido
            }
            
            //retorna a terra por segurança
            return BLOCOS.terra;
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
            
            //prencheendo a grid
            for (var i = 0; i < chunk_w; i++)
            {
                for (var j = 0; j < chunk_h; j++)
                {
                    //criando o bloco
                    var _bloco_tipo = gera_blocos();
                    var _bloco_id = get_bloco_id(i, j);
                    
                    _novo_chunk.blocos[_bloco_id] =
                    {
                        id: _bloco_tipo,
                        hp: bloco_defs[_bloco_tipo].hp
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
        
        
        
    #endregion
    
    //////////////////////////////////////////////////////////////////
    
    //desenha a mina nas chunks, apenas oq aparece na camera
    static draw_mina = function()
    {
        //infos da camera
        var _cam = view_camera[0];
	    var _vx = camera_get_view_x(_cam);
	    var _vy = camera_get_view_y(_cam);
	    var _vw = camera_get_view_width(_cam);
	    var _vh = camera_get_view_height(_cam);
        
        //posição do loop
        var _col1 = max(0, pixel_to_grid_x(_vx));
        var _col2 = min((total_chunks * chunk_w) - 1, pixel_to_grid_x(_vx + _vw));
        
        var _row1 = max(0, pixel_to_grid_y(_vy));
        var _row2 = min(chunk_h - 1, pixel_to_grid_y(_vy + _vh));
        
        //prencheendo a grid
        for (var i = _col1; i <= _col2; i++)
        {
            //pegando o chunk id
            var _chunk_id = floor(i / chunk_w);
            
            //verificando existencia do chunk
            if (!variable_struct_exists(chunks, _chunk_id)) continue;
            
            //infos da chunk
            var _chunk = chunks[$ _chunk_id];
            var _chunk_col = get_chunk_col(i);
            
            for (var j = _row1; j <= _row2; j++)
            {
                //infos do bloco
                var _bloco_id = get_bloco_id(_chunk_col, j);
                var _bloco = _chunk.blocos[_bloco_id];
                
                //desenha se o bloco não estiver vazio
                if (_bloco.id != BLOCOS.vazio)
                {
                    //infos do bloco
                    var _x = grid_to_pixel_x(i);
                    var _y = grid_to_pixel_y(j);
                    var _def = bloco_defs[_bloco.id];
                    
                    //desenhando sprite
                    draw_sprite(_def.sprite, 0, _x, _y);
                }
            }
        }
    }
    
    //chamando o blocos defs
    ini_defs();
}