#INCLUDE "TOTVS.CH"

/*/

    Programa.: Parametro.PRW
    Autor....: Milton J.dos Santos
    Data.....: 01/01/2020

    Parametros sao muito usados para enviar informacopes ( variaveis) para outro bloco processar

    Nos exemplos abaixo temos:
    - U_Parametros()   que nao espera parametro e nao envia parametro
    - DefaultExample() que nao espera parametro e nao envia parametro e depois envia parametro
    - OldFunction()    que espera parametro, se nao recebe-lo usa um valor padrao, se rebecer o-utiliza

/*/

User Function Parametros

// Rotina nao esta enviando parametro
DefaultExample()

RETURN

// Funcao nao espera parametro
Static Function DefaultExample()

//  Rotina sem paramentro
    Alert( OldFunction() )      
//  Rotina com paramentro
    Alert( OldFunction(33) )

Return

// Rotina espera um parametro nNewPar
Static Function OldFunction( nNewPar )
Local nRet      := 0

// Caso o parametro nNewPar esteja vazio, utiliza o valor padrao 10
Default nNewPar := 10

       // Uso o nNewPar sem problema
       nRet := 10 * nNewPar

// Variavel de Retorno "nRet"
Return nRet
