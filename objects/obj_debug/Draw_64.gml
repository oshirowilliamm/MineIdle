//nada ligado = nada a fazer
if (!(mostra_monitor || mostra_info_player || mostra_tooltip || mostra_vida_blocos
    || mostra_mapa || mostra_chances || (mostra_log && array_length(log_linhas) > 0))) exit;

desenha_gui();
