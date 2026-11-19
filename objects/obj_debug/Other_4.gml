//sala nova: o mapa e a contagem de blocos recomeçam
mapa_sujo = true;
reseta_monitor();

//as referências do painel podem ter mudado (picareta, player)
if (global.debug) recria_painel();
