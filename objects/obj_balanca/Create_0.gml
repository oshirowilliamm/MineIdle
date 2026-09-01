inicia_efeito_squash();
scribble_anim_wave(3, .1, .1);
typist = scribble_typist();
typist.in(1, 5);

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
    var _texto = string("[wave]{0}[/]", minerio.nome);
    texto_scribble_typist(typist, x, y_minerio - 80, _texto, , , 1, 1);
}