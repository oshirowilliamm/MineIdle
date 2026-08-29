room_goto(destino);

//colocando os itens da sacola no inventario
if (destino == rm_vila)
{
    for (var i = 0; i < array_length(global.inventario.minerio); i++)
    {
        //colocando no inventario
        global.inventario.minerio[i].quantidade += global.inventario_sacola.minerio[i];
        
        //resetando a sacola
        global.inventario_sacola.minerio[i] = 0;
    }
}