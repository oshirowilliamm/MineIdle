//pega uma coordenada em pixel e transforma num grid id 
//faz pixel / tamanho
function mina_pixel_to_grid_x(_x) 
{ 
    return floor((_x - MINA_CHUNK_X) / MINA_SIZE_W); 
} 

function mina_pixel_to_grid_y(_y) 
{ 
    return floor((_y - MINA_CHUNK_Y) / MINA_SIZE_H); 
}

//pega uma coordenada em grid id e transforma em pixel
//faz pixel * tamanho
function mina_grid_to_pixel_x(_x) 
{ 
    return MINA_CHUNK_X + (_x * MINA_SIZE_W); 
} 

function mina_grid_to_pixel_y(_y) 
{ 
    return MINA_CHUNK_Y + (_y * MINA_SIZE_H); 
}

//pega um grid id (coluna global) e transforma em chunk id (chunks globais)
//pega o pixel e divide pelo tamanho de colunas da chunk
function mina_get_chunk_id(_x) 
{ 
    return floor(mina_pixel_to_grid_x(_x) / MINA_CHUNK_W); 
}

//pega a coluna do chunk
//pega o resto da divisão entre o pixel e o tamanho de colunas da chunk
function mina_get_chunk_col(_x) 
{ 
    return _x % MINA_CHUNK_W; 
} 

//pega o id do bloco
/* 
    pegando as coordenadas de cada bloco de uma array 1d 
    formula -> id = (linha x largura do chunk) + coluna
*/
function mina_get_bloco_id(_x, _y) 
{ 
    return _y * MINA_CHUNK_W + _x; 
}



//percorre todos os chunks visiveis na tela
function mina_chunks_visiveis(_function)
{
    var _inicio = mina_chunks_camera().inicio;
    var _fim    = mina_chunks_camera().fim;
    
    //rodando os chunks
    for (var _chunk = _inicio; _chunk <= _fim; _chunk++)
    {
        //validações
        if (i >= MINA_TOTAL_CHUNKS) continue; //esta dentro do total de chunks
        if (!variable_struct_exists(global.chunks, _chunk)) continue; //se chunk existe
        
        //pegando o chunk da struct de chunks
        var _chunk_struct = global.chunks[$ _chunk];
        
        _function(_chunk_struct, _chunk);
    }
}

//percorre todos os blocos visiveis na tela
function mina_blocos_visiveis(_function)
{
    mina_chunks_visiveis(function(_chunk_struct, _chunk)
    {
        //rodando coluna da chunk
        for (var i = 0; i < MINA_CHUNK_W; i++)
        {
            //rodando as linhas da chunk
            for (var j = 0; j < MINA_CHUNK_H; j++)
            {
                //pegando o bloco 
                var _id = mina_get_bloco_id(i, j);
                var _bloco = _chunk_struct.blocos[_id];
                
                //posição
                var _x = mina_grid_to_pixel_x(i + _chunk * MINA_CHUNK_W);
                var _y = mina_grid_to_pixel_y(j);
                
                //retornando
                _function(_bloco, _x, _y);
            }
        }
    })
}