//criando player se ele ainda n foi criado
if (!instance_exists(obj_player)) 
    instance_create_layer(obj_player_spawn.x, obj_player_spawn.y, "Instances", obj_player);

//criando hud
if (!instance_exists(obj_hud)) 
    instance_create_layer(0, 0, "Instances", obj_hud);
