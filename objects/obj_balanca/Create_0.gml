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
y_minerio = y - 125;
y_minerio_atual = y_minerio;
y_prato = y - 90;

//variaveis de efeito
valor_desenhado = 0;
cor_minerio = c_white;
escala_valor = 1;

//typists
typist_nome = scribble_typist().in(1, 5);




aplica_efeitos = function()
{
    efeito_squash(1.2, 1.2);
    escala_valor = 1.8;
    cor_minerio = cor_positivo;
    y_minerio = y - 135;
}

retorna_efeitos = function()
{
    var _amt = .05;
    
    retorna_squash(_amt);
    cor_minerio = merge_colour(cor_minerio, c_white, _amt);
    escala_valor = lerp(escala_valor, 1, _amt);
    y_minerio = lerp(y_minerio, y - 125, _amt);
}

desenha_prato = function()
{
    //y descendo quando tiver um minerio em cima
    if (desenho)
    {
        y_prato = lerp(y_prato, y - 80, .1);
    }
    else
    {
        y_prato = lerp(y_prato, y - 90, .1);
    }
    
    draw_sprite_ext(spr_balanca_prato, 0, x - 2, y_prato, xscale, yscale, 0, c_white, 1);
}

desenha_minerio = function()
{
    retorna_efeitos();
    
    //variaveis do texto do valor
    var _scale = .1 * escala_valor;
    
    //desenhando o minerio quando esta desenhado
    if (desenho)
    {
        //sombra
        draw_sprite_ext(spr_sombra, 0, x, y_prato - 5, 3, 1.2, 0, c_white, .25);
        
        //sprite do minerio
        draw_sprite_ext(sprite, minerio.sprite, x, y_minerio_atual, escala * xscale, escala * yscale, 0, cor_minerio, 1);
        
        //nome
        var _nome = string("[wave]{0}[/]", minerio.nome);
        texto_scribble_ext(x, y_minerio - 60, _nome, .15,, 1, 1,,,, typist_nome);
        
        //valor
        valor_desenhado = lerp(valor_desenhado, minerio.get_valor(), .2);
    }
    else
    {
        //diminuindo o valor pra 0
        valor_desenhado = lerp(valor_desenhado, 0, .5);
    }
    
    //texto do valor
    var _texto = string("${0}", formata_moeda(round(valor_desenhado)));
    texto_scribble_ext(x, y_minerio + 95, _texto, _scale, _scale, 1, 1, c_white);
}