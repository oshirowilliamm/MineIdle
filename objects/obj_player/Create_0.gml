//variaveis de movimento
spd_max = 2
spd = spd_max;
hspd = 0;
vspd = 0;

//variaveis pra colisao
colisoes = [obj_colisao, layer_tilemap_get_id("Tile_Parede")];


controla_player = function()
{
    inputs();
    movimento();
}

inputs = function()
{
    left    = keyboard_check(ord("A"));
    right   = keyboard_check(ord("D"));
    up      = keyboard_check(ord("W"));
    down    = keyboard_check(ord("S"));
    click   = mouse_check_button_pressed(mb_left);
}

movimento = function()
{
    //descobrindo direção (-1, 0, 1)
    var _xaxis = right - left;
    var _yaxis = down - up;
    
    //se ta se movendo, aplica velocidade
    if (_xaxis != 0 || _yaxis != 0)
    {
        //pegando a direção q o player vai andar
        var _dir = point_direction(0, 0, _xaxis, _yaxis);
        
        //aplicando as velocidades
        hspd = lengthdir_x(spd, _dir);
        vspd = lengthdir_y(spd, _dir);
    }
    //se ta parado, fica parado
    else
    {
        hspd = 0;
        vspd = 0;
    }
    
    //movendo e colisão
    move_and_collide(hspd, 0, colisoes, 12); //horizontal
    move_and_collide(0, vspd, colisoes, 12); //vertical
}