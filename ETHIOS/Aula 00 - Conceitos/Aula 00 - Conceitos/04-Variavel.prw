#INCLUDE "TOTVS.CH"

/*

    Programa.: Variavel.PRW
    Autor....: Milton J.dos Santos
    Data.....: 01/01/2020

    Toda funcao necessita de variaveis para controlar os resultados do processamento

    As variaveis precisam ser Declaradas e Tipadas:

        Declaracao de variaveis:
            Local...: - Visivel apenas dentro da FUNCTION que foi criada do próprio fonte .PRW ou PRX
            Private.: - Visivel a partir da FUNCTION que foi criada, e em todos as FUNCTION e fontes posteriores
            Public..: - Visivel em todos as FUNCTION nos fontes .PRW ou .PRX a partir do momento que ela foi criada.
            Static..: - Visivel em todas as FUNCTION apenas no .PRW ou .PRX que foi criada.

        Tipagem das variaveis:
            (C) Caracter   = Caracter ( também chamado de String )
            (D) Date       = Data
            (L) Logical    = Logica
            (N) Numeric    = Numerica
            (A) Array      = Vetor
            (B) Code Block = Bloco de Codigo
            (O) Object     = Objeto

    As variaveis sao trabalhadas em memoria, algumas sao descartadas depois do uso e outras sao salvas em tabelas ou arquivos

    Mais informações: https://tdn.totvs.com/pages/viewpage.action?pageId=6063093

/*/

User Function Variavel
Local    cVar1
Static   cVar2
Private  cVar3
Public   cVar4

cVar1 := "Variavel 1"
cVar2 := "Variavel 2"
cVar3 := "Variavel 3"
cVar4 := "Variavel 4"

// Abaixo, somente a variaveis que a funcao pode exergar
Alert( cVar1 )

Variavel()

RETURN

// A seguir, somente as variaveis que a funcao pode exergar
Static Function Variavel

Alert( cVar2 )
Alert( cVar3 )
Alert( cVar4 )

RETURN
