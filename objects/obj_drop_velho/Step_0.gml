//validação da existência do player
if (!instance_exists(obj_player)) exit;

//pegando distancia entre o drop e o player
var _dist = point_distance(x, y, obj_player.x, obj_player.yy);

pulando(_dist);
sugando(_dist);

//movendo e colidindo
move_and_collide(hspd, vspd, colisores, 12);