//macros da mina
//tamanho da celula
#macro MINA_SIZE_W 32     
#macro MINA_SIZE_H 32 

//tamanho da parede    
#macro MINA_TAM_PAREDE 64 

//tamanho da chunk
#macro MINA_CHUNK_W 12           
#macro MINA_CHUNK_H 24        
#macro MINA_TOTAL_CHUNKS 100

//margem de colunas extras da chunk       
#macro MINA_MARGEM 1

function mina_sistema() constructor
{
    //dados da mina
    chunks = {};
    bloco_defs = {};
    brilho_frame = 0;       //pra animação do brilho do minério
    blocos_machucados = []; //pra regeneração do bloco
    
    //id dos tiles
    global.tile_minerio = layer_tilemap_get_id("tl_minerios");
    global.tile_chao    = layer_tilemap_get_id("tl_chao");
    global.tile_bordas  = layer_tilemap_get_id("tl_bordas");
    global.tile_paredes_borda = layer_tilemap_get_id("tl_paredes_borda");
    global.tile_paredes_minerio = layer_tilemap_get_id("tl_paredes_minerio");
    
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
    desenha_escuridao = mina_desenha_escuridao;
    
    //função auxiliar pra rodar os blocos visiveis
    blocos_visiveis = mina_blocos_visiveis;
    
}