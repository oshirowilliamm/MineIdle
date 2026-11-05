index = 0;
escala = 3;

//variaveis de posição
x_dest = 110;
y_inicial = y;

//variavel do efeito y
onda = false;

//variavel de controle para mostrar as infos da picareta
infos = false;





efeito_y = function()
{
    var _dest = ystart - 20
    
    if (!onda)
    {
        //subindo a picareta
        y = lerp(y, _dest, .1);
        
        //quando terminar de subir, avisar a onda
        if (abs(y - _dest) <= .5) onda = true;
    }
    else    
    {
        //efeito de onda
        var _sinwave = 6 * sin(2 * current_time / 1000);
        y = lerp(y, _dest + _sinwave, .1);
    }
}   

mostra_info = function()
{
    if (!infos) return;
    
    var _wcaixa = 300;
    var _hcaixa = 100;
    var _xcaixa = x - _wcaixa / 2;
    var _ycaixa = ystart - 200;
    
    draw_sprite_stretched(spr_caixa, 0, _xcaixa, _ycaixa, _wcaixa, _hcaixa);
}

selecao = function()
{
    var _mouse_sobre = position_meeting(mouse_x, mouse_y, id);
    
    if (_mouse_sobre)
    {
        //mouse segurando o botão
        if (global.mouse_hold)
        {
            tween_scale(escala - .2, tween_animation.flat, 30);
        }
        //mouse em cima
        else
        {
            tween_scale(escala + 1, tween_animation.back, 30);
            efeito_y();
            infos = true;
        }
        
        //clicando
        if (global.mouse_released)
        {
            
        }   
    }   
    //normal
    else
    {
        tween_scale(escala, tween_animation.back, 30);
        y = lerp(y, ystart, .1);
        
        onda = false;
        infos = false;
    }
}