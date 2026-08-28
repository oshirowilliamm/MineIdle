//deixando jogo aleatorio
randomise();

function restart()
{
    if (keyboard_check_pressed(ord("R"))) 
    {
        global.sacola = 
        {
            max_peso: 50,
            peso_atual: 0,
            
            itens: {},
        };
        
        global.inventario_global =
        {
            minerios: {},
            limpos: {},
            refinados: {},
        }
        
        room_restart();
    }
}


//fonte com sombra
function texto_sombra(_x, _y, _texto, _espacamento = 2, _xscale = 1, _yscale = _xscale, _halign = 0, _valign = 0, _cor = c_white, _alpha = 1, _font = "fnt_game")
{
    //texto
    var _txt = scribble(_texto)
        .starting_format(_font, c_white)
        .align(_halign, _valign)
        .transform(_xscale, _yscale);
    
    //sombra
    _txt.blend(c_black, _alpha)
        .draw(_x + _espacamento, _y + _espacamento);
    
    //normal
    _txt.blend(_cor, _alpha)
        .draw(_x, _y);
}


//toca audio
function toca_som(_snd, _pitch = .1)
{
    var _p = random_range(1 - _pitch, 1 + _pitch);
    audio_play_sound(_snd, 0, 0, , , _p);
}


//sombra
function desenha_sombra(_scale = .5)
{
	//garatindo que o y sempre esteja no pe
	var _y = y - sprite_yoffset + sprite_height; 
	draw_sprite_ext(spr_sombra, 0, x, _y, _scale, _scale, 0, c_white, .25);
}


function mouse_sobre_ui(_x, _y, _sprite, _escala_x = 1, _escala_y = _escala_x)
{
    //mouse
    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);    
    
    //tamanho da sprite
    var _w  = sprite_get_width(_sprite) * _escala_x;
    var _h  = sprite_get_height(_sprite) * _escala_y;
    var _ox = sprite_get_xoffset(_sprite) * _escala_x;
    var _oy = sprite_get_yoffset(_sprite) * _escala_y;
    
    //posição
    var _x1 = _x - _ox;
    var _y1 = _y - _oy;
    var _x2 = _x1 + _w;
    var _y2 = _y1 + _h;
    
    //retangulo
    return point_in_rectangle(_mx, _my, _x1, _y1, _x2, _y2);
}


//animação em draw_sprite
function draw_animation(_frame, _sprite)
{
    //velocidade de acordo com o editor
    var _spd = sprite_get_speed(_sprite) / game_get_speed(gamespeed_fps);
    
    //adicionando frames
    _frame += _spd;
    
    //zerando se passar do numero de frames do sprite
    if (_frame >= sprite_get_number(_sprite))
    {
        return 0
    }   
    
    return _frame
}







