//so desenha se tiver o dono e puder atacar
if (instance_exists(dono) && visible)
{
    image_index = dono.image_index;
    draw_self();
}