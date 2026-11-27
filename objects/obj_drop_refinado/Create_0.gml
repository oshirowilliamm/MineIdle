// Inherit the parent event
event_inherited();

var _random = random(359);
hspd = random_range(-10, -1);
vspd = random_range(-1, 3);
z    = -34;
zspd = -1;

brilha = false;

raio_player = 20;


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