//desenhando borda branca atras
shader_set(sh_muda_cor);
draw_sprite_ext(sprite_index, image_index, x, y + z, image_xscale * 1.2, image_yscale * 1.2, image_angle, image_blend, .5);
shader_reset();

//me desenhando com gravidade
draw_sprite_ext(sprite_index, image_index, x, y + z, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
