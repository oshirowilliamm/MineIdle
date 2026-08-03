//só mostra se estiver desbloqueado
if (!upgrade.desbloqueado) exit;

//desenhando as linhas de conexão entre upgrade
desenha_conexao();

//se desenhando
var _sprite = spr_upgrade_bloqueado;

if (global.moeda >= upgrade.custo()) _sprite = spr_upgrade;
if (upgrade.level >= upgrade.level_max) _sprite = spr_upgrade_desbloqueado;

draw_sprite(_sprite, upgrade.sprite, x, y);