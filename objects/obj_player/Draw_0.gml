//desenhando sombra
desenha_sombra(.6);
//desenhando player
draw_sprite_ext(sprite_index, image_index, x, y, xscale, image_yscale, image_angle, image_blend, image_alpha);



#region Debugs

//mostrando linha de mineração
if (debug_linha)
{
    var _linha = linha_mineracao();
    
    draw_line(x, y - 15, _linha.x, _linha.y);
}

#endregion