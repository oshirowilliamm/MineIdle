selecao();

//mudando o upgrade de acordo com a classe e o tipo
switch (classe) 
{
    //dano
	case 0:  
        switch (tipo) 
        {
        	case 0: upgrade = global.upgrades.dano[0]; break;
        }
    break;
        
    //stamina
    case 1: 
        switch (tipo) 
        {
            case 0: upgrade = global.upgrades.stamina[0]; break;
        }
    break;
}

//mostrando infos
if (position_meeting(mouse_x, mouse_y, id))
{
    infos = true;
}
else 
{
	infos = false;
}