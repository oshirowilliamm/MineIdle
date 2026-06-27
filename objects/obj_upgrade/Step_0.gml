selecao();

//mudando o upgrade de acordo com o tipo
switch (classe) 
{
    //dano
	case 0: upgrade = global.upgrades.dano[0]; break;
    
    //stamina
    case 1: upgrade = global.upgrades.stamina[0]; break;
}