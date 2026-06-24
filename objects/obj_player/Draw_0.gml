//desenhando player
draw_sprite_ext(sprite, image_index, x, y, xscale, image_yscale, image_angle, image_blend, image_alpha);


#region Debugs

if (debug)
{
    draw_text(x, y, "olhando para: "+ string(dir));
}

#endregion