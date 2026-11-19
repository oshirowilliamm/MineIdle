EM_TRANSICAO

//me desenhando
var _xscale = 6 * escala.xscale;
var _yscale = 6 * escala.yscale;
var _x = display_get_gui_width() - sprite_get_width(spr_voltar) * 6;
var _y = display_get_gui_height() - sprite_get_height(spr_voltar) * 6;

draw_sprite_ext(spr_voltar, 0, _x, _y, _xscale, _yscale, 0, c_white, 1);

//voltando ao clicar
if (mouse_sobre_ui(_x, _y, spr_voltar, global.escala_hud))
{
    if (global.mouse_hold)
    {
        escala.atualiza(.8, .8, 1);
    }
    else
    {
        escala.atualiza(1.5);
    }
    
    //indo pra vila
    if (global.mouse_released)
    {
        voltar();
    }
}
else
{
    //retorna squash
    escala.retorna(.1);
}