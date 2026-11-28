event_inherited();

estado = noone;

//variavel da animação da boca
boca_aberta = false;
tempo_boca = 12;
timer_boca = 0; 

//variaveis do slot
qtd_slot = 2;

//variaveis da digestão
fila = [];
fila_max = 10;
tempo_digestao = FPS * .5;
timer_digestao = 0;

//variaveis do desenho
desenho = false;
escala = global.escala_hud;
alpha = 0;




//entrando e saindo da interface
entra_refinacao = function()
{
    //desativando player
    obj_player.estado = obj_player.estado_desativado;
    
    //desativando a tecla de interação
    acao = noone;
    
    //avisando que a refinação está aberta
    global.refinacao_aberta = true;
    
    //ativando o desenho do slot
    desenho = true;
    
    //criando o voltar
    if (!instance_exists(obj_botao_voltar))
    {
        var _voltar = instance_create_layer(0, 0, "HUD", obj_botao_voltar);
        _voltar.lesma = true;
    }
}

sai_refinacao = function()
{
    obj_player.estado = obj_player.estado_parado;
    acao = entra_refinacao;
    global.refinacao_aberta = false;
    desenho = false;
}

//funções auxiliares
entra_fila = function(_item, _sprite, _index)
{
    //verificando se ja tem slots disponiveis
    for (var i = 0; i < array_length(fila); i++)
    {
        var _slot = fila[i];
        
        //se o item desse slot for o mesmo e ta antes do limite, soma o qtd
        if (_slot.item == _item && _slot.qtd < fila_max)
        {
            _slot.qtd++;
            return;
        }
    }
    
    //criando o slot se ele n foi criado
    if (array_length(fila) < qtd_slot)
    {
        //colocando as infos no slot
        var _struct = 
        {
            item: _item,
            sprite: _sprite,
            index: _index,
            qtd: 1,
            qtd_visual: 0
        }
        
        //colocando o slot na fila
        array_push(fila, _struct);
    }
}

chegou_boca = function(_item)
{
    for (var i = 0; i < array_length(fila); i++)
    {
        var _slot = fila[i];
        
        //pegando o slot do item
        if (_slot.item == _item)
        {
            //aplicando o qtd visual
            if (_slot.qtd_visual < _slot.qtd)
            {
                _slot.qtd_visual++;
                return;
            }
        }
    }
}

tem_espaco = function(_item)
{
    for (var i = 0; i < array_length(fila); i++)
    {
        var _slot = fila[i];
        
        //se o slot do item da existe e caber, retorna true
        if (_slot.item == _item && _slot.qtd < fila_max)
        {
            return true;
        }
    }
    
    //se tem mais um slot sobrando, retorna true
    if (array_length(fila) < qtd_slot)
    {
        return true;
    }
    else
    {
        return false;
    }
}

cagar = function(_item)
{
    var _tipo, _categoria, _sprite;
    
    //definindo se o resultado é um puro ou refinado
    if (string_pos("_puro", _item) == 0)
    {
        _tipo = _item + "_puro";
        _categoria = "puros";
        _sprite = spr_puros;
    }
    else
    {
        _tipo = string_replace(_item, "_puro", "") + "_refinado";
        _categoria = "refinados";
        _sprite = spr_refinados;
    }
    
    //infos do drop
    var _struct = {tipo: _tipo, index: global.minerios[$ _tipo].sprite, categoria: _categoria, sprite_index: _sprite};
    
    //criando o drop
    var _x = x + random_range(23, 29);
    var _y = y + random_range(32, 38);
    
    instance_create_depth(_x, _y, -(y + 35), obj_drop_refinado, _struct);
}

//estados
parada = function()
{
    sprite_index = spr_lesma_parada;
    image_speed = 1;
    
    //indo pro estado de abrindo a boca
    if (boca_aberta)
    {
        estado = abrindo_boca;
        image_index = 0;
    }
}

abrindo_boca = function()
{
    sprite_index = spr_lesma_abrindo_boca;  
    
    if (timer_boca > 0) timer_boca--;
    
    //deixando a boca aberta
    if (boca_aberta || instance_exists(obj_minerio_boca))
    {
        timer_boca = tempo_boca;
    }
    
    //abrindo a boca
    if (timer_boca > 0)
    {
        //animação ate a boca abrir
        image_speed = 1.5;
        
        if (image_index > 5)
        {
            image_index = 5;
        }
    }
    //fechando a boca
    else
    {
        image_speed = -1;
        
        if (image_index <= 1) 
        {
            estado = parada;
        }
    }
}

digerindo = function()
{
    var _indice = -1;
    
    //pegando o slot que ja tenha chegado na boca
    for (var i = 0; i < array_length(fila); i++)
    {
        var _slot = fila[i];
        
        if (_slot.qtd_visual > 0)
        {
            _indice = i;
            break;
        }
    }
    
    //se o item ainda não chegou no slot, reseta o timer
    if (_indice <= -1)
    {
        timer_digestao = tempo_digestao;
        return;
    }
    //se não, começa o timer
    else
    {
        timer_digestao--;
    }
    
    //chegou o timer
    if (timer_digestao <= 0)
    {
        //tirando o item da fila
        var _slot = fila[_indice];
        
        //chamando o cagar
        cagar(_slot.item);
        
        //tirando qtd
        _slot.qtd--;
        _slot.qtd_visual--;
        
        //tirando o slot se zerar
        if (_slot.qtd <= 0)
        {
            array_delete(fila, _indice, 1);
        } 
        
        //resetando timer
        timer_digestao = tempo_digestao;
    }
}

//draw
desenha_slots = function()
{
    //efeito de aparecer os slots
    if (desenho || array_length(fila) > 0)
    {
        alpha = lerp(alpha, .8, .1);
    }
    else
    {
        alpha = lerp(alpha, 0, .1);
    }
    
    //desenhando os slots
    var _w = 28 * qtd_slot + 4;
    var _h = sprite_get_height(spr_slot_refinacao);
    var _x = x - _w / 2;
    var _y = y - 55;
    
    draw_sprite_stretched_ext(spr_slot_refinacao, 0, _x, _y, _w, _h, c_white, alpha);
    
    //desenhando os minerios
    for (var i = 0; i < array_length(fila); i++)
    {
        var _slot = fila[i];
        
        //so mostra se tiver o qtd visual
        if (_slot.qtd_visual > 0)
        {
            var _xitem = _x + 16 + 28 * i;
            var _yitem = _y + 16;
            
            draw_sprite_ext(_slot.sprite, _slot.index, _xitem, _yitem, 1, 1, 0, c_white, alpha);
            texto_scribble(_xitem, _yitem, _slot.qtd_visual, .5);
        }
    }
}




//definindo estado
estado = parada;

//definindo acao
acao = entra_refinacao;