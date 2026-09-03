//efeitos
escala = new efeito_escala();

estado = "bloqueado"; //bloqueado / disponivel / comprado
pais = [];
dados = global.upgrades[$ upgrade];





busca_pai = function()
{
    //rodando os meus filhos
    for (var i = 0; i < array_length(filhos); i++)
    {
        var _filho = filhos[i];
        
        //se o filho existe
        if (instance_exists(_filho))
        {
            //colocando eu como pai dele
            array_push(_filho.pais, id);
        }
    }
}

checa_estado = function()
{
    //se chegou no level maximo
    if (dados.level_atual >= dados.level_max)
    {
        estado = "maximo";
    }
    //se n chegou no level maximo
    else
    {
        //se n tem pai, é o primeiro upgrade
        if (array_length(pais) <= 0)
        {
            estado = "disponivel";
        }
        //se tem, começa bloqueado
        else
        {
            estado = "bloqueado";
            
            //se o pai dele foi comprado uma vez, fica disponivel
            for (var i = 0; i < array_length(pais); i++)
            {
                if (pais[i].dados.level_atual > 0)
                {
                    estado = "disponivel";
                    break;
                }
            }
        }
    }
}

selecao = function()
{
    var _mouse_sobre = position_meeting(mouse_x, mouse_y, id);
    var _mouse_click = mouse_check_button_pressed(mb_left);
    
    if (_mouse_sobre)
    {
        escala.atualiza(1.2);
        
        if (_mouse_click) comprando();
    }
    else
    {
        escala.retorna();
    }
    
    //voltando o efeito do y
    y = lerp(y, ystart, .05);
}

comprando = function()
{
    //se esta disponivel
    if (estado == "disponivel")
    {
        var _custo_atual = dados.get_custo();
        
        //comprando
        if (global.moeda >= _custo_atual)
        {
            //tirando dinheiro
            global.moeda -= _custo_atual;
            
            //sobre de level
            dados.level_atual++;
            
            //atualizando o estado, pra verificar o level
            checa_estado();
            
            //efeitos
            escala.squash(.6, 1.5);
            y = ystart - 15;
        }
    }
}

desenha_upgrade = function()
{
    //se tiver bloqueado,  n mostra nada
    if (estado == "bloqueado") return;
    
    var _cor = c_white;
    var _alpha = 1;
    
    //cor quando ainda n foi comprado
    if (dados.level_atual <= 0)
    {
        _cor = cor_upgrade_verde;
        _alpha = .5;
    }
    
    //cor quando n tem dinheiro suficiente
    if (global.moeda < dados.get_custo())
    {
        _cor = cor_upgrade_vermelho;
    }
    
    //cor do level max
    if (dados.level_atual >= dados.level_max)
    {
        _cor = cor_upgrade_amarelo;
    }
    
    var _xscale = image_xscale * escala.xscale;
    var _yscale = image_yscale * escala.yscale;
    
    //desenhando o upgrade
    draw_sprite_ext(spr_upgrade_tras, 0, x, y, _xscale, _yscale, 0, c_white, _alpha);
    draw_sprite_ext(spr_upgrade_borda, 0, x, y, _xscale, _yscale, 0, _cor, _alpha);
    draw_sprite_ext(spr_upgrade, dados.sprite, x, y, _xscale, _yscale, 0, c_white, _alpha);
}

desenha_linha_tracejada = function(_x1, _y1, _x2, _y2, _grossura, _cor, _tam = 1)
{
    var _dist = point_distance(_x1, _y1, _x2, _y2);
    var _dir = point_direction(_x1, _y1, _x2, _y2);
    
    //deslocamento 
    var _dx = lengthdir_x(_tam, _dir);
    var _dy = lengthdir_y(_tam, _dir);
    
    //posição
    var _desenhar = true;
    var _xx = _x1;
    var _yy = _y1;
    
    for (var i = 0; i < _dist; i += _tam)
    {
        var _xprox = _xx + _dx;
        var _yprox = _yy + _dy;
        
        //limitando a distancia
        if (i + _tam > _dist)
        {
            _xprox = _x2;
            _yprox = _y2;
        }
        
        //desenhando a parte da linha
        if (_desenhar)
        {
            draw_line_width_color(_xx, _yy, _xprox, _yprox, _grossura, _cor, _cor);
        }
        
        //avancando para a prox parte
        _xx += _dx;
        _yy += _dy;
        _desenhar = !_desenhar;
    }
}

cor_linha = function(_filho)
{
    //variaveis pra linha
    var _cor = c_white;
    var _tracejado = false;
    
    //mudando a cor da linha
    if (dados.level_atual > 0)
    {
        //padrão (tracejado)
        _cor = c_white;
        _tracejado = true;
        
        //cor quando ainda n foi comprado
        if (_filho.dados.level_atual > 0)
        {
            _cor = cor_upgrade_verde;
            _tracejado = false;
        }
        
        //cor quando n tem dinheiro suficiente
        if (global.moeda < _filho.dados.get_custo())
        {
            _cor = cor_upgrade_vermelho;
            _tracejado = false;
        }
        
        //cor do level max
        if (_filho.dados.level_atual >= _filho.dados.level_max)
        {
            _cor = cor_upgrade_amarelo;
            _tracejado = false;
        }
    }
    
    var _cor_borda = merge_colour(_cor, c_black, .3);
    
    return
    {
        cor: _cor,
        cor_borda: _cor_borda,
        tracejado: _tracejado
    }
}

desenha_conexao = function()
{
    //so mostra a linha se foi comprado
    if (dados.level_atual <= 0) return;
    
    for (var i = 0; i < array_length(filhos); i++)
    {
        var _filho = filhos[i];
        
        if (!instance_exists(_filho)) continue;
        
        //cores
        var _cor = cor_linha(_filho).cor;
        var _cor_borda = cor_linha(_filho).cor_borda;
        
        //variaveis da linha
        var _tracejado = cor_linha(_filho).tracejado;
        var _grossura = 4;
        var _tam = 15;
        
        //distancia e direção do pai pro filho
        var _dist = point_distance(x, y, _filho.x, _filho.y);
        var _dir = point_direction(x, y, _filho.x, _filho.y);
        
        //calculando raio com base na escala
        var _base       = sprite_get_width(spr_upgrade_borda) / 2;
        var _raio_pai   = _base * escala.xscale;
        var _raio_filho = _base * _filho.escala.xscale;
        
        //posição inicial
        var _xinicial = x + lengthdir_x(_raio_pai, _dir);
        var _yinicial = y + lengthdir_y(_raio_pai, _dir);
        
        //posição final
        var _dist_final = max(0, _dist - _raio_filho);
        var _xfinal = x + lengthdir_x(_dist_final, _dir);
        var _yfinal = y + lengthdir_y(_dist_final, _dir);
        
        //linha tracejada
        if (_tracejado)
        {
            var _oscilacao = sin(current_time / 300) * 1.5;
            var _alpha = .7 + sin(current_time / 300) * .3;
            
            draw_set_alpha(_alpha);
            desenha_linha_tracejada(_xinicial, _yinicial, _xfinal, _yfinal, _grossura * 2 + _oscilacao, _cor, _tam);
            draw_set_alpha(1);
        }
        //linha normal
        else
        {
            //borda
            draw_line_width_color(_xinicial, _yinicial, _xfinal, _yfinal, _grossura * 2, _cor_borda, _cor_borda);
            //linha
            draw_line_width_color(_xinicial, _yinicial, _xfinal, _yfinal, _grossura, _cor, _cor);
        }
    }
}





debug_linha_tela = function()
{
    var _w = display_get_gui_width();
    var _h = display_get_gui_height();
    
    draw_line(_w / 2, 0, _w /2, _h); //vertical
    draw_line(0, _h /2, _w, _h / 2); //horizontal
}