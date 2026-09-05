global.minerios =
{
    #region Brutos
        
        #region Bioma 1
            
            b1_pedra:
            {
                nome: "Stone",
                sprite: 0,
                vida: 10,
                cor: cor_b1_pedra,
                drop_qtd: 1,
                //dados
                valor: 10,
                peso: 2,
            },
            b1_rocha1:
            {
                nome: "Ametilita",
                sprite: 1,
                vida: 20,
                cor: cor_b1_rocha1,
                drop_qtd: 1,
                //dados
                valor: 20,
                peso: 4,
                //refinação
                pedras: 20,
                qtd_refina: 5
            },
            b1_rocha2:
            {
                nome: "Malacuru",
                sprite: 2,
                cor: cor_b1_rocha2,
                vida: 40,
                drop_qtd: 1,
                //dados
                valor: 30,
                peso: 6,
                //refinação
                pedras: 40,
                qtd_refina: 2,
            },
            b1_cristal1:
            {
                nome: "Pererita",
                sprite: 3,
                cor: cor_b1_cristal1,
                vida: 60,
                drop_qtd: 1,
                //dados
                valor: 40,
                peso: 8,
                //refinação
                pedras: 60,
                qtd_refina: 4,
            },
            b1_cristal2:
            {
                nome: "Diarã",
                sprite: 4,
                cor: cor_b1_cristal2,
                vida: 100,
                drop_qtd: 1,
                //dados
                valor: 50,
                peso: 10,
                //refinação
                pedras: 80,
                qtd_refina: 4,
            },
            
        #endregion
        
    #endregion
    
    #region Puros
        
        #region Bioma 1
            
            b1_rocha1_puro:
            {
                nome: "Pure Ametilita",
                sprite: 0,
                cor: cor_b1_rocha1,
                drop_qtd: 1,
                //dados
                valor: 100,
                peso: 4,
                //refinação
                pedras: 20,
                qtd_refina: 2,
            },
            b1_rocha2_puro:
            {
                nome: "Pure Malacuru",
                sprite: 1,
                cor: cor_b1_rocha2,
                drop_qtd: 1,
                //dados
                valor: 150,
                peso: 6,
                //refinação
                pedras: 20,
                qtd_refina: 2,
            },
            b1_cristal1_puro:
            {
                nome: "Pure Pererita",
                sprite: 2,
                cor: cor_b1_cristal1,
                drop_qtd: 1,
                //dados
                valor: 200,
                peso: 8,
                //refinação
                pedras: 20,
                qtd_refina: 2,
            },
            b1_cristal2_puro:
            {
                nome: "Pure Diarã",
                sprite: 3,
                cor: cor_b1_cristal2,
                drop_qtd: 1,
                //dados
                valor: 250,
                peso: 10,
                //refinação
                pedras: 20,
                qtd_refina: 2,
            },
            
        #endregion
        
    #endregion
    
    #region Refinados
        
        #region Bioma 1
            
            b1_rocha1_refinado:
            {
                nome: "Ametilita Bar",
                sprite: 0,
                cor: cor_b1_rocha1,
                drop_qtd: 1,
                //dados
                valor: 200,
                peso: 4,
            },
            b1_rocha2_refinado:
            {
                nome: "Malacuru Bar",
                sprite: 1,
                cor: cor_b1_rocha2,
                drop_qtd: 1,
                //dados
                valor: 300,
                peso: 6,
            },
            b1_cristal1_refinado:
            {
                nome: "Pererita Jewel",
                sprite: 2,
                cor: cor_b1_cristal1,
                drop_qtd: 1,
                //dados
                valor: 400,
                peso: 8,
            },
            b1_cristal2_refinado:   
            {
                nome: "Diarã Jewel",
                sprite: 3,
                cor: cor_b1_cristal2,
                drop_qtd: 1,
                //dados
                valor: 500,
                peso: 10,
            },
            
        #endregion
        
    #endregion
}