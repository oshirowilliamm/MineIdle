scribble_anim_wave(2, .1, .1);

texto = "";
escala_texto = .2
margem = 20;

//iniciando vazia
fundo_alpha = 0;
fundo_width = 0;
fundo_height = 0;

x_inicial = 0;
y_inicial = 0;

//variaveis de controle
destroi = false
desenha_texto = false;



iniciando = function()
{
    if (destroi) return;
    
    //aparecendo
    fundo_alpha = lerp(fundo_alpha, 1, .2);
    
    //tamanho maximo do fundo
    var _txt = scribble(texto).starting_format("fnt_game", c_white).scale(escala_texto);
    var _max_width  = _txt.get_width() + margem * 2;
    var _max_height = _txt.get_height() + margem * 2;
    
    //animação
    fundo_width = lerp(fundo_width, _max_width, .2);
    fundo_height = lerp(fundo_height, _max_height, .2);
    x_inicial = lerp(x_inicial, 35, .1);
    y_inicial = lerp(y_inicial, -80, .1);
    
    //se tiver visivel, mostra o texto
    if (fundo_alpha >= .9) 
    {
        desenha_texto = true;
    }
}

destruindo = function()
{
    if (!destroi) return;
    
    //animação
    fundo_width = lerp(fundo_width, 0, .2);
    fundo_height = lerp(fundo_height, 0, .2);
    fundo_alpha = lerp(fundo_alpha, 0, .2);
    x_inicial = lerp(x_inicial, 0, .4);
    y_inicial = lerp(y_inicial, 0, .4);
    
    //apagando o texto
    desenha_texto = false;
    
    //se destruindo
    if (fundo_alpha <= .01)
    { 
        instance_destroy();
    }
}

desenha_info = function()
{
    //fundo
    var _xfundo = max(x + x_inicial - fundo_width / 2, 0);
    var _yfundo = max(y + y_inicial - fundo_height / 2, 0);
    draw_sprite_stretched_ext(spr_fundo_infos, 0, _xfundo, _yfundo, fundo_width, fundo_height, c_white, fundo_alpha);
    
    if (!desenha_texto) return;
    
    //texto
    var _xtxt = round(_xfundo + fundo_width / 2);
    var _ytxt = _yfundo + fundo_height / 2;
    texto_scribble(_xtxt, _ytxt - 10, texto, escala_texto, , 1, 1)
}