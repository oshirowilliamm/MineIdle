//variaveis de movimento
spd = 2;
hspd = 0;
vspd = 0;
yy = y;

//variaveis pra colisao
colisoes_originais = [obj_colisao, layer_tilemap_get_id("Tile_Parede")];
colisoes = colisoes_originais;

//variaveis de estado
estado = noone;
dir = 1;
xscale = 1;

//variaveis para minerar
usando_equip = false;
golpe_aplicado = false;
cooldown_max = global.picareta.cooldown;
cooldown_atual = 0;



//metodos de movimento
controla_player = function()
{
    inputs();
    aplica_velocidade();
    ajusta_escala();
}

inputs = function()
{
    left    = keyboard_check(ord("A"));
    right   = keyboard_check(ord("D"));
    up      = keyboard_check(ord("W"));
    down    = keyboard_check(ord("S"));
    click   = mouse_check_button(mb_left);
}

aplica_velocidade = function()
{
    //descobrindo direção (-1, 0, 1)
    var _xaxis = right - left;
    var _yaxis = down - up;
    
    //se ta se movendo, aplica velocidade
    if (_xaxis != 0 || _yaxis != 0)
    {
        //pegando a direção q o player vai andar
        var _dir = point_direction(0, 0, _xaxis, _yaxis);
        
        //aplicando as velocidades
        hspd = lengthdir_x(spd, _dir);
        vspd = lengthdir_y(spd, _dir);
    }
    //se ta parado, fica parado
    else
    {
        hspd = 0;
        vspd = 0;
    }
}

movimento = function()
{
    //movendo e colisão
    move_and_collide(hspd, 0, colisoes, 12); //horizontal
    move_and_collide(0, vspd, colisoes, 12); //vertical
}

ajusta_escala = function()
{
    //pegando a direção do mouse
    var _dir = point_direction(x, y, mouse_x, mouse_y);
    
    //aplicando na direção do player
    dir = round(_dir / 90) % 4;
}

outras_funcoes = function()
{
    //ajustando o depth de acordo com a room
    if (room != rm_caverna1)
    {
        depth = -y;
    }
    else
    {
        depth = layer_get_depth("Tile_Parede") - 10;
    }
    
    
    //y com offset
    yy = y - 15;
    
    //voltando cooldown de mineração
    if (cooldown_atual > 0) cooldown_atual--;
}



//metodos de mineração
usa_equipamento = function()
{
    if (click)
    {
        //se o equip ainda n ta sendo usado e o cooldown deixar
        if (!usando_equip && cooldown_atual <= 0)
        {
            usando_equip = true; //avisando que to usando o equip
            cooldown_atual = cooldown_max;
            estado = estado_minerando;
            image_index = 0;
        }
    }
}

linha_mineracao = function()
{
    var _dist = 30; //distancia da linha
    var _dir = point_direction(x, yy, mouse_x, mouse_y);
    
    var _x = x + lengthdir_x(_dist, _dir);
    var _y = yy + lengthdir_y(_dist, _dir);
    
    return
    {
        x: _x,
        y: _y
    }
}

quebra_bloco = function()
{
    //quebra quando chegar no frame certo
    if (image_index >= 2 && !golpe_aplicado)
    {
        //pegando a linha de mineração
        var _linha = linha_mineracao();
        
        //se tem um bloco na minha visão
        var _bloco = instance_position(_linha.x, _linha.y, obj_minerio);
        
        //dando dano
        if (_bloco)
        {
            _bloco.recebe_dano(global.picareta.dano);
        }
        
        //aplicando golpe
        golpe_aplicado = true;
    }
}

fim_animacao_minerar = function()
{
    if (image_index >= image_number - 1)
    {
        golpe_aplicado = false;
        
        //se continuar minerando
        if (click && cooldown_atual <= 0)
        {
            image_index = 0;
            cooldown_atual = cooldown_max;
        }
        //se parar de minerar
        else
        {
            usando_equip = false;
            estado = estado_andando;
        }
    }
}



//metodos de auxilio pro estado
define_sprite = function(_spr_front, _spr_side, _spr_back)
{
    var _sprite = sprite_index;
    
    //definindo as sprites de acordo com a direção
    switch (dir) 
    {
        //direita
    	case 0: 
        {
            _sprite = _spr_side; 
            xscale = 1;
            break;
        }
        
        //cima
        case 1: 
        {
            _sprite = _spr_back; 
            xscale = 1;
            break;
        }
        
        //esquerda
        case 2: 
        {
            _sprite = _spr_side; 
            xscale = -1;
            break;
        }
        
        //baixo
        case 3: 
        {
            _sprite = _spr_front; 
            xscale = 1;
            break;
        }
    }
    
    //aplicando sprite
    if (sprite_index != _sprite)
    {
        sprite_index = _sprite;
    }
}



//metodos de estado
estado_parado = function()
{
    controla_player();
    define_sprite(spr_player_pic_idle_front, spr_player_pic_idle_side, spr_player_pic_idle_back);
    
    //mudando pro estado andando
    if (right xor left || up xor down) estado = estado_andando;
    
    //mudando pro estado minerando
    usa_equipamento();
}

estado_andando = function()
{
    controla_player();
    define_sprite(spr_player_pic_run_front, spr_player_pic_run_side, spr_player_pic_run_back);
    
    //mudando pro estado parado
    if (hspd == 0 && vspd == 0) estado = estado_parado;
    
    //mudando pro estado minerando
    usa_equipamento();
}

estado_minerando = function()
{
    controla_player();
    
    //definindo sprite de acordo com estado 
    var _andando = hspd != 0 || vspd != 0;
    
    if (_andando)
    {
        define_sprite(spr_player_pic_atk_run_front, spr_player_pic_atk_run_side, spr_player_pic_atk_run_back);
    }
    else
    {
        define_sprite(spr_player_pic_atk_idle_front, spr_player_pic_atk_idle_side, spr_player_pic_atk_idle_back);
    }
    
    //quebrando o bloco
    quebra_bloco();
    
    //no fim da animação, sai do estado
    fim_animacao_minerar();
}
 


//aplicamendo meu estado
estado = estado_parado;