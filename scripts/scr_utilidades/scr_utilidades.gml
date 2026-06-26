//deixando jogo aleatorio
randomise();

//sombra
function desenha_sombra(_scale = .5)
{
	//garatindo que o y sempre esteja no pe
	var _y = y - sprite_yoffset + sprite_height; 
	draw_sprite_ext(spr_sombra, 0, x, _y, _scale, _scale, 0, c_white, .25);
}