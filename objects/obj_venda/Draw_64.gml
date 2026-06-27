//desenho controlado pela variavel de controle
if (!global.interface) exit;

//pegando infos da camera
var _cam = view_get_camera(view_camera[0]);
var _vx = view_get_xport(_cam);
var _vy = view_get_yport(_cam);
var _vw = view_get_wport(_cam);
var _vh = view_get_hport(_cam);
var _margem = 50;

//desenhando o fundo
var _xfundo = _vx + _margem;
var _yfundo = _vy + _margem;
var _wfundo = _vw - _margem * 2;
var _hfundo = _vh - _margem * 2;

draw_sprite_stretched(spr_fundo, 0, _xfundo, _yfundo, _wfundo, _hfundo);