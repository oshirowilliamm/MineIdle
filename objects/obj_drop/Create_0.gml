//variaveis de infos do bloco
image_index = index //image_index de acordo com o tipo do bloco
item_tipo = item; //tipo do bloco pra eu saber onde encaixar o drop

//variaveis de movimentacao, começa andando um pouco
spd = 0;
hspd = lengthdir_x(2, random(359)); //anda um pouco
vspd = lengthdir_y(2, random(359));

//variaveis de coleta
pode_andar = false;
raio_atracao = 96;
raio_coleta = 30;
alarm[0] = 30;

//variaveis de gravidade
z = -1; 
zspd = -3; 
grav = .3;

//variaveis de colisao
tile_minerios   = layer_exists("tl_minerios") ? layer_tilemap_get_id("tl_minerios") : -1;
tile_bordas     = layer_exists("tl_bordas") ? layer_tilemap_get_id("tl_bordas") : -1;

//criando colisao
colisores = [tile_bordas, tile_minerios];

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
    //checando peso maximo
    if (global.peso_atual < global.peso_max)
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
            
            coletando(_dist);
        }
        //se estiver fora do alcance
        else
        {
            //zerando movimentação
            hspd = lerp(hspd, 0, .1);
            vspd = lerp(vspd, 0, .1);   
        }
    }
    else
    {
        //zerando movimentação
        hspd = lerp(hspd, 0, .1);
        vspd = lerp(vspd, 0, .1);   
    }
}

//coletando drop
coletando = function(_dist)
{
    //encostando no player
    if (_dist < raio_coleta)
    {
        //coletando item
        global.inventario[item_tipo].quantidade++;
        
        //adicionando peso
        global.peso_atual += global.inventario[item_tipo].peso;
        
        //lista de itens para cair na sacola
        array_push(obj_hud.itens_caindo, 
        {
            vspd: 0,
            y: 0,
            frame: item_tipo,
            peso: global.inventario[item_tipo].peso
        });
        
        //destruindo
        instance_destroy();
    }
}
