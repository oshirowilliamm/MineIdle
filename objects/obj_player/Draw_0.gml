//me desenhando
draw_sprite_ext(sprite_index, image_index, x, y, escala.xscale * dir, escala.yscale, image_angle, image_blend, image_alpha);

//efeito de brilho
shader_set(sh_muda_cor);
draw_sprite_ext(sprite_index, image_index, x, y, escala.xscale * dir, escala.yscale, image_angle, cor_brilho, alpha_brilho);
shader_reset();
