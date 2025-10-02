#Include 'TOTVS.CH'

/*/{Protheus.doc} U_MsDialog
    @type		Function
    @author		Milton J.dos Santos
    @since		01/03/2020
    @version	1.0.0
    @param		Nenhum
    @return		Vazio (nil)
    @example    Exemplo da utilizacao do comando MsDialog (janela/formulario)
    @see		(https://tdn.totvs.com/pages/)
/*/

User Function MsDialog
Local oDlg 

// Sintaxe
// DEFINE MsDialog oObjetoDLG TITLE cTitulo FROM nLinIni,nColIni TO nLinFim,nColFim PIXEL

DEFINE MsDialog oDlg TITLE "Exemplo de MsDialog" FROM 0,0 TO 400,600 PIXEL 
oDlg:lEscClose  := .T.
oDlg:lMaximized := .T.
oDlg:lCentered  := .T.

ACTIVATE MsDialog oDlg CENTER 

RETURN

