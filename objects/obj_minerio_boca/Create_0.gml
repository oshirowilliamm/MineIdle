escala = global.escala_hud;

//variaveis pro movimento
var _random = random(359);
hspd = lengthdir_x(1, _random);
vspd = -2;
z       = -1;
zspd    = -10;
grav    = .4    ;
altura_fim = -80;

//variavel de controle para ir ate a boca da lesma
boca = false;



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
    x = lerp(x, obj_lesma.x_lesma, .1);
    y = lerp(y, obj_lesma.y_boca, .1);
    z = lerp(z, 0, .1);
    
    //sumindo 
    var _dist = point_distance(x, y, obj_lesma.x_lesma, obj_lesma.y_boca);
    
    if (_dist < 5)
    {
        instance_destroy();
    }
}   