#region Iniciando Variáveis

debug = false;

//variaveis de movimento
spd = 2;
hspd = 0;
vspd = 0;

//variaveis de inputs
left = 0;
right = 0;
up = 0;
down  = 0;

//variaveis de colisao
tile_colisor = -1;
colisores = [];

//variavel pra direção do player
dir = 1;

//y corrigido em relação ao ponto de origem
yy = 0;

//variaveis de equip
equip_dir = 1;
equip_x = 0;
equip_y = 0;
equip_depth = 0;

//variavel para saber se tenho uma picareta
picareta = noone;
//variavel pra saber se estou usando um equip
usando_equip = noone;

//variaveis de estado
estado_parado = new estado();
estado_andando = new estado();

#endregion

//movimento e colisao
controles = function()
{
    //inputs
    left    = keyboard_check(ord("A"));
    right   = keyboard_check(ord("D"));
    up      = keyboard_check(ord("W"));
    down    = keyboard_check(ord("S"));
    
    //zerando velocidade por padrão
    hspd = 0;
    vspd = 0;
    
    //descobrindo movimentação (retorna -1, 0 ou 1)
    var _xaxis = right - left;
    var _yaxis = down - up;
    
    //configurando hspd e vspd com lenghtdir
    if (_xaxis != 0 || _yaxis != 0)
    {
        var _dir = point_direction(0, 0, _xaxis, _yaxis);
        hspd = lengthdir_x(spd, _dir);
        vspd = lengthdir_y(spd, _dir);
    }

    //movendo e colidindo
    move_and_collide(hspd, vspd, colisores, 12);
}

//variaveis pro desenho do player de acordo com os estados
sprite = spr_player_idle_side;
xscale = 1; //muda entre esquerda e direita

#region Estado Parado

    estado_parado.inicia = function()
    {
        //definindo a sprite do player de acordo com a direção
        sprite = define_sprite
        (
            dir, 
            spr_player_idle_side, 
            spr_player_idle_front, 
            spr_player_idle_back
        );
    }
    
    estado_parado.roda = function()
    {
        //definindo a sprite do player de acordo com a direção
        sprite = define_sprite
        (
            dir, 
            spr_player_idle_side, 
            spr_player_idle_front, 
            spr_player_idle_back
        );
        
        //mudando de estado
        if (up xor down or right xor left)
        {
            troca_estado(estado_andando);
        }
    }

#endregion

#region Estado Andando

    estado_andando.inicia = function()
    {
        //definindo a sprite do player de acordo com a direção
        sprite = define_sprite
        (
            dir, 
            spr_player_idle_side, 
            spr_player_idle_front, 
            spr_player_idle_back
        );
    }
    
    estado_andando.roda = function()
    {
        //definindo a sprite do player de acordo com a direção
        sprite = define_sprite
        (
            dir, 
            spr_player_idle_side, 
            spr_player_idle_front, 
            spr_player_idle_back
        );
        
        //mudando de estado
        if (hspd == 0 && vspd == 0)
        {
            troca_estado(estado_parado);
        }
    }
    
#endregion

//variaveis de cooldown
cooldown_max = global.picareta.cooldown;
cooldown_atual = 0;

//usando o equipamento
usa_equip = function()
{
    //click
    var _click = mouse_check_button(mb_left);
    
    //se n to usando nada
    if (!usando_equip)
    {
        //abaixando o cooldown para 0
        if (cooldown_atual > 0) cooldown_atual--;
        
        //codigo para usar o equip
        if (_click && cooldown_atual <= 0)
        {
            //usando o equip
            usando_equip = true;
        }
    }
    //to usando 
    else
    {
        //start no cooldown
        cooldown_atual = cooldown_max; 
        
    	//codigo de uso do equip
        //o golpe() retorna false quando terminar o movimento
        usando_equip = picareta.golpe();
    }
}

//segurando a picareta
segura_picareta = function()
{
    //se n existir a picareta
    if (!picareta) exit;
    
    //pontos de origem do player
    var _px = 12;
    var _py = 29;

    //fazendo a distancia e a direção dos pontos de origem do player com o oq eu quero que a picareta fique
    var _len = point_distance(_px * equip_dir, _py, equip_x * equip_dir, equip_y);
    var _dir = point_direction(_px * equip_dir, _py, equip_x * equip_dir, equip_y);
    
    //achando a posição da picareta com o lenghtdir
    var _x = x + lengthdir_x(_len, _dir);
    var _y = y + lengthdir_y(_len, _dir);
    
    //setando propriedades da picareta
    picareta.x = _x;
    picareta.y = _y;
    picareta.depth = equip_depth;
    picareta.image_xscale = equip_dir;
    
    //ação de equip
    usa_equip();
}

//iniciando estado padrao do player
inicia_estado(estado_parado);