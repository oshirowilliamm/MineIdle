draw_self();
draw_set_font(fnt_loja);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_colour(c_white);

//nome
draw_text(x, y - 10, nome);
//custo
draw_text(x, y + 10, "Venda: " + string(global.itens[tipo_bloco].valor));

draw_set_font(-1);
draw_set_halign(-1);
draw_set_valign(-1);
draw_set_colour(-1);