/// @description Inserir descrição aqui
// Você pode escrever seu código neste editor

//seguindo o player
if (variable_instance_exists(id, "seq") && layer_sequence_exists("transicao", seq))
{
    if (instance_exists(obj_player))
    {
        layer_sequence_x(seq, obj_player.x);
        layer_sequence_y(seq, obj_player.yy);
    }
}


//Decidindo se eu posso começar a segunda transição
if (comecar_transicao_2)
{
    //Como o player não é persistente, eu vou existir antes dele na segunda room
	if (!instance_exists(obj_player))
	{
		show_message("ERRO: obj_player não encontrado");
		exit;
	}
    //E eu preciso criar a sequence na posição correta na câmera que se posiciona com base no player
    if (instance_exists(obj_player))
    {
        //durante 1 frame eu vou deixar a tela totalmente escura 
        //porque o player pode estar em outra posição e como este objeto é persistente, ele vai existir
        //Antes do player.
        //Então vou esperar o player ser criado para a camera achar a posição dele
        //E assim a sequencia pode ser criada na posição correta da câmera
        alarm[1] = 1;
    }
}


