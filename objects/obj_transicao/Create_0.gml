persistent = true;
fase = 1; //qual transicao está
seq = noone;
escurecer_tudo = false;



inicia_transicao = function(_sq)
{
    //criando a camada de transição se ela não existe
    if (!layer_exists("transicao"))
    {
        layer_create(-9999, "transicao");    
    }
    
    //pegando o centro da camera
    var _cam_x = camera_get_view_x(view_camera[0]) + camera_get_view_width(view_camera[0]) / 2;
    var _cam_y = camera_get_view_y(view_camera[0]) + camera_get_view_height(view_camera[0]) / 2;
    
    //se o tipo for o player, segue ele
    if (tipo == "player" && instance_exists(obj_player))
    {
        _cam_x = obj_player.x;
        _cam_y = obj_player.yy;
    }
    
    seq = layer_sequence_create("transicao", _cam_x, _cam_y, _sq);
    
    //criando o alarme com a quantidade de frames da seq
    var _frames = layer_sequence_get_length(seq);
    alarm[0] = _frames;
}

atualiza_posicao_sequence = function()
{
    //se a layer de transicao existir
    if (seq != noone && layer_sequence_exists("transicao", seq))
    {
        //seguindo o player
        if (tipo == "player" && instance_exists(obj_player))
        {
            layer_sequence_x(seq, obj_player.x);
            layer_sequence_y(seq, obj_player.yy);
        }
        //centralizando na tela
        else if (tipo == "tela")
        {
            var _cam_x = camera_get_view_x(view_camera[0]) + camera_get_view_width(view_camera[0]) / 2;
            var _cam_y = camera_get_view_y(view_camera[0]) + camera_get_view_height(view_camera[0]) / 2;
            
            layer_sequence_x(seq, _cam_x);
            layer_sequence_y(seq, _cam_y);
        }
    }
}

fim_sequence = function()
{
    //acabou de escurecer a tela
    if (fase == 1)
    {
        //indo pro destino
        room_goto(destino);
        escurecer_tudo = true;
        
        //avisando que o proximo é a transicao2
        fase = 2;
    }
    //abrindo a tela
    else if (fase == 2)
    {
        global.transicao = false;
        
        //destruindo a layer e o obj
        if (layer_exists("transicao"))
        {
            layer_destroy("transicao");
        }
        
        instance_destroy();
    }
}



//iniciando a primeira transicao
inicia_transicao(transicao1);