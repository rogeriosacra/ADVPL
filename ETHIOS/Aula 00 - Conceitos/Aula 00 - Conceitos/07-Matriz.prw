#Include "TOTVS.CH"

/*
   Programa.: Matriz.PRW
   Funcao...: U_Matriz()
   Autor....: Milton J.dos Santos
   Data.....: 01/01/2020
   Descricao: Exemplo de usos de variaveis do tipo matriz

   Matrizes ou vetores sao uteis para conjuntos de dados
   
*/

// Mostrando uma Array ( Matriz ou Vetor ) Comum 

User Function Matriz()

Local aArray := {"Joao", "Alberto", "Pedro", "Maria"}

Alert( aArray[1] )
Alert( aArray[2] )
Alert( aArray[3] )
Alert( aArray[4] )

Return Nil

