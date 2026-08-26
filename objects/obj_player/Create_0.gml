//variaveis de movimento
spd = 2;
hspd = 0;
vspd = 0;

//variaveis pra colisao
colisoes_originais = [obj_colisao, layer_tilemap_get_id("Tile_Parede")];
colisoes = colisoes_originais;
noclip = false;

//variaveis de estado
estado = noone;
dir = 1;
xscale = 1;


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
    click   = mouse_check_button_pressed(mb_left);
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



//metodos de auxilio pro estado
define_sprite = function(_spr_front, _spr_side, _spr_back)
{
    //definindo as sprites de acordo com a direção
    switch (dir) 
    {
        //direita
    	case 0: 
        {
            sprite_index = _spr_side; 
            xscale = 1;
            break;
        }
        
        //cima
        case 1: 
        {
            sprite_index = _spr_back; 
            xscale = 1;
            break;
        }
        
        //esquerda
        case 2: 
        {
            sprite_index = _spr_side; 
            xscale = -1;
            break;
        }
        
        //baixo
        case 3: 
        {
            sprite_index = _spr_front; 
            xscale = 1;
            break;
        }
    }
}



//metodos de estado
estado_parado = function()
{
    controla_player();
    define_sprite(spr_player_idle_front, spr_player_idle_side, spr_player_idle_back);
    
    //mudando pro estado andando
    if (right xor left || up xor down) estado = estado_andando;
}

estado_andando = function()
{
    controla_player();
    define_sprite(spr_player_run_front, spr_player_run_side, spr_player_run_back);
    
    //mudando pro estado parado
    if (hspd == 0 && vspd == 0) estado = estado_parado;
}



//aplicamendo meu estado
estado = estado_parado;


#region DEBUG
    
    view_player = false;
    
    roda_debug = function()
    {
        show_debug_overlay(1);
        
        //configurando view
        view_player = dbg_view("Player", true, 20, 80);
        
        //debugs 
        dbg_slider(ref_create(id, "spd"), 2, 20, "Velocidade", 1);
        dbg_button("NoClip", function()
        {
            noclip = !noclip;
            colisoes = noclip ? [] : colisoes_originais;
        })
    }
    
    ativa_debug = function()
    {
        //se n ta no modo debug, desativa 
        if (!DEBUG_MODE) return;
        
        if (keyboard_check_pressed(vk_tab))
        {
            //alterando o valor do global.debug
            global.debug = !global.debug;
            
            if (global.debug)
            {
                //rodando o debug do player
                roda_debug();
            }
            else
            {
                show_debug_overlay(0);
                //se o view ta ativo, deleta
                if (dbg_view_exists(view_player))
                {
                    dbg_view_delete(view_player);
                }
            }
        }
    }
    
#endregion