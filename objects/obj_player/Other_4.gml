#region Destruindo ao entrar em salas de upgrade

var _salas = [rm_venda, rm_upgrade];

if (array_contains(_salas, room))
{
    instance_destroy();
}

#endregion

//validação da existência do player
if (!instance_exists(obj_player_spawn)) exit;

//definindo posição de spawn do player
x = obj_player_spawn.x;
y = obj_player_spawn.y;

//criando a colisão com tiles apenas se existe a camada de tiles
tile_minerios   = layer_exists("tl_minerios") ? layer_tilemap_get_id("tl_minerios") : -1;
tile_bordas     = layer_exists("tl_bordas") ? layer_tilemap_get_id("tl_bordas") : -1;
tile_colisao    = layer_exists("tl_colisao") ? layer_tilemap_get_id("tl_colisao") : -1;

//criando colisao
colisores = [obj_colisao, tile_bordas, tile_colisao, tile_minerios];

//criando a picareta so se estiver na mina
if (!instance_exists(obj_picareta) && room == rm_mina) 
{
    picareta = instance_create_depth(x, y, depth, obj_picareta);
}
else 
{
	picareta = noone;
}