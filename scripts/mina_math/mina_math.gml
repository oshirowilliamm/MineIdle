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