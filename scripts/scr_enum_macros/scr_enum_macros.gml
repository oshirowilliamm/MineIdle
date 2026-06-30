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

//macros da mina
//tamanho da celula
#macro MINA_SIZE_W 32     
#macro MINA_SIZE_H 32 

//tamanho da parede    
#macro MINA_TAM_PAREDE 64 

//posição inicial da chunk
#macro MINA_CHUNK_X (5 * MINA_TAM_PAREDE) 
#macro MINA_CHUNK_Y MINA_TAM_PAREDE       

//tamanho da chunk
#macro MINA_CHUNK_W 16              
#macro MINA_CHUNK_H 20              
#macro MINA_TOTAL_CHUNKS 50  

//margem de colunas extras da chunk       
#macro MINA_MARGEM 2                