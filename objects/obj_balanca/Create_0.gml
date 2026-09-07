inicia_efeito_squash();
scribble_anim_wave(3, .1, .1);

//infos passadas do minerio
item       = noone;
categoria  = noone;
sprite     = noone;
minerio    = noone;

escala  = 4;

//controle do desenho
desenho = false;

//variaveis do desenho
y_minerio = y - 127;
y_minerio_atual = y_minerio;

valor_desenhado = 0;
cor_minerio = c_white;
cor_valor = cor_balanca_valor;
escala_valor = 1;

//typists
typist_nome = scribble_typist().in(1, 5);




aplica_efeitos = function()
{
    efeito_squash(1.2, 1.2);
    escala_valor = 1.8;
    cor_valor = cor_positivo;
    cor_minerio = cor_positivo;
}

retorna_efeitos = function()
{
    var _amt = .05;
    
    retorna_squash(_amt);
    escala_valor = lerp(escala_valor, 1, _amt);
    cor_valor = merge_colour(cor_valor, cor_balanca_valor, _amt);
    cor_minerio = merge_colour(cor_minerio, c_white, _amt);
}

desenha_prato = function()
{
    var _y = y - 90;
    
    //y descendo quando tiver um minerio em cima
    if (desenho)
    {
        _y = y - 80;
    }
    
    draw_sprite(spr_balanca_prato, 0, x - 2, _y);
}

desenha_minerio = function()
{
    if (!desenho) return;
    
    //sombra
    draw_sprite_ext(spr_sombra, 0, x, y_minerio + 40, 3, 1.2, 0, c_white, .25);
    
    //sprite do minerio
    draw_sprite_ext(sprite, minerio.sprite, x, y_minerio_atual, escala * xscale, escala * yscale, 0, cor_minerio, 1);
    
    //nome
    var _nome = string("[wave]{0}[/]", minerio.nome);
    texto_scribble_ext(x, y_minerio - 60, _nome, .15,, 1, 1,,,, typist_nome);
    
    //valor
    var _scale = .1 * escala_valor;
    valor_desenhado = lerp(valor_desenhado, minerio.valor, .15);
    var _texto = string("${0}", formata_moeda(round(valor_desenhado)));
    
    texto_scribble_ext(x, y_minerio + 95, _texto, _scale, _scale, 1, 1, cor_valor);
}