//iniciando a mina
global.mina = new mina_sistema();

//utilizando as variáveis da mina
with (global.mina)
{
    //mudando o tamanho da room
    //infos do tamanho da mina
    var _mina_width = (chunk_w * size_w * total_chunks) + chunk_x;
    var _mina_height = (chunk_h * size_h) + chunk_y;
    
    //definindo tamanho
    room_width = _mina_width;
    room_height = _mina_height;
}