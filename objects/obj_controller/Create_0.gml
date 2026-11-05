//atualizando o tamanho do display pra full hd
display_set_gui_size(1920, 1080);

//setando a fonte com outline
var _x = 0;
var _y = 2;

shader_set(sh_meu_outline);
shader_set_uniform_f(shader_get_uniform(sh_meu_outline, "u_vShadowDelta"), _x, _y);
shader_reset();

var _grossura = 2;
var _esq  = _grossura + max(0, -_x);
var _cima = _grossura + max(0, -_y);
var _dir  = _grossura + max(0,  _x);
var _baixo = _grossura + max(0, _y);

scribble_font_bake_shader("fnt_pixel", "fnt_pixel_outline", sh_meu_outline, 2, _esq, _cima, _dir, _baixo, 0, false, 2048, true);