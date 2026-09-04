//efeitos
escala_efeito = new efeito_escala();

dados = dados_upgrade;
escala = global.escala_hud;
escala_txt = .3;

//configurações da caixa
margem = 20;
caixa_width = 0;
caixa_height = 0;
desc_height = 0;

//posições
x_caixa = 0;
y_caixa = 0;
x_geral = 0;
y_geral = 0;

//variaveis de typist
typist_nome = scribble_typist().in(1, 5);
typist_desc = scribble_typist().in(.7, 5);
typist_valor = scribble_typist().in(.5, 5);
typist_custo = scribble_typist().in(1, 5);
typist_level = scribble_typist().in(1, 5);

//efeitos
alpha = 0;
escala_efeito.xscale = .5;
escala_efeito.yscale = .5;
destroi = false;
desenha = true;




efeito_inicia = function()
{
    if (destroi) return;
    
    y = lerp(y, ystart - 30, .3);
    alpha = lerp(alpha, 1, .08);
    
    escala_efeito.atualiza(1, 1, .2);
}

efeito_destroi = function()
{
    if (!destroi) return;
    
    y = lerp(y, ystart, .3);
    alpha = lerp(alpha, 0, .15);
    
    escala_efeito.atualiza(0, 0, .2);
    
    if (escala_efeito.xscale <= .1) instance_destroy();
}



calcula_config_caixa = function()
{
    var _gui = room_to_gui(x, y);
    x_geral = _gui.x;
    y_geral = _gui.y;
    
    var _w = 400;
    
    //espaço que a descrição vai ocupar
    var _wrap = _w - ((margem + 10) * 2);
    desc_height = scribble(string(dados.descricao))
        .starting_format("fnt_upgrade_info", c_white)
        .scale(escala_txt)
        .wrap(_wrap)
        .get_height();
    
    //calculando a altura da caixa
    var _espacos_fixos = 220;
    var _h = _espacos_fixos + desc_height;
    
    //aplicando o efeito de escala
    caixa_width = _w * escala_efeito.xscale;
    caixa_height = _h * escala_efeito.yscale;
    
    //definindo a posição da caixa
    x_caixa = x_geral - (caixa_width / 2);
    y_caixa = y_geral - caixa_height;
}

desenha_fundo = function()
{
    draw_set_alpha(alpha);
    
    //fundo
    draw_sprite_stretched(spr_caixa_upgrade, 0, x_caixa, y_caixa, caixa_width, caixa_height); 
    
    //seta
    var _xscale = escala * escala_efeito.xscale;
    var _yscale = escala * escala_efeito.yscale; 
    draw_sprite_ext(spr_caixa_upgrade_seta, 0, x_geral, y_geral, _xscale, _yscale, 0, c_white, alpha); 
    
    draw_set_alpha(1);
}



desenha_nome = function(_x, _y)
{
    scribble_anim_wave(2, .5, .05);
    
    var _xscale = (escala_txt * escala_efeito.xscale) * 1.5;
    var _yscale = (escala_txt * escala_efeito.yscale) * 1.5;
    
    //nome
    var _nome = string("[c_ltgray][wave]{0}[/]", dados.nome);
    
    texto_scribble_ext(_x, _y, _nome, _xscale, _yscale, 1, 1,, alpha, "fnt_upgrade_info", typist_nome);
}

desenha_descricao = function(_x, _y)
{
    var _xscale = escala_txt * escala_efeito.xscale;
    var _yscale = escala_txt * escala_efeito.yscale;
    
    //descricao
    var _desc = string(dados.descricao);
    
    //distancia do wrap
    var _wrap = 400 - ((margem + 10) * 2);
    
    texto_scribble_ext(_x, _y, _desc, _xscale, _yscale, 1,,, alpha, "fnt_upgrade_info", typist_desc, _wrap);
}

desenha_valor = function(_x, _y)
{
    var _xscale = escala_txt * escala_efeito.xscale;
    var _yscale = escala_txt * escala_efeito.yscale;
    
    //pegando o valor atual e o prox
    var _valor_atual = string(dados.get_valor(dados.level_atual));
    var _prox_valor  = string(dados.get_valor(dados.level_atual + 1));
    
    //setando o valor de acordo com o level
    var _valor = (dados.level_atual >= dados.level_max)
        ? string("[delay, 500]{0} -> [cor_upgrade_verde]MAX[/]", _valor_atual) 
        : string("[delay, 500]{0} -> [cor_upgrade_verde]{1}[/]", _valor_atual, _prox_valor); 
    
    texto_scribble_ext(_x, _y, _valor, _xscale, _yscale, 1, 1,, alpha, "fnt_upgrade_info", typist_valor);
}

desenha_fundo_custo = function(_y)
{
    //cor do fundo
    var _cor = #46467F;
    
    //posição do fundo
    var _x1 = x_caixa + margem * escala_efeito.xscale;
    var _x2 = x_caixa + caixa_width - margem * escala_efeito.xscale;
    var _y2 = y_caixa + caixa_height - 45 * escala_efeito.yscale;
    
    //aplicando efeito do alpha
    draw_set_alpha(alpha)
    draw_rectangle_colour(_x1, _y, _x2, _y2, _cor, _cor, _cor, _cor, 0);
    draw_set_alpha(1)
}

desenha_level = function(_x, _y)
{
    var _xscale = escala * escala_efeito.xscale;
    var _yscale = escala * escala_efeito.yscale;
    var _txt_xscale = escala_txt * escala_efeito.xscale;
    var _txt_yscale = escala_txt * escala_efeito.yscale;
    
    //sprite da caixa do level
    draw_sprite_ext(spr_caixa_upgrade_level, 0, _x, _y, _xscale, _yscale, 0, c_white, alpha);
    
    var _level = string("[cor_upgrade_amarelo]Lv. {0}/{1}[/]", dados.level_atual, dados.level_max);
    
    texto_scribble_ext(_x, _y, _level, _txt_xscale, _txt_yscale, 1, 1,, alpha, "fnt_upgrade_info", typist_level);
}

desenha_custo = function(_x, _y)
{
    var _xscale = 3 * escala_efeito.xscale;
    var _yscale = 3 * escala_efeito.yscale;
    var _txt_xscale = .4 * escala_efeito.xscale;
    var _txt_yscale = .4 * escala_efeito.yscale;
    
    //se está no level maximo
    if (dados.level_atual >= dados.level_max)
    {
        //desenhando MAX
        var _custo = "[cor_upgrade_verde]MAX![/]";
        texto_scribble_ext(_x, _y, _custo, _txt_xscale, _txt_yscale, 1, 1,, alpha, "fnt_upgrade_info", typist_custo);
    }
    //se n esta no level maximo
    else
    {
        //desenhando a moeda
        var _xmoeda = _x - (30 * escala_efeito.xscale);
        draw_sprite_ext(spr_moeda, 0, _xmoeda, _y, _xscale, _yscale, 0, c_white, alpha);
        
        //pegando a cor de acordo com o dinheiro q tenho
        var _custo = (global.moeda >= dados.get_custo())
            ? string("[cor_upgrade_verde]${0}", dados.get_custo())
            : string("[cor_upgrade_vermelho]${0}", dados.get_custo());
        
        //texto do custo
        texto_scribble_ext(_x, _y, _custo, _txt_xscale, _txt_yscale,, 1,, alpha, "fnt_upgrade_info", typist_custo);
    }
}

desenha_conteudo = function()
{
    //y dos desenhos
    var _yy = y_caixa;
    
    //nome
    desenha_nome(x_geral, _yy);
    _yy += 40 * escala_efeito.yscale;
    
    //descricao
    desenha_descricao(x_geral, _yy);
    _yy += (desc_height + 30) * escala_efeito.yscale;
    
    //valor
    desenha_valor(x_geral, _yy);
    _yy += 40 * escala_efeito.yscale;
    
    //fundo do custo
    desenha_fundo_custo(_yy);
    
    //level
    desenha_level(x_geral, _yy);
    _yy += 40 * escala_efeito.yscale;
    
    //custo
    desenha_custo(x_geral, _yy)
}



desenho = function()
{
    calcula_config_caixa();
    desenha_fundo();
    desenha_conteudo();
}