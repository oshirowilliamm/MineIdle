//comprando
comprando_upgrade = function()
{
    var _custo = upgrade.custo();
    
    //se tem dinheiro pra comprar
    if (global.moeda >= _custo)
    {
        if (upgrade.level < upgrade.level_max) 
        {
            //aumentando level
            upgrade.level++; 
            
            //diminuindo dinheiro
            global.moeda -= _custo;
            
            //aplicando efeito
            upgrade.efeito();
            
            //falando que comprou
            return true;
        }
        else 
        {
        	return false;
        }
    }
}

//desbloqueia os proximos upgrades
desbloqueia_upgrade = function(_compra)
{
    //se eu consegui comprar, pode desbloquar os outros
    if (_compra)
    {
        //checando quantos alvos eu tenho
        var _qtd = array_length(upgrade.alvos);
        
        //so vou fazer alguma coisa se eu tiver alvos
        if (_qtd > 0)
        {
            for (var i = 0; i < _qtd; i++)
            {
                var _atual = upgrade.alvos[i];
                
                //desbloqueando o alvo
                if (_atual.upgrade.desbloqueado == false)
                {
                    _atual.upgrade.desbloqueado = true;
                }
            }
        }
    }
}

//desenhando as infos do upgrade
desenha_infos = function()
{
    //só mostra se estiver desbloqueado
    if (!upgrade.desbloqueado) exit;
    
    var _mouse_sobre = position_meeting(mouse_x, mouse_y, id);
    
    //desenhando as infos
    if (!_mouse_sobre) exit;
    
    var _margem = 15;
    var _espaco = 20;
    var _wfundo = 600 + _margem;
    
    //pegando os textos de aumento e level
    var _texto_aum = string(upgrade.valor()) + " -> " + string(upgrade.prox_valor());
    var _texto_lvl = "Lv. " + string(upgrade.level) + " / " + string(upgrade.level_max);
    var _texto_custo = string(upgrade.custo());
    
    //pegando altura dos conteudos
    var _hnome      = string_height(upgrade.nome);
    var _hdesc      = string_height(upgrade.descricao);
    var _hdesc_ext  = string_height_ext(upgrade.descricao, _hdesc, _wfundo - _margem);
    var _haum       = string_height(string(upgrade.valor()));
    var _hlvl       = string_height(string(upgrade.level));
    var _hcusto     = string_height(string(upgrade.custo())) * 1.5;
    
    //pegando a altura do fundo
    var _hfundo = _margem;
    _hfundo += _hnome + _margem + (_espaco / 2);
    _hfundo += _hdesc_ext + _espaco;
    _hfundo += _haum + _espaco;
    _hfundo += _hlvl + _espaco;
    _hfundo += _espaco + _hcusto + _margem;
    
    //desenhando fundo
    var _xfundo = x - (_wfundo / 2);
    var _yfundo = y - _hfundo - sprite_height / 2;
    draw_sprite_stretched(spr_fundo, 0, _xfundo, _yfundo, _wfundo, _hfundo);
    
    //y dos proximos itens
    var _yitens = _yfundo + _margem;
    
    //desenhando nome
    draw_text(x, _yitens, upgrade.nome);
    _yitens += _hnome + _margem;
    
    //linha divisória
    draw_sprite_stretched(spr_linha, 0, _xfundo, _yitens, _wfundo, 2);
    _yitens += _espaco / 2;
    
    //desenhando descrição
    draw_text_ext(x, _yitens, upgrade.descricao, -1, _wfundo - (_margem * 2));
    _yitens += _hdesc_ext + _espaco;
    
    //desenhando aumento
    draw_text(x, _yitens, _texto_aum);
    _yitens += _haum + _espaco;
    
    //linha divisória
    var _ylinha2 = _yitens + (_hlvl / 2);
    draw_sprite_stretched(spr_linha, 0, _xfundo,_ylinha2, _wfundo, 2);
    
    //desenhando fundo do level
    var _wfundo2 = string_width(_texto_lvl) + (_margem * 2);
    var _hfundo2 = _hlvl + 20;
    var _xfundo2 = x - (_wfundo2 / 2);
    var _yfundo2 = _ylinha2 - (_hfundo2 / 2);
    draw_sprite_stretched(spr_fundo, 0, _xfundo2, _yfundo2, _wfundo2, _hfundo2);
    
    //desenhando level
    draw_text(x, _yitens, _texto_lvl);
    _yitens += _espaco + _hlvl + _espaco;
    
    //desenhando custo e moeda
    var _wcusto = string_width(_texto_custo) * 1.5;
    var _wmoeda = sprite_get_width(spr_moeda_upgrade) * 4;
    var _wtotal = _wmoeda + 10 + _wcusto;
    var _xcusto = x - (_wtotal / 2);
    
    //moeda
    draw_sprite_ext(spr_moeda_upgrade, 0, _xcusto + (_wmoeda / 2), _yitens, 4, 4, 0, c_white, 1);
    
    //custo
    draw_set_halign(0);
    draw_set_valign(1);
    draw_set_colour(c_yellow);
    draw_text_transformed(_xcusto + _wmoeda + 10, _yitens + 5, _texto_custo, 1.5, 1.5, 0);
    draw_set_colour(c_white);
    draw_set_halign(-1);
    draw_set_valign(-1);
}

//desenhando as conexões
desenha_conexao = function()
{
    //so mostra se foi desbloqueado
    if (!upgrade.desbloqueado) exit;
    
    //pegando quantidade de alvos
    var _qtd = array_length(upgrade.alvos);
    
    //se tiver algum alvo
    if (_qtd > 0)
    {
        for (var i = 0; i < _qtd; i++)
        {
            var _filho = upgrade.alvos[i];
            
            //desenhando a linha se o filho tiver desbloqueado
            if (_filho.upgrade.desbloqueado)
            {
                var _dist   = point_distance(x, y, _filho.x, _filho.y);
                var _dir    = point_direction(x, y, _filho.x, _filho.y);
                var _xscale = _dist / sprite_get_width(spr_linha_conexao);
                
                draw_sprite_ext(spr_linha_conexao, 0, x, y, _xscale, 1, _dir, c_white, 1);
            }
        }
    }
}