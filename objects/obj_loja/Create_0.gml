//definindo texto do destino
texto = "";
switch (destino) 
{
	case rm_venda:
        texto = "Venda";
    break;
    
    case rm_upgrade:
        texto = "Upgrade";
    break;
}


desenha_ir = function()
{
    if (!instance_exists(obj_player)) exit;
    
    //pegando distancia do player
    var _dist = point_distance(x, y, obj_player.x, obj_player.y);
    
    //só mostra as infos se estiver perto
    if (_dist > 60) exit;
    
    //desenhando o botao de ir 
    if (position_meeting(mouse_x, mouse_y, id))
    {
        //desenho
        draw_set_font(fnt_upgrades);
        draw_set_halign(1);
        
        //fundo
        var _texto = "Ir para " + texto;
        var _w = string_width(_texto) + 20;
        var _h = 30;
        var _x = mouse_x - (_w / 2);
        var _y = mouse_y - _h - 7;
        draw_sprite_stretched(spr_fundo, 0, _x, _y, _w, _h);
        
        //texto
        var _xtxt = mouse_x;
        var _ytxt = mouse_y - _h;
        draw_text(_xtxt, _ytxt, _texto);
        
        //indo pra room
        if (mouse_check_button_pressed(mb_left))
        {
            room_goto(destino);
        }
        
        draw_set_font(-1);
        draw_set_halign(-1);
    }
}