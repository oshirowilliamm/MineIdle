escala = 1.5;



selecao = function()
{
    var _mouse_sobre = position_meeting(mouse_x, mouse_y, id);
    var _mouse_click = mouse_check_button(mb_left);
    var _escala_atual = 1.5;
    
    if (_mouse_sobre)
    {
        if (_mouse_click)
        {
            _escala_atual = 1.2;
        }
        else
        {
            _escala_atual = 2;
        }
    }
    else
    {
        _escala_atual = 1.5; 
    }
    
    //aplicando tween
    if (escala != _escala_atual)
    {
        escala = _escala_atual;
        
        tween_scale(_escala_atual, tween_animation.back, 30);
    }
}