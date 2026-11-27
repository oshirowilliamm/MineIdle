// Inherit the parent event
event_inherited();

//movimento
hspd = random_range(-7, -2);
vspd = random_range(-1, 1);
z    = -34;
zspd = -2.5;
grav = .2;

//não brilhar
brilha = false;

//aumentando o raio de alcance
raio_player = 30;


desacelera = function()
{
    hspd = lerp(hspd, 0, .05);
    vspd = lerp(vspd, 0, .05);
    spd  = lerp(spd, 0, .05);
}

coleta = function(_dist)
{
    //se o drop ta no raio da coleta
    if (_dist <= raio_coleta)
    {
        //mandando o drop pro inventario
        var _qtd = global.inventario_global[$ categoria][$ tipo_item] ?? 0;
        global.inventario_global[$ categoria][$ tipo_item] = _qtd + 1;
        
        //efeito no player
        with (obj_player) 
        {
        	var _escala = random_range(.1, .3);
            escala.squash(1 + _escala, 1 + _escala);
            aplica_efeito_brilho(global.minerios[$ other.tipo_item].cor);
        }
        
        //destruindo o drop
        instance_destroy();
    }
}