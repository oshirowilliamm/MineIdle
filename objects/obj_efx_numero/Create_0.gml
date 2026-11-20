alpha = 1;
angle = 0;

//variaveis de movimentação
var _random = random(359);
hspd = lengthdir_x(1, _random);
vspd = lengthdir_y(1, _random);
z       = -1;
zspd    = -3;
grav    = .3;

//variaveis de squash
scale = scale_inicial;




efeito_pulo = function()
{
    //aplicando a gravidade
    zspd += grav;
    z += zspd;
    
    //movendo
    x += hspd;
    y += vspd;
    
    //se bateu no chão, zera
    if (z >= 0) 
    {
        z = 0;
        hspd = 0;
        vspd = 0;
    }
}

desaparecendo = function()
{
    alpha -= .03;
    
    if (alpha <= 0) instance_destroy();
}


//efeito de pop 
tween(id, "scale", .3, tween_animation.bounce);