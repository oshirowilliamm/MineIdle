var _item = global.inventario.minerio[item];

if (_item.quantidade > 0)
{
    //removendo item
    _item.quantidade--;
    
    //removendo peso do inventario
    global.peso_atual -= _item.peso;
    
    //removendo minerios do saco
    obj_hud.peso_atual -= _item.peso;
    
    //trocando item por dinheiro
    global.moeda += _item.valor;
}