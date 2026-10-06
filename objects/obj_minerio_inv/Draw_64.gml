EM_TRANSICAO

//controlando o desenho se tiver no shop
if (room == rm_shop)
{
    if (global.shop == "venda")
    {
        desenha_minerio();
    }
}
else
{
    desenha_minerio();
}