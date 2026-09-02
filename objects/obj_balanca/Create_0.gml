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

//typists
typist_nome = scribble_typist();
typist_nome.in(1, 5);
typist_valor = scribble_typist();
typist_valor.in(1, 5);



flutuando = function()
{
    var _y = sin(current_time / 300) * 5 + 190;
    y_minerio_atual = lerp(y_minerio_atual, _y, .2);
}

desenha_minerio = function()
{
    if (!desenho) return;
    
    //sombra
    draw_sprite_ext(spr_sombra, 0, x, y_minerio + 40, 2.5, 2.5, 0, c_white, .25);
    
    //sprite do minerio
    draw_sprite_ext(sprite, minerio.sprite, x, y_minerio_atual, escala * xscale, escala * yscale, 0, c_white, 1);
    
    //nome
    var _nome = string("[wave]{0}[/]", minerio.nome);
    texto_scribble_typist(typist_nome, x, y_minerio - 80, _nome, , , 1, 1);
    
    //valor
    draw_sprite_ext(spr_moeda, 0, x - 83, y_minerio + 77, 2, 2, 0, c_white, 1);
    var _valor = string("${0}", minerio.valor);
    texto_scribble_typist(typist_valor, x - 70, y_minerio + 77, _valor, .15, , , 1);
}