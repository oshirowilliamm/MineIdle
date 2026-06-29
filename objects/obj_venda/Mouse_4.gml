var _bloco = global.inventario[tipo_bloco];

if (_bloco.quantidade > 0)
{
    //removendo item
    _bloco.quantidade--;
    
    //trocando item por dinheiro
    global.moeda += _bloco.valor;
}