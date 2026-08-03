desenha_ir();

//texto
draw_set_font(fnt_itens);
draw_set_halign(1);
draw_set_valign(1);

draw_text(x, y, nome);

draw_set_font(-1);
draw_set_halign(-1);
draw_set_valign(-1);