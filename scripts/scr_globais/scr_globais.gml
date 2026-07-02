//blocos da mina
enum BLOCOS 
{
	vazio = -1,
    borda, 
    pedra,
    roxo,
    verde,
    azul,
    amarelo
}

//itens / drops
enum ITENS
{
    pedra,
    roxo,
    verde,
    azul,
    amarelo
}

//mina
global.mina = noone;

//dinheiro
global.moeda = 0;

//stamina
global.stamina_max = 100;
global.stamina_atual = global.stamina_max;
global.stamina_dano = 2;

//peso do inventario
global.peso_max = 2000;
global.peso_atual = 0;