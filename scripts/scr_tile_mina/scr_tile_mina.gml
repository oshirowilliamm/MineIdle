//função para pegar id do tile de acordo com o tipo de bloco
function get_tile_id(_bloco_tipo)
{
    switch (_bloco_tipo) 
    {
        case BLOCOS.pedra:      return 1;
        case BLOCOS.roxo:       return 2;
        case BLOCOS.verde:      return 3;  
        case BLOCOS.azul:       return 4;
        case BLOCOS.amarelo:    return 5;  
        default:                return 0;
    }
}

//arrumando bug de tiles nao aparecendo quando a room acaba
function ajusta_tamanho_tile()
{
    //pegando largura total da room em celulas
    var _largura_room = total_chunks * chunk_w * size_w + chunk_x;
    
    //id dos tiles
    var _tile_id_minerios = layer_exists("tl_minerios") ? layer_tilemap_get_id("tl_minerios") : -1;
    var _tile_id_rachaduras = layer_exists("tl_rachaduras") ? layer_tilemap_get_id("tl_rachaduras") : -1;
    
    //tile minerios
    tilemap_set_width(_tile_id_minerios, _largura_room);
    tilemap_set_width(_tile_id_rachaduras, _largura_room);
}