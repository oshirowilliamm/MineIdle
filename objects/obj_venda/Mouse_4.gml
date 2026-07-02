var _item = global.inventario[item];

if (_item.quantidade > 0)
{
    //removendo item
    _item.quantidade--;
    
    //removendo peso do inventario
    global.peso_atual -= _item.peso;
    
    //trocando item por dinheiro
    global.moeda += _item.valor;
}