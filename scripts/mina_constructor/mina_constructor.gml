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

function mina_sistema() constructor
{
    //dados da mina
    chunks = {};
    bloco_defs = {};
    chance_spawn_total = 0;
    brilho_index = 0;       //pra animação do brilho do minério
    blocos_machucados = []; //pra regeneração do bloco
    
    //id dos tiles
    global.tile_minerio = layer_tilemap_get_id("tl_minerios");
    global.tile_chao    = layer_tilemap_get_id("tl_chao");
    
    //iniciando as definições dos blocos
    mina_ini_defs();
    
    //carregando os chunks
    carrega_chunks = mina_carrega_chunks;
    
    //blocos
    minera_bloco = mina_minera_bloco;
    regenera_bloco = mina_regenera_bloco;
    
    //desenho
    desenha_rachaduras = mina_desenha_rachaduras;
    desenha_brilho = mina_desenha_brilho;
    
    //função auxiliar pra rodar os blocos visiveis
    blocos_visiveis = mina_blocos_visiveis;
    
}