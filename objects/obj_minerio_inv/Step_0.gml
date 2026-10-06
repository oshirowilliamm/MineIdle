EM_TRANSICAO

//controlando o desenho se tiver no shop
if (room == rm_shop)
{
    if (global.shop == "venda")
    {
        segue_inventario();
        selecao();
    }
}
else
{
    segue_inventario();
    selecao();
}