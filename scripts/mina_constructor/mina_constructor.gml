function mina_sistema() constructor
{
    //iniciando as definições dos blocos
    mina_ini_defs();
    
    //carregando os chunks
    carrega_chunks = mina_carrega_chunks;
    
    //permitindo minerar blocos
    minera_bloco = mina_minera_bloco;
    
    //regenera bloco
    regenera_bloco = mina_regenera_bloco;
    
    #region Funções de Desenho
        
        //função para rachaduras do bloco
        static desenha_rachadura = function(_x, _y)
        {
            //pegando o bloco
            var _bloco = mina_get_bloco(_x, _y);
            if (!_bloco) return false;
            
            //pegando vida maxima e atual do bloco
            var _hp_max = global.bloco_defs[_bloco.index].hp;
            var _hp_atual = _bloco.hp;
            
            //porcentagens
            var _porc = (_hp_atual / _hp_max) * 100;
            var _1 = 80;
            var _2 = 60;
            var _3 = 40;
            var _4 = 20;
            
            //desenhando quebrado de acordo com a vida do bloco
            var _index = 0;
            
            if (_porc <= 100 && _porc > _1)     _index = 0; //100% da vida
            else if (_porc <= _1 && _porc > _2) _index = 1; //80% da vida
            else if (_porc <= _2 && _porc > _3) _index = 2; //60% da vida
            else if (_porc <= _3 && _porc > _4) _index = 3; //40% da vida
            else if (_porc <= _4)               _index = 4; //20% da vida
            
            //desenhando as rachaduras
            var _tile_id = layer_exists("tl_rachaduras") ? layer_tilemap_get_id("tl_rachaduras") : -1;
            tilemap_set_at_pixel(_tile_id, _index, _x, _y);
        }
        
        //função para colocar brilho 
        static desenha_brilho = function(_x, _y, _bloco_id)
        {
            //não desenhar em pedra
            if (_bloco_id == BLOCOS.pedra) exit;
                
            var _frames = sprite_get_number(spr_brilho);
            var _frame_atual = (current_time / 100) % _frames;
            
            // O pulo do gato: Blend Mode Aditivo
            gpu_set_blendmode(bm_add);
            
            // Desenha o brilho por cima do bloco
            draw_sprite(spr_brilho, _frame_atual, _x, _y);
            
            // Resetar o blend mode para não estragar o resto do desenho
            gpu_set_blendmode(bm_normal);
        }
        
    #endregion
}