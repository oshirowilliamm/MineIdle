//aplicando as infos que veio do bloco
image_index = index;
tipo_item = tipo;

//variaveis de movimentação
spd  = 0;
var _random = random(359);
hspd = lengthdir_x(2, _random); //anda um pouco
vspd = lengthdir_y(2, _random);

//variaveis de gravidade
z    = -1;
zspd = -3; 
grav = .3;
flutuando = false;

//variaveis de coleta
raio_atracao = 96;
raio_coleta = 10;
tempo_andar = 30;
timer_andar = tempo_andar;



controla_drop = function()
{
    depth = -y;
    
    pula();
    atrai();
    
    //movendo
    x += hspd;
    y += vspd;
}

desacelera = function()
{
    hspd = lerp(hspd, 0, .1);
    vspd = lerp(vspd, 0, .1);
    spd  = lerp(spd, 0, .1);
}

pula = function()
{
    //no ar, caindo
    if (!flutuando)
    {
        //aplicando a gravidade
        zspd += grav;
        z += zspd;
        
        //se bateu no chão, avisa q ta flutuando
        if (z >= 0)
        {
            z = 0;
            flutuando = true;
        }
    }
    //no chão, flutuando
    else
    {
        z = efeito_flutuar(z, -4, 2, 200);
        
        //abaixando o timer
        if (timer_andar > 0) timer_andar--;
    }
    
    //se n comecou a andar, desacelera
    if (timer_andar > 0) desacelera();
}

//se atrai até o player
atrai = function()
{
    //só funciona se o player existir
    if (!instance_exists(obj_player)) return;
    
    //verificando o peso
    if (global.sacola.peso_atual < global.sacola.max_peso)
    {
        //se o timer acabou
        if (timer_andar <= 0)
        {
            //pegando a distancia entre eu e o player
            var _dist = point_distance(x, y, obj_player.x, obj_player.yy);
            
            //se estiver no raio de atração
            if (_dist <= raio_atracao)
            {  
                //direção do drop pro player
                var _dir = point_direction(x, y, obj_player.x, obj_player.yy);
                
                //definindo movimentação
                spd  = lerp(spd, 10, .01);
                hspd = lengthdir_x(spd, _dir);
                vspd = lengthdir_y(spd, _dir);
                
                coleta(_dist);
            }
            else desacelera();
        }
        else desacelera();
    }
    else desacelera();
}

coleta = function(_dist)
{
    //se o drop ta no raio da coleta
    if (_dist <= raio_coleta)
    {
        //mandando o drop pra sacola
        if (instance_exists(obj_hud))
        {
            array_push(obj_hud.itens_caindo, 
            {
                vspd: 0,
                y: -5,
                tipo: tipo_item,
                frame: global.minerios[$ tipo_item].sprite,
                peso: global.minerios[$ tipo_item].peso,
            });
        }
        
        //efeito no player
        with (obj_player) 
        {
        	var _escala = random_range(.1, .3);
            efeito_squash(1 + _escala, 1 + _escala);
            aplica_efeito_brilho(global.minerios[$ other.tipo_item].cor);
        }
        
        //destruindo o drop
        instance_destroy();
    }
}

//criando minha sombra
sombra = instance_create_depth(x, y, depth, obj_sombra);
sombra.dono = id;