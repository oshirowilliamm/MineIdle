depth = -99999;

//janelas
view_player = false;
view_bloco = false;

//controle de funções
//player
draw_mask_player = false;
draw_linha = false;
draw_depth_player = false;
noclip = false;

//bloco
draw_vida_bloco = false;
draw_regenera_bloco = false;
draw_depth_bloco = false;

item_ganha = false;



cria_painel = function()
{
    show_debug_overlay(1);
    
    //player
    if (instance_exists(obj_player))
    {
        view_player = dbg_view("Player", true, 20, 80);
        
        //debugs
        dbg_watch(ref_create(obj_player, "image_index"), "image_index");
        dbg_slider(ref_create(obj_player, "spd"), 2, 20, "Velocidade", 1);
        dbg_checkbox(ref_create(id, "draw_depth_player"), "Depth");
        dbg_checkbox(ref_create(id, "noclip"), "NoClip");
        dbg_checkbox(ref_create(id, "draw_linha"), "Linha de Mineração");
        dbg_checkbox(ref_create(id, "draw_mask_player"), "Máscara de Colisão");
        dbg_slider(ref_create(global.picareta, "dano"), 5, 100, "Dano Picareta", 1);
        dbg_slider(ref_create(global, "alcance_lanterna"), .3, 5, "Alcance Lanterna", .1);
        dbg_slider(ref_create(global, "moeda"), 0, 1000, "Moeda", 1);
        dbg_button("Ganhar Itens", ganha_itens);
    }
    
    //blocos
    view_bloco = dbg_view("Bloco", true, 520, 80);
    
    //debugs
    dbg_checkbox(ref_create(id, "draw_vida_bloco"), "Vida");
    dbg_checkbox(ref_create(id, "draw_regenera_bloco"), "Regeneração");
    dbg_checkbox(ref_create(id, "draw_depth_bloco"), "Depth");
}

deleta_painel = function()
{
    show_debug_overlay(0);
    
    if (dbg_view_exists(view_player)) dbg_view_delete(view_player);
    if (dbg_view_exists(view_bloco)) dbg_view_delete(view_bloco);
}

ativa_painel = function()
{
    if (!DEBUG_MODE) return;
    
    if (keyboard_check_pressed(vk_tab))
    {
        //alterando o valor do global.debug
        global.debug = !global.debug;
        
        if (global.debug)
        {
            cria_painel();
        }
        else
        {
            deleta_painel();
        }
    }
}


//funções
#region Player
    
    funcoes_player = function()
    {
        desenha_linha_mineracao();
        desenha_mascara_player();
        desenha_depth_player();
    }
    
    ativa_noclip = function()
    {
        if (!instance_exists(obj_player)) return;
        
        obj_player.colisoes = noclip ? [] : obj_player.colisoes_originais;
    }
    
    ganha_itens = function()
    {
        var _chaves = struct_get_names(global.minerios);
        for (var i = 0; i < array_length(_chaves); i++)
        {
            var _item = _chaves[i];
            
            //brutos
            if (global.inventario_global.minerios[$ _item] == undefined) global.inventario_global.minerios[$ _item] = 0;
            
            global.inventario_global.minerios[$ _item] += 5;
            
            //limpos
            if (global.inventario_global.limpos[$ _item] == undefined) global.inventario_global.limpos[$ _item] = 0;
            
            global.inventario_global.limpos[$ _item] += 5;
            
            //refinados
            if (global.inventario_global.refinados[$ _item] == undefined) global.inventario_global.refinados[$ _item] = 0;
            
            global.inventario_global.refinados[$ _item] += 5;
        }
    }
    
    desenha_linha_mineracao = function()
    {
        if (!draw_linha || !instance_exists(obj_player)) return;
        
        var _linha = obj_player.linha_mineracao();
        
        draw_line(obj_player.x, obj_player.yy, _linha.x, _linha.y);
    }
    
    desenha_mascara_player = function()
    {
        if (!draw_mask_player || !instance_exists(obj_player)) return;
        
        with (obj_player) 
        {
        	draw_set_colour(c_fuchsia);
            
            //fundo
            draw_set_alpha(.2);
            draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, 0);
            
            //out
            draw_set_alpha(1);
            draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, 1);
            
            draw_set_colour(-1);
        }
    }
    
    desenha_depth_player = function()
    {
        if (!draw_depth_player || !instance_exists(obj_player)) return;
        
        with (obj_player) 
        {
        	draw_text(x, y, depth);
        }
    }
    
#endregion

#region Bloco
    
    funcoes_bloco = function()
    {
        desenha_vida_bloco();
        desenha_regenera_bloco();
        desenha_depth_bloco();
    }
    
    desenha_vida_bloco = function()
    {
        if (!draw_vida_bloco || !instance_exists(obj_minerio)) return;
        
        with (obj_minerio) 
        {
        	draw_set_font(fnt_debug);
            draw_text_transformed(x, y, string("Vida: {0}\nMax: {1}", vida, max_vida), .1, .1, 0)
            draw_set_font(-1);
        }
    }
    
    desenha_regenera_bloco = function()
    {
        if (!draw_regenera_bloco || !instance_exists(obj_minerio)) return;
        
        with (obj_minerio) 
        {
        	draw_set_font(fnt_debug);
            draw_text_transformed(x, y + 10, string(timer), .1, .1, 0)
            draw_set_font(-1);
        }
    }
    
    desenha_depth_bloco = function()
    {
        if (!draw_depth_bloco || !instance_exists(obj_minerio)) return;
        
        with (obj_minerio) 
        {
        	draw_text(x, y, depth);
        }
    }
    
#endregion