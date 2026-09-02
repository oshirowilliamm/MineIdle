//só mostra se estiver desbloqueado
if (!upgrade.desbloqueado) exit;

var _mouse_sobre = position_meeting(mouse_x, mouse_y, id);
var _mouse_click = mouse_check_button_pressed(mb_left);

if (_mouse_sobre) 
{
    //clicando
    if (_mouse_click)
    {
        //comprando o upgrade
        var _compra = comprando_upgrade();
        
        //desbloqueando o proximo
        desbloqueia_upgrade(_compra);
    }
}
