//desenhando sombra
desenha_sombra(.8);
//desenhando player
draw_sprite_ext(sprite_index, image_index, x, y, xscale, image_yscale, image_angle, image_blend, image_alpha);



#region Debugs

if (debug)
{
    //desenhando a linha de mineração
    if (picareta != noone)
    {
        var _linha = picareta.linha_mineracao();
        
        draw_line(x, y - 15, _linha.x, _linha.y);
    }
    
}

#endregion