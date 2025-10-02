#Include 'TOTVS.CH'

/*/{Protheus.doc} U_BUTTON
    @type		Function
    @author		Milton J.dos Santos
    @since		01/03/2020
    @version	1.0.0
    @param		Nenhum
    @return		Vazio (nil)
    @example    Exemplo da utilizacao do comando BUTTON
    @see		https://tdn.totvs.com/pages/
/*/

User Function BUTTON
Local oDlg 

DEFINE MsDialog oDlg TITLE "Exemplo de MsDialog" FROM 0,0 TO 400,600 PIXEL 

@ 122, 060 BUTTON Confirmar PROMPT "Confirmar" SIZE 037, 012 OF oDlg ACTION { U_Msg() } PIXEL

ACTIVATE MsDialog oDlg CENTER 

RETURN

User Function Msg

MsgAlert("Clique no botao confirmar")

RETURN
