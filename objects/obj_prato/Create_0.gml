//efeitos
escala_efeito = new efeito_escala();

//infos passadas do minerio
item       = noone;
categoria  = noone;
sprite     = noone;
minerio    = noone;

escala = 4;

//variaveis do desenho
desenho = false;
y_desenho = y;




devolve_item = function()
{
    var _mouse_click = mouse_check_button_pressed(mb_left);
    
    if (_mouse_click)
    {
        //desativando o desenho
        desenho = false;
        
        //zerando as variaveis
        item       = noone;
        categoria  = noone;
        sprite     = noone;
        minerio    = noone;
    }
}

selecao = function()
{
    if (desenho)
    {
        var _mouse_sobre = position_meeting(mouse_x, mouse_y, id);
        
        if (_mouse_sobre)
        {
            escala_efeito.atualiza(1.2, 1.2);
            
            devolve_item();
        }
        else
        {
            escala_efeito.retorna();
        }
    }
    else
    {
        escala_efeito.retorna(.2);
    }
}

desenha_minerio = function()
{
    if (!desenho) return;
    
    var _x = x;
    var _y = y_desenho;
    
    //sombra
    var _xscale_sombra = 2.5 * escala_efeito.xscale;
    var _yscale_sombra = 2.5 * escala_efeito.yscale;
    draw_sprite_ext(spr_sombra, 0, _x, y, _xscale_sombra, _yscale_sombra, 0, c_white, .25);
    
    //minerio
    var _xscale = escala * escala_efeito.xscale;
    var _yscale = escala * escala_efeito.yscale;
    draw_sprite_ext(sprite, minerio.sprite, _x, _y, _xscale, _yscale, 0, c_white, 1);
}