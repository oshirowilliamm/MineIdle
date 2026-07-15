function teste(){
    //desenhando o inventario
    desenha_inventario = function()
    {
        draw_set_font(fnt_ui);
        
        //não desenha na mina nem no upgrades
        if (room == rm_mina || room == rm_upgrade) exit;
        
        //medidas base
        var _hminerio = sprite_get_height(spr_minerios) * escala;
        var _wminerio = sprite_get_width(spr_minerios) * escala;
        var _slot_minerio = _wminerio + 150;
        
        var _xmargem = 50;
        var _ymargem = 20;
        var _fundo_margem = 10; 
        
        // -------------------------------------------------------------
        // PASSO 1: QUANTAS "COLUNAS" VAMOS TER?
        // -------------------------------------------------------------
        var _colunas_ativas = 0;
        var _tamanho_lista_brutos = array_length(global.inventario.minerio);
        
        for (var i = 0; i < _tamanho_lista_brutos; i++)
        {
            var _cru_descoberto = global.inventario.minerio[i].descoberto;
            var _refinado_descoberto = false;
            
            // CORREÇÃO: Se NÃO for a pedra (i > 0), verificamos o refinado de índice (i - 1)
            if (i > 0)
            {
                var _index_refinado = i - 1;
                // Checagem extra de segurança para evitar erro de Array Out of Bounds
                if (_index_refinado < array_length(global.inventario.refinado))
                {
                    _refinado_descoberto = global.inventario.refinado[_index_refinado].descoberto;
                }
            }
            
            if (_cru_descoberto || _refinado_descoberto)
            {
                _colunas_ativas++;
            }
        }
        
        // -------------------------------------------------------------
        // PASSO 2: CÁLCULOS DE POSIÇÃO CENTRALIZADA
        // -------------------------------------------------------------
        var _wminerio_total = _colunas_ativas * _slot_minerio;
        var _xcentro = (display_get_gui_width() / 2) + 70;
        
        var _x_inicial = _xcentro - (_wminerio_total / 2);
        var _y_base = 660;
        var _y_refinado = _y_base - 100;
        
        var _coluna_atual = 0;
        
        // -------------------------------------------------------------
        // PASSO 3: DESENHANDO A COLUNA
        // -------------------------------------------------------------
        for (var i = 0; i < _tamanho_lista_brutos; i++)
        {
            var _item_cru = global.inventario.minerio[i];
            var _cru_desc = _item_cru.descoberto;
            
            // Preparando a verificação do item refinado correspondente
            var _ref_desc = false;
            var _item_refinado = undefined;
            var _index_ref = i - 1; // O índice da sprite e do array refinado
            
            // Novamente, só pega o refinado se NÃO for a Pedra
            if (i > 0 && _index_ref < array_length(global.inventario.refinado))
            {
                _item_refinado = global.inventario.refinado[_index_ref];
                _ref_desc = _item_refinado.descoberto;
            }
            
            // Se nenhum dos dois existe/foi descoberto, pula pro próximo minério
            if (_cru_desc == false && _ref_desc == false) continue;
            
            var _x_coluna = _x_inicial + (_coluna_atual * _slot_minerio);
            
            // --- DESENHA O MINÉRIO BRUTO (sempre usa índice 'i') ---
            if (_cru_desc)
            {
                var _xquant_cru = _x_coluna + _xmargem;
                var _yquant_cru = _y_base - _ymargem;
                
                var _xfundo_cru = _x_coluna - (_wminerio / 2) - _fundo_margem;
                var _yfundo_cru = _y_base - (_hminerio / 2) - _fundo_margem;
                var _wfundo_cru = _wminerio + string_width(_item_cru.quantidade) + _xmargem;
                var _hfundo_cru = _hminerio + _fundo_margem * 2;
                
                draw_sprite_stretched_ext(spr_fundo, 0, _xfundo_cru, _yfundo_cru, _wfundo_cru, _hfundo_cru, c_white, .5);
                draw_sprite_ext(spr_minerios, i, _x_coluna, _y_base, escala, escala, 0, c_white, 1);
                draw_text(_xquant_cru, _yquant_cru, _item_cru.quantidade);
            }
            
            // --- DESENHA O REFINADO (sempre usa índice '_index_ref') ---
            if (_ref_desc)
            {
                var _xquant_ref = _x_coluna + _xmargem;
                var _yquant_ref = _y_refinado - _ymargem;
                
                var _xfundo_ref = _x_coluna - (_wminerio / 2) - _fundo_margem;
                var _yfundo_ref = _y_refinado - (_hminerio / 2) - _fundo_margem;
                var _wfundo_ref = _wminerio + string_width(_item_refinado.quantidade) + _xmargem;
                var _hfundo_ref = _hminerio + _fundo_margem * 2;
                
                draw_sprite_stretched_ext(spr_fundo, 0, _xfundo_ref, _yfundo_ref, _wfundo_ref, _hfundo_ref, c_white, .5);
                
                // Repare que desenhamos a sprite usando _index_ref para não errar a imagem!
                draw_sprite_ext(spr_refinados, _index_ref, _x_coluna, _y_refinado, escala, escala, 0, c_white, 1);
                draw_text(_xquant_ref, _yquant_ref, _item_refinado.quantidade);
            }
            
            _coluna_atual++;
        }
        
        draw_set_font(-1);
    }
}