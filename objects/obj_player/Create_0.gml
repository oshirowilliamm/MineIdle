#region Iniciando Variáveis

debug = false;

//variaveis de movimento
spd = 5;
hspd = 0;
vspd = 0;

//variaveis de inputs
left = 0;
right = 0;
up = 0;
down  = 0;

//variaveis de colisao
tile_colisor = layer_tilemap_get_id("tl_minerios");
colisores = [obj_colisao, obj_parede, tile_colisor];

//variavel pra direção do player
dir = 1;

//variavel para saber se tenho uma picareta
picareta = noone;
//variavel pra saber se estou usando um equip
usando_equip = noone;

//variaveis de estado
estado_parado = new estado();
estado_andando = new estado();

//variaveis pro desenho do player
sprite = spr_player_idle_side;
xscale = 1;

#endregion

//movimento e colisao
controles = function()
{
    //inputs
    left    = keyboard_check(ord("A"));
    right   = keyboard_check(ord("D"));
    up      = keyboard_check(ord("W"));
    down    = keyboard_check(ord("S"));
    
    //adicionando velocidade
    hspd = (right - left) * spd;
    vspd = (down - up) * spd;

    //movendo e colidindo
    move_and_collide(hspd, vspd, colisores, 12);
}

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

//usando o equipamento
usa_equip = function()
{
    //click
    var _click = mouse_check_button(mb_left);
    
    //se n to usando nada
    if (!usando_equip)
    {
        //codigo para usar o equip
        if (_click)
        {
            usando_equip = true;
        }
    }
    //to usando 
    else 
    {
    	//codigo de uso do equip
        picareta.golpe();
    }
}

//segurando a picareta
segura_picareta = function()
{
    //se n existir a picareta
    if (!picareta) exit;
    
    //pegando os pontos de origem do player e o ponto q eu quero que a picareta fique no player
    var _px = 12;
    var _py = 29;
    var _picx = 12; 
    var _picy = 20;
    
    //direção e depth da picareta
    var _picareta_dir;
    var _depth = depth - 5;
    
    //pegando as caracteristicas da picareta de acordo com a direção
    switch (dir) 
    {
        //direita
    	case 0: 
             _picareta_dir = 1;
        break;
        //cima
        case 1: 
             _picareta_dir = -1;
            //mudando pontos da picareta
            _picx = 10;
            _picy = 19;
            _depth = depth + 5;
        break;
        //esquerda
    	case 2: 
             _picareta_dir = -1;
        break;
        //baixo
    	case 3: 
             _picareta_dir = 1;
            //mudando pontos da picareta
            _picx = 10;
            _picy = 19;
        break;
    }
    
    //fazendo a distancia e a direção dos pontos
    var _len = point_distance(_px * _picareta_dir, _py, _picx * _picareta_dir, _picy);
    var _dir = point_direction(_px * _picareta_dir, _py, _picx * _picareta_dir, _picy);
    
    //achando a posição da picareta com o lenghtdir
    var _x = x + lengthdir_x(_len, _dir);
    var _y = y + lengthdir_y(_len, _dir);
    
    //setando propriedades da picareta
    picareta.x = _x;
    picareta.y = _y;
    picareta.depth = _depth;                //sobrepondo o player
    picareta.image_xscale = _picareta_dir;	//espelhar de acordo com dir
    
    //ação de equip
    usa_equip();
}

//criando a picareta da raposa
picareta = instance_create_depth(x, y, depth, obj_picareta);

//iniciando estado padrao do player
inicia_estado(estado_parado);