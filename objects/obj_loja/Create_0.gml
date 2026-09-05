sprite_index = sprite;
tecla = noone;


entrando_loja = function()
{
    if (!instance_exists(obj_player)) exit;
    
    //pegando distancia do player
    var _dist = point_distance(x, y_origem, obj_player.x, obj_player.y);
    
    //só mostra as infos se estiver perto
    if (_dist <= 40)
    {
        //criando a tecla
        if (!instance_exists(tecla))
        {
            tecla = instance_create_depth(obj_player.x, obj_player.y - 40, -999, obj_tecla);
        }
        
        //indo pra room
        if (keyboard_check_pressed(ord("E")))
        {
            cria_transicao_inicia(destino);
            
            //desativando o player
            obj_player.estado = obj_player.estado_desativado;
            
            //definindo a posição do player quando voltar
            global.dest_x = dest_x;
            global.dest_y = dest_y;
        }
    }
    //destruindo a tecla
    else
    {
        if (instance_exists(tecla))
        {
            instance_destroy(tecla);
        }
    }
}

alimentando = function()
{
    //vai mostrar o bicho se alimentando
    if (sprite != spr_loja) return;
    //if (!global.alimentando) return;
    
    //pegando valor da stamina e dividindo em blocos
    //var _porc = clamp(global.stamina_atual / global.stamina_max, 0, 1);
    //var _porc_blocos = ceil(_porc * 9) / 9;
    //stamina_desenhada = lerp(stamina_desenhada, _porc_blocos, .1);
    //
    
    //aplicando a escala na largura
    var _base_w = sprite_get_width(spr_barra_alimentando);
    var _base_h = sprite_get_height(spr_barra_alimentando);
    var _width  = _base_w;
    var _height = _base_h;
    
    //posição
    var _x = x - (_width / 2);
    var _y = y - 80 + ((_base_h - _height) / 2);
    
    //desenhando a barra
    draw_sprite_stretched(spr_barra_alimentando, 1, _x, _y, _width, _height);
    draw_sprite_stretched_ext(spr_barra_alimentando, 2, _x, _y, _width, _height, cor_upgrade_amarelo, 1);
    draw_sprite_stretched(spr_barra_alimentando, 0, _x, _y, _width, _height);
}