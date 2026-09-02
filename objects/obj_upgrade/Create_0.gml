



debug_linha_tela = function()
{
    var _w = display_get_gui_width();
    var _h = display_get_gui_height();
    
    draw_line(_w / 2, 0, _w /2, _h); //vertical
    draw_line(0, _h /2, _w, _h / 2); //horizontal
}