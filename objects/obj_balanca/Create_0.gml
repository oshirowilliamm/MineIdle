inicia_efeito_squash();
scribble_anim_wave(3, .1, .1);

//infos passadas do minerio
item       = noone;
categoria  = noone;
sprite     = noone;
minerio    = noone;

escala  = 5;

//controle do desenho
desenho = false;

//variaveis do desenho
y_minerio = y - 100;
y_minerio_atual = y_minerio;

cor_valor = c_white;
escala_valor = 1;

//typists
typist_nome = scribble_typist().in(1, 5);
typist_valor = scribble_typist().in(1, 5);




aplica_efeitos = function()
{
    efeito_squash(1.2, 1.2);
    escala_valor = 1.8;
    cor_valor = cor_positivo
}

retorna_efeitos = function()
{
    var _amt = .05;
    
    retorna_squash(_amt);
    escala_valor = lerp(escala_valor, 1, _amt);
    cor_valor = merge_colour(cor_valor, c_white, _amt);
}

desenha_minerio = function()
{
    if (!desenho) return;
    
    //sombra
    draw_sprite_ext(spr_sombra, 0, x, y_minerio + 40, 2.5, 2.5, 0, c_white, .25);
    
    //sprite do minerio
    draw_sprite_ext(sprite, minerio.sprite, x, y_minerio_atual, escala * xscale, escala * yscale, 0, cor_valor, 1);
    
    //nome
    var _nome = string("[wave]{0}[/]", minerio.nome);
    texto_scribble_ext(x, y_minerio - 80, _nome, .2,, 1, 1,,,, typist_nome);
    
    //valor
    var _scale = .1 * escala_valor;
    
    var _sprite = "[scale, 18][spr_moeda, 0][scale, 1]";
    var _valor = string("{1} ${0}", formata_moeda(minerio.valor), _sprite);
    texto_scribble_ext(x - 55, y_minerio + 77, _valor, _scale, _scale, 1, 1, cor_valor,,, typist_valor);
}