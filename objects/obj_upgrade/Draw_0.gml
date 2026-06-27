draw_self();
draw_self();
draw_set_font(fnt_loja);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_colour(c_black);

//nome
draw_text(x, y - 6, nome);
//valor
draw_text(x, y + 15, "Custo: " + string(custo));

draw_set_font(-1);
draw_set_halign(-1);
draw_set_valign(-1);
draw_set_colour(-1);