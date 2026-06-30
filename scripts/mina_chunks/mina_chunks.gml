//criando a chunk com todas as infos
function mina_cria_chunks(_id)
{
    //criando chunk vazia
    var _chunk = 
    {
        id: _id,
        blocos: array_create(MINA_CHUNK_W * MINA_CHUNK_H)
    };
    
    //preenchendo a chunk com minerios e bordas
    mina_preenche_chunk(_chunk);
    mina_cria_bordas(_chunk);
    
    //colocando a nova chunk na struct
    chunks[$ _id] = _chunk;
    
    //tiles
    cria_tiles(_id, _chunk);
    
    show_debug_message("Chunk criada: " + string(_id));

    return _chunk;
}