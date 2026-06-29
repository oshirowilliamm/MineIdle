//tirando a hud se estiver na room de lojas
var _salas = [rm_venda, rm_upgrade];

if (array_contains(_salas, room))
{
    hud = false;
}
else
{
    hud = true;
}