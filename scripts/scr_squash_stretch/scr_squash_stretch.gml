function inicia_efeito_squash()
{
    //tamanho do player
    xscale = 1;
    yscale = 1;
}

function efeito_squash(_xscale, _yscale)
{
    xscale = _xscale;
    yscale = _yscale;   
}

function retorna_squash(_qtd = .1)
{
    xscale = lerp(xscale, 1, _qtd);
    yscale = lerp(yscale, 1, _qtd);
}

function desenha_efeito_squash()
{
    draw_sprite_ext(sprite_index, image_index, x, y, xscale, yscale, image_angle, image_blend, image_alpha);
}




//constructor para fazer varias vezes no mesmo objeto
function efeito_escala() constructor 
{
    xscale = 1;
    yscale = 1;
    
    //squash
    static squash = function(_xscale = 1.5, _yscale = _xscale)
    {
        xscale = _xscale;
        yscale = _yscale;
    }
    
    //suave
    static atualiza = function(_xscale = 1.5, _yscale = _xscale, _qtd = .1)
    {
        xscale = lerp(xscale, _xscale, _qtd);
        yscale = lerp(yscale, _yscale, _qtd);
    }
    
    //retorna
    static retorna = function(_qtd = .1)
    {
        xscale = lerp(xscale, 1, _qtd);
        yscale = lerp(yscale, 1, _qtd);
    }
}