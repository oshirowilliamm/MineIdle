//efeitos
escala = new efeito_escala();

modos = [1, 5, "MAX"];
modo_atual = 0;




troca_modo = function()
{
    //avançando pro prox modo
    if (modo_atual < array_length(modos) - 1)
    {
        modo_atual++;
    }
    else
    {
        modo_atual = 0;
    }
    
    //definindo o modo
    global.modo_venda = modos[modo_atual];
}

selecao = function()
{
    var _mouse_sobre = position_meeting(mouse_x, mouse_y, id);
    var _mouse_click = mouse_check_button_pressed(mb_left);
    
    if (_mouse_sobre)
    {
        escala.atualiza(1.3,, .2);
        
        if (_mouse_click) 
        {
            troca_modo();
            
            escala.squash(2, 2);
        }
    }
    else
    {
        escala.retorna(.2);
    }
}

desenha_texto = function()
{
    var _xscale = .1 * escala.xscale;
    var _yscale = .1 * escala.yscale;
    var _texto = "";
    
    //definindo o texto de acordo com o modo
    if (modos[modo_atual] == "MAX")
    {
        _texto = "MAX";
    }
    else
    {
        _texto = string("x{0}", modos[modo_atual]);
    }
    
    //desenhando o texto
    texto_scribble(x, y, _texto, _xscale, _yscale, 1, 1)
}