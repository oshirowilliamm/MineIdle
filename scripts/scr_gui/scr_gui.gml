/*
//desenho controlado pela variavel de controle
if (!global.interface) exit;

//pegando infos de tamanho pro gui
var _vw = display_get_gui_width();
var _vh = display_get_gui_height();
var _margem = 50;

//desenhando o fundo
var _xfundo = _margem;
var _yfundo = _margem;
var _wfundo = _vw - _margem * 2;
var _hfundo = _vh - _margem * 2;

draw_sprite_stretched(spr_fundo, 0, _xfundo, _yfundo, _wfundo, _hfundo);

#region Voltar

//desenhando voltar
var _xvoltar = _vw - _margem - 15;
var _yvoltar = _yfundo + 15;
var _wvoltar = sprite_get_width(spr_voltar);
var _hvoltar = sprite_get_height(spr_voltar);

draw_sprite(spr_voltar, 0, _xvoltar, _yvoltar);

//ação do botão voltar
var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0); 
var _click = mouse_check_button_pressed(mb_left);

//infos do retangulo
var _x1 = _xvoltar - _wvoltar / 2;
var _y1 = _yvoltar - _hvoltar / 2;
var _x2 = _x1 + _wvoltar;
var _y2 = _y1 + _hvoltar;
var _retangulo = point_in_rectangle(_mx, _my, _x1, _y1, _x2, _y2);

if (_click && _retangulo)
{
    global.interface = false;
}

#endregion

//vendendo terra
var _xitem = _xfundo + 150;
var _yitem = _yfundo + 100;
var _witem = 150;
var _hitem = 150;

//sprite item
draw_sprite_stretched_ext(spr_item, 0, _xitem, _yitem, _witem, _hitem, c_orange, 1);

//texto item
draw_text(_xitem, _yitem, "Terra");