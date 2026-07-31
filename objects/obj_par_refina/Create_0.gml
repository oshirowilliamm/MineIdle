nome = "";

colocando_item = function()
{
    //colocando minerio na maquina
    var _mouse_sobre = position_meeting(mouse_x, mouse_y, id);
    var _mouse_click = mouse_check_button_pressed(mb_left);
    if (_mouse_sobre && _mouse_click)
    {
        //rodando o inventario
        var _qtd = array_length(global.inventario.minerio);
        
        for (var i = 0; i < _qtd; i++)
        {
            var _atual = global.inventario.minerio[i];
            
            //tirando o item
            _atual.quantidade -= 1;
        }
    }
}