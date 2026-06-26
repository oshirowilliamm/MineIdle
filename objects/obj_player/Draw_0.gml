//desenhando sombra
desenha_sombra(.8);
//desenhando player
draw_sprite_ext(sprite, image_index, x, y, xscale, image_yscale, image_angle, image_blend, image_alpha);



#region Debugs

if (debug)
{
    //desenhando a linha de mineração
    var _linha = global.mina.linha_mineracao();
    
    draw_line(x, y - 15, _linha.x, _linha.y);
}

#endregion