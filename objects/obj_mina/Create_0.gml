//iniciando a mina
global.mina = new mina_sistema();

//utilizando as variáveis da mina
with (global.mina)
{
    //mudando o tamanho da room
    //infos do tamanho da mina
    var _mina_width = (chunk_w * size_w * total_chunks) + chunk_x;
    var _mina_height = (chunk_h * size_h) + chunk_y;
    //infos do tamanho da parede
    var _parede_width = sprite_get_width(spr_parede);
    var _parede_height = sprite_get_height(spr_parede);
    
    //definindo tamanho
    room_width = _mina_width + _parede_width;
    room_height = _mina_height + _parede_height;
    
    //criando as paredes
    var _left = instance_create_layer(0, 0, "Parede", obj_parede);
    var _top = instance_create_layer(0, 0, "Parede", obj_teto);
    var _right = instance_create_layer(room_width - size_w, 0, "Parede", obj_parede);
    var _bottom = instance_create_layer(0, room_height - size_h, "Parede", obj_teto);
    
    //alterando a escala da parede
    _left.image_yscale = room_height;
    _top.image_xscale = room_width;
    _right.image_yscale = room_height;
    _bottom.image_xscale = room_width;
}