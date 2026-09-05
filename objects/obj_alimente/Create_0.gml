//efeitos
escala = new efeito_escala();
scribble_anim_wave(2, .1, .1);



y_atual = y;

categoria = "minerios";
pedra_atual = 0;
qtd = 0;



alimentando = function()
{
    if (pedra_atual >= qtd)
    {
        //avisando q esta alimentando
        global.alimentando = true;
        
        //tirando a pedra do inventario
        global.inventario_global[$ categoria][$ "b1_pedra"] -= qtd;
        
        //indo pra vila
        cria_transicao_inicia(rm_vila);
        global.spawn_x = global.dest_x;
        global.spawn_y = global.dest_y;
    }
}

selecao = function()
{
    pedra_atual = global.inventario_global[$ categoria][$ "b1_pedra"];
    
    var _mouse_sobre = position_meeting(mouse_x, mouse_y, id);
    var _mouse_click = mouse_check_button_pressed(mb_left);
    
    if (_mouse_sobre && obj_cesta.desenho)
    {
        y_atual = lerp(y_atual, ystart + 10, .1);
        
        //quando clicar, alimenta
        if (_mouse_click)
        {
            alimentando();
        }
    }
    else
    {
        y_atual = lerp(y_atual, ystart, .1);
    }
}

desenha_feed = function()
{
    var _y = y_atual + 5;
    
    if (obj_cesta.desenho)
    {
        scribble_anim_shake(.5, .1);
        var _xscale = .15 * escala.xscale;
        var _yscale = .15 * escala.yscale;
        
        //se tem pedras necessárias
        if (pedra_atual >= qtd)
        {
            var _texto = "[wave][shake]FEED[/]";
            texto_scribble(x, _y, _texto, _xscale, _yscale, 1, 1, cor_positivo);
        }
        //se n tem pedras necessárias
        else
        {
            var _texto = "[shake]FEED[/]";
            texto_scribble(x, _y, _texto, _xscale, _yscale, 1, 1, cor_negativo);
        }
    }
    else
    {
        var _xscale = .12 * escala.xscale;
        var _yscale = .12 * escala.yscale;
        
        var _texto = "FEED";
        texto_scribble(x, _y, _texto, _xscale, _yscale, 1, 1, c_gray, .7);
    }
}

desenha_pedras = function()
{
    var _mouse_sobre = position_meeting(mouse_x, mouse_y, id);
    
    if (_mouse_sobre && obj_cesta.desenho)
    {
        var _sprite = "[scale, 15][spr_minerios, 0][scale, 1]";
        var _y = y_atual + 50;
        
        //se tem pedras necessárias
        if (pedra_atual >= qtd)
        {
            var _texto = string("[wave]{2} [cor_positivo]{0}[/c] / {1}[/]", pedra_atual, qtd, _sprite);
            texto_scribble(x - 5, _y, _texto, .1, .1, 1, 1);
        }
        //se n tem pedras necessárias
        else
        {
            var _texto = string("[wave]{2} [cor_negativo]{0}[/c] / {1}[/]", pedra_atual, qtd, _sprite);
            texto_scribble(x - 5, _y, _texto, .1, .1, 1, 1);
        }
    }
}