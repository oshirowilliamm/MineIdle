#region Iniciando Variáveis

debug = false;

//variaveis de movimento
spd = 8;
hspd = 0;
vspd = 0;

//variaveis de inputs
left = 0;
right = 0;
up = 0;
down  = 0;

//variaveis de colisao
tile_colisor = layer_tilemap_get_id("tl_minerios");
colisores = [obj_colisao, obj_parede, tile_colisor];

//variavel pra direção do player
dir = 1;

//variaveis de estado
estado_parado = new estado();
estado_andando = new estado();

//variaveis pro desenho do player
sprite = spr_player_idle_side;
xscale = 1;

#endregion

//movimento e colisao
controles = function()
{
    //inputs
    left    = keyboard_check(ord("A"));
    right   = keyboard_check(ord("D"));
    up      = keyboard_check(ord("W"));
    down    = keyboard_check(ord("S"));
    
    //adicionando velocidade
    hspd = (right - left) * spd;
    vspd = (down - up) * spd;

    //movendo e colidindo
    move_and_collide(hspd, vspd, colisores, 12);
}

#region Estado Parado

    estado_parado.inicia = function()
    {
        //definindo a sprite do player de acordo com a direção
        sprite = define_sprite
        (
            dir, 
            spr_player_idle_side, 
            spr_player_idle_front, 
            spr_player_idle_back
        );
    }
    
    estado_parado.roda = function()
    {
        //definindo a sprite do player de acordo com a direção
        sprite = define_sprite
        (
            dir, 
            spr_player_idle_side, 
            spr_player_idle_front, 
            spr_player_idle_back
        );
        
        //mudando de estado
        if (up xor down or right xor left)
        {
            troca_estado(estado_andando);
        }
    }

#endregion

#region Estado Andando

    estado_andando.inicia = function()
    {
        //definindo a sprite do player de acordo com a direção
        sprite = define_sprite
        (
            dir, 
            spr_player_idle_side, 
            spr_player_idle_front, 
            spr_player_idle_back
        );
    }
    
    estado_andando.roda = function()
    {
        //definindo a sprite do player de acordo com a direção
        sprite = define_sprite
        (
            dir, 
            spr_player_idle_side, 
            spr_player_idle_front, 
            spr_player_idle_back
        );
        
        //mudando de estado
        if (hspd == 0 && vspd == 0)
        {
            troca_estado(estado_parado);
        }
    }
    
#endregion

//iniciando estado padrao do player
inicia_estado(estado_parado);