#Include "TOTVS.CH"

/*
   Programa.: Desicao.PRW
   Funcao...: U_If, U_IfElse, U_ElseIf, U_Case
   Autor....: Milton J.dos Santos
   Data.....: 01/01/2020
   Descricao: Exemplo do uso de IF-ENDIF CASE-ENDCASE

*/

/*/
    Exemplo de Decisao mostrando um alerta
/*/

User Function If()

Local nX := 10

If nX > 5
   MsgAlert("Maior")
EndIf

Return

User Function IfElse()

Local nX := 10
Local cMsg

If nX < 5
   cMsg := "Maior"
 Else
   cMsg := "Menor"
EndIf

MsgAlert(cMsg)

Return

User Function ElseIf()

Local cRegiao := "NE"
Local nICMS

If cRegiao == "SE"
   nICMS := 18
 ElseIf cRegiao == "NE"
   nICMS := 7
 Else
   nICMS := 12
EndIf

MsgAlert(nICMS)

Return

User Function Case()

Local nOpc := 2

Do Case
   Case nOpc == 1
        MsgAlert("Opcao 1 selecionada")
   Case nOpc == 2
        MsgAlert("Opcao 2 selecionada")
   Case nOpc == 3
        MsgAlert("Opcao 3 selecionada")
   Otherwise
        MsgAlert("Nenhuma opcao selecionada")
EndCase

Return
