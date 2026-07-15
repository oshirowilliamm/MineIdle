//blocos da mina
enum BLOCOS 
{
	vazio = -1,
    borda, pedra, roxo, verde, azul, amarelo
}

//itens / drops
enum ITENS
{
    pedra, roxo, verde, azul, amarelo
}

//mina
global.mina = noone;
global.bioma_chunks = 11; //quantidade de chunks por bioma

//dinheiro
global.moeda = 0;

//stamina
global.stamina_max = 50;
global.stamina_atual = global.stamina_max;
global.stamina_dano = 2;

//peso do inventario
global.peso_max = 5000;
global.peso_atual = 0;