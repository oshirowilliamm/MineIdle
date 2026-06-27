draw_self();
draw_set_font(fnt_itens);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_colour(c_white);

//nome
draw_text(x, y - 20, nome);
//custo
draw_text(x, y + 40, "Custo: " + string(upgrade.custo));

draw_set_font(-1);
draw_set_halign(-1);
draw_set_valign(-1);
draw_set_colour(-1);