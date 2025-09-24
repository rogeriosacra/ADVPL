#INCLUDE "TOTVS.CH"

/*/
 
    Programa.: Funcao.PRW
    Funcao...: U_Funcao()
    Autor....: Milton J.dos Santos
    Data.....: 01/01/2020

    Regras na criação de funcoes:
    - USER FUNCTION   = Funcao criada pelo Usuario
    - FUNCTION        = Funcao criada pela TOTVS
    - STATIC FUNCTION = Funcao criada pelo Usuario e pela TOTVS, porém só vista pelas funcoes do PRW ATUAL

/*/

// Esta funcao e chamada como U_FUNCAO()

User Function FUNCAO

Alert("User Function = U_FUNCAO")

FUNCAO()

RETURN

// Esta funcao e chamada como FUNCAO()

Static Function FUNCAO

Alert("Static Function = FUNCAO")

RETURN

