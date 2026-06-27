//variaveis de infos do bloco
image_index = index //image_index de acordo com o tipo do bloco
tipo_bloco = tipo; //tipo do bloco pra eu saber onde encaixar o drop

//variaveis de movimentacao, começa andando um pouco
spd = 0;
hspd = lengthdir_x(2, random(359)); //anda um pouco
vspd = lengthdir_y(2, random(359));

//variaveis de coleta
pode_andar = false;
raio_atracao = 96;
raio_coleta = 15;
alarm[0] = 30;

//variaveis de gravidade
z = -1; 
zspd = -3; 
grav = .3;

//variaveis de colisao
//criando a colisão com tiles apenas se existe a camada de tiles
if (layer_exists("tl_minerios"))
    tile_colisor = layer_tilemap_get_id("tl_minerios");
else 
	tile_colisor = -1;

colisores = [obj_colisao, obj_parede, tile_colisor];

//fazendo o drop pular do bloco
pulando = function(_dist)
{
    //se ta no chão
    if (z >= 0) 
    {
        //zero o zspd
        zspd = 0;
        z = 0;
    }
    //se ta no ar
    else 
    {
        //aplica gravidade
        zspd += grav;
    }
    
    //caindo
    z += zspd;
    
    //zerando movimentação
    if (!pode_andar) 
    {
        hspd = lerp(hspd, 0, .1);
        vspd = lerp(vspd, 0, .1);
    }
}

//fazendo o drop ir ate o player
sugando = function(_dist)
{
    //se estiver no raio de atração e poder andar
    if (_dist <= raio_atracao && pode_andar)
    {  
        //direção do drop pro player
        var _dir = point_direction(x, y, obj_player.x, obj_player.yy);
        
        //definindo movimentação
        spd = lerp(spd, 10, .01);
        hspd = lengthdir_x(spd, _dir);
        vspd = lengthdir_y(spd, _dir);
        
        //encostando no player
        if (_dist < raio_coleta)
        {
            //coletando item
            global.itens[tipo_bloco].quantidade++;
            
            //destruindo
            instance_destroy();
        }
    }
    //se estiver fora do alcance
    else
    {
        //zerando movimentação
        hspd = lerp(hspd, 0, .1);
        vspd = lerp(vspd, 0, .1);
    }
}
