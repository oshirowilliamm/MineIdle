event_inherited();

sprite_index = sprite;



entra_loja = function()
{
    cria_transicao(destino, "tela");
    
    global.dest_x = dest_x;
    global.dest_y = dest_y;
}

//definindo a interação do player
x_interacao = x;
y_interacao = y_origem;
acao = entra_loja;