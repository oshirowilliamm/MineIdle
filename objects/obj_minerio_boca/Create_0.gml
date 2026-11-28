escala = global.escala_hud;
angle = random_range(-45, 45);

//variaveis pro movimento
var _random = random(359);
hspd = lengthdir_x(1, _random);
vspd = -2;
z       = -1;
zspd    = -10;
grav    = .5;
altura_fim = -80;

//variavel de controle para ir ate a boca da lesma
boca = false;

//variavel da posição do minerio na room
var _room = room_to_gui(obj_lesma.x, obj_lesma.y);
x_ref = _room.x;
y_ref = _room.y;



segue_camera = function()
{
    var _room = room_to_gui(obj_lesma.x, obj_lesma.y);
    
    x += _room.x - x_ref;
    y += _room.y - y_ref;
    
    x_ref = _room.x;
    y_ref = _room.y;
}

pulando = function()
{
    //aplicando a gravidade
    zspd += grav;
    z += zspd;
    
    //movendo
    x += hspd;
    y += vspd;
    
    //se esta descendo e chegou na altura ideal
    if (zspd > 0 && z >= altura_fim) 
    {
        boca = true;
    }
}

indo_boca = function()
{
    //indo ate boca
    var _lesma = room_to_gui(obj_lesma.x, obj_lesma.y - 90);
    
    x = lerp(x, _lesma.x, .1);
    y = lerp(y, _lesma.y, .1);
    z = lerp(z, 0, .1);
    
    //diminuindo
    escala = lerp(escala, global.escala_hud / 2, .1);
    
    //sumindo 
    var _dist = point_distance(x, y, _lesma.x, _lesma.y);
    
    if (_dist < 10)
    {
        //avisando a lesma que o minerio chegou na boca pra ativar o visual
        obj_lesma.chegou_boca(item);
        
        //se destruindo
        instance_destroy();
    }
}   