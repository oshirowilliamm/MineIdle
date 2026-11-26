//atualizando o tamanho do display pra full hd
display_set_gui_size(1920, 1080);

//variaveis de mouse
global.mouse_hud        = false;
global.mouse_hold       = noone;
global.mouse_pressed    = noone;
global.mouse_released   = noone;

//fonte com outline
font_outline = function()
{
    //setando a fonte com outline
    var _x = 0;
    var _y = 2;
    
    shader_set(sh_meu_outline);
    shader_set_uniform_f(shader_get_uniform(sh_meu_outline, "u_vShadowDelta"), _x, _y);
    shader_reset();
    
    var _grossura = 2;
    var _esq  = _grossura + max(0, -_x);
    var _cima = _grossura + max(0, -_y);
    var _dir  = _grossura + max(0,  _x);
    var _baixo = _grossura + max(0, _y);
    
    scribble_font_bake_shader("fnt_pixel", "fnt_pixel_outline", sh_meu_outline, 2, _esq, _cima, _dir, _baixo, 0, false, 2048, true);
}

//contador de click
global.mouse_clicado    = noone;
atraso_click = 20;
intervalo_click = 6;
timer_click = 0;

click_segurado = function()
{
    //avisando q o mouse n esta clicado no começo
    global.mouse_clicado = false;
    
    //primeiro click
    if (global.mouse_pressed)
    {
        //tempo para começar a ter o mouse clicado
        global.mouse_clicado = true;
        timer_click = atraso_click;
    }
    //segurando
    else if (global.mouse_hold)
    {
        timer_click--;
        
        if (timer_click <= 0)
        {
            //colocando o intervalo entre os clicks
            global.mouse_clicado = true;
            timer_click = intervalo_click;
        }
    }
}



font_outline();