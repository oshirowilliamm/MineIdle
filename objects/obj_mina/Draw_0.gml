global.mina.brilho_frame = draw_animation(global.mina.brilho_frame, spr_brilho);

global.mina.blocos_visiveis(function(_bloco, _x, _y)
{
    global.mina.desenha_rachaduras(_bloco, _x, _y);
    global.mina.desenha_brilho(_bloco, _x, _y);
});
