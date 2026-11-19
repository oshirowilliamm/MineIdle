atalhos();
aplica_cheats();

//o monitor só trabalha se estiver aparecendo em algum lugar
if (mostra_monitor || global.debug) atualiza_monitor();

//texto do estado (só o painel usa)
if (global.debug && instance_exists(obj_player))
{
    estado_player_txt = "Estado: " + nome_estado(obj_player);
}
