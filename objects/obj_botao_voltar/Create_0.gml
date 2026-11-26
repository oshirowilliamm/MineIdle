escala = new efeito_escala();
lesma = false;



voltar = function()
{
    //voltar normal
    if (!lesma)
    {
        cria_transicao(rm_vila, "tela");
    }
    //voltar da refinação
    else
    {
        if (instance_exists(obj_lesma))
        {
            obj_lesma.sai_refinacao();
        }
        
        instance_destroy();   
    }
}