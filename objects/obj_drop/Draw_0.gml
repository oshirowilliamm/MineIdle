//sombra
var _y = y - sprite_yoffset + sprite_height;
draw_sprite_ext(spr_sombra, 0, x, _y, .5, .5, 0, c_white, .25);

//me desenhando com gravidade
draw_sprite_ext(sprite_index, image_index, x, y + z, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
