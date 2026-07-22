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
tile_minerios       = layer_exists("tl_minerios") ? layer_tilemap_get_id("tl_minerios") : -1;
tile_bordas         = layer_exists("tl_bordas") ? layer_tilemap_get_id("tl_bordas") : -1;
tile_bordas_inicio  = layer_exists("tl_bordas_inicio") ? layer_tilemap_get_id("tl_bordas_inicio") : -1;

//criando colisao
colisores = [tile_bordas, tile_bordas_inicio, tile_minerios];