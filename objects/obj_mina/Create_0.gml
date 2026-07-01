//iniciando a mina
global.mina = new mina_sistema();

//utilizando as variáveis da mina
with (global.mina)
{
    //mudando o tamanho da room
    //infos do tamanho da mina
    var _mina_width     = MINA_CHUNK_W * MINA_SIZE_W * MINA_TOTAL_CHUNKS;
    var _mina_height    = MINA_CHUNK_H * MINA_SIZE_H;
    
    //definindo tamanho
    room_width = _mina_width;
    room_height = _mina_height;
}