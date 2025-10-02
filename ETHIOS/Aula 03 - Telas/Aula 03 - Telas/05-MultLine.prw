#Include 'TOTVS.CH'

/*/{Protheus.doc} U_MultLine
    @type		Function
    @author		Milton J.dos Santos
    @since		01/03/2020
    @version	1.0.0
    @param		Nenhum
    @return		Vazio (nil)
    @example    Exemplo da utilizacao de Get MultiLine 
    @see		https://tdn.engpro.totvs.com.br/display/tec/@+...+GET+MULTILINE
/*/

User Function MultLine()
Local oDlg, oGet, cText := ''

DEFINE MsDialog oDlg TITLE "Exemplo TMultiGet" FROM 180,180 TO 550,700 PIXEL

// Cria o Objeto tGet usando o comando @ .. GET MULTILINE
@ 10,10 GET oGet VAR cText SIZE 200,60 MULTILINE OF oDlg PIXEL 

ACTIVATE MsDialog oDlg CENTERED

Return