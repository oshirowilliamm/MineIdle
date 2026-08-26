//variaveis de movimento
spd_max = 2;
spd = spd_max;
hspd = 0;
vspd = 0;

//variaveis de inputs
left = 0;
right = 0;
up = 0;
down  = 0;

//variaveis de colisao
tile_minerios = -1;
tile_bordas = -1;
tile_colisao = -1;
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

//variaveis da picareta
usando_picareta = false;
golpe_aplicado = false;
cooldown_max = global.picareta.cooldown;
cooldown_atual = 0;

//variaveis de estado
estado_parado   = new estado();
estado_andando  = new estado();
estado_atacando = new estado();

//debugs
debug = false;
debug_spd = false;
debug_noclip = false;
debug_linha = false;



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
    move_and_collide(hspd, 0, colisores, 4);
    move_and_collide(0, vspd, colisores, 4);
}

//////// ESTADOS ////////

//variaveis pro desenho do player de acordo com os estados
sprite = spr_player_idle_side;
xscale = 1; //muda entre esquerda e direita

#region Estado Parado

    estado_parado.inicia = function()
    {
        //definindo a sprite do player de acordo com a sala
        if (room == rm_mina_velha)
        {
            //srpite de acordo com a direção
            sprite = define_sprite
            (
                dir, 
                spr_player_pic_idle_front, 
                spr_player_pic_idle_side, 
                spr_player_pic_idle_back
            );
        }
        else
        {
            //srpite de acordo com a direção
            sprite = define_sprite
            (
                dir, 
                spr_player_idle_front,
                spr_player_idle_side, 
                spr_player_idle_back
            );
        }
        
        //aplicando a sprite
        sprite_index = sprite;
    }
    
    estado_parado.roda = function()
    {
        //definindo a sprite do player de acordo com a sala
        if (room == rm_mina_velha)
        {
            //srpite de acordo com a direção
            sprite = define_sprite
            (
                dir, 
                spr_player_pic_idle_front, 
                spr_player_pic_idle_side, 
                spr_player_pic_idle_back
            );
        }
        else
        {
            //srpite de acordo com a direção
            sprite = define_sprite
            (
                dir, 
                spr_player_idle_front,
                spr_player_idle_side, 
                spr_player_idle_back
            );
        }
        
        //aplicando a sprite
        sprite_index = sprite;
        
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
        //definindo a sprite do player de acordo com a sala
        if (room == rm_mina_velha)
        {
            //srpite de acordo com a direção
            sprite = define_sprite
            (
                dir, 
                spr_player_pic_run_front,
                spr_player_pic_run_side, 
                spr_player_pic_run_back
            );
        }
        else
        {
            //srpite de acordo com a direção
            sprite = define_sprite
            (
                dir, 
                spr_player_run_front,
                spr_player_run_side,
                spr_player_run_back
            );
        }
        
        //aplicando a sprite
        sprite_index = sprite;
    }
    
    estado_andando.roda = function()
    {
        //definindo a sprite do player de acordo com a sala
        if (room == rm_mina_velha)
        {
            //srpite de acordo com a direção
            sprite = define_sprite
            (
                dir, 
                spr_player_pic_run_front,
                spr_player_pic_run_side, 
                spr_player_pic_run_back
            );
        }
        else
        {
            //srpite de acordo com a direção
            sprite = define_sprite
            (
                dir, 
                spr_player_run_front,
                spr_player_run_side,
                spr_player_run_back
            );
        }
        
        //aplicando a sprite
        sprite_index = sprite;
        
        //mudando de estado
        if (hspd == 0 && vspd == 0)
        {
            troca_estado(estado_parado);
        }
    }
    
#endregion

#region Estado Atacando
    
    estado_atacando.inicia = function()
    {
        //verificando se esta andando
        var _andando = hspd != 0 || vspd != 0;
        
        if (_andando)
        {
            //definindo a sprite do player de acordo com a direção
            sprite = define_sprite
            (
                dir, 
                spr_player_pic_atk_run_front, 
                spr_player_pic_atk_run_side, 
                spr_player_pic_atk_run_back
            );
        }
        else
        {
            //definindo a sprite do player de acordo com a direção
            sprite = define_sprite
            (
                dir, 
                spr_player_pic_atk_idle_front, 
                spr_player_pic_atk_idle_side, 
                spr_player_pic_atk_idle_back
            );
        }
        
        //aplicando a sprite
        sprite_index = sprite;
        
        //zerando o image index
        image_index = 0;
        
        //zerando golpe
        golpe_aplicado = false;
    }
    
    estado_atacando.roda = function()
    {
        //verificando se esta andando
        var _andando = hspd != 0 || vspd != 0;
        
        if (_andando)
        {
            //definindo a sprite do player de acordo com a direção
            sprite = define_sprite
            (
                dir, 
                spr_player_pic_atk_run_front, 
                spr_player_pic_atk_run_side, 
                spr_player_pic_atk_run_back
            );
        }
        else
        {
            //definindo a sprite do player de acordo com a direção
            sprite = define_sprite
            (
                dir, 
                spr_player_pic_atk_idle_front, 
                spr_player_pic_atk_idle_side, 
                spr_player_pic_atk_idle_back
            );
        }
        
        //aplicando a sprite
        sprite_index = sprite;
        
        //golpe
        golpe_picareta();
        
        //mudando de estado
        if (usando_picareta == false)
        {
            troca_estado(estado_andando);
        }    
    }
    
#endregion

//usando a picareta
usa_picareta = function()
{
    //só usa se estiver na mina
    if (room != rm_mina_velha) exit;
    
    //abaixando o cooldown para 0
    if (cooldown_atual > 0) cooldown_atual--;
    
    //click
    var _click = mouse_check_button(mb_left);
    
    //se n to usando nada
    if (usando_picareta == false)
    {
        //se clico e o cooldown deixar
        if (_click && cooldown_atual <= 0)
        {
            //usando o equip
            usando_picareta = true;
            //start no cooldown
            cooldown_atual = cooldown_max; 
        	//mudando o estado
            troca_estado(estado_atacando);
        }
    }
}

//golpe da picareta
golpe_picareta = function()
{
    //quando chegar no fim da animação da sprite, golpeia
    
    //golpe
    if (image_index >= 2 && !golpe_aplicado)
    {
        //pegando a linha de mineração
        var _linha = linha_mineracao();
        
        //chamando o minera bloco
        global.mina.minera_bloco(_linha.x, _linha.y, global.picareta.dano);
        
        //aplicando golpe
        golpe_aplicado = true;
    }
    
    //fim da animação
    if (image_index >= image_number - 1)
    {
        //avisando quanto terminar de golpear
        usando_picareta = false;
    }
}

//linha de mineração
linha_mineracao = function()
{
    //distancia do lengthdir
    var _dist = 30;
    
    //pegando a direção da linha de acordo com a direção do player
    
    
    //pegando direção do player pro mouse
    var _dir = point_direction(x, yy, mouse_x, mouse_y);
    
    //traça uma linha de visão do player com a distancia de 32 pixels e direção do mouse
    var _x = x + lengthdir_x(_dist, _dir);
    var _y = yy + lengthdir_y(_dist, _dir);
    
    //retornando as posições da linha
    return
    {
        x: _x,
        y: _y
    };
}

//iniciando estado padrao do player
inicia_estado(estado_parado);



//////// STAMINA ////////

//salvando dano da picareta antiga
picareta_dano_original = global.picareta.dano;

//stamina
stamina = function()
{
    //se estiver na mina
    if (room == rm_mina_velha)
    {
        //se stamina acabar, o player fica lento
        if (global.stamina_atual <= 0)
        {
            //picareta lenta
            global.picareta.dano = .1;
            
            //resetando stamina atual
            global.stamina_atual = 0;
        }
    }
    //se tiver fora da mina
    else 
    {
        //resetando stamina
    	global.stamina_atual = global.stamina_max;
        
        //resetando dano da picareta
        global.picareta.dano = picareta_dano_original;
    }
}
