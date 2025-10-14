#Include 'TOTVS.CH'

/*/{Protheus.doc} U_MsGet
    @type		Function
    @author		Milton J.dos Santos
    @since		01/03/2020
    @version	1.0.0
    @param		Nenhum
    @return		Vazio (nil)
    @example    Exemplo da utilizacao do comando MsGet
    @see		(https://tdn.totvs.com/pages/)
/*/

User Function MsGet()
Local oDlg,oValTot,oFont
Local nTGerBco :=0

DEFINE MsDialog oDlg TITLE "Exemplo de MsGet" FROM 0,0 TO 400,600 PIXEL 

@ 267, 530 MsGet oValTot VAR nTGerBco SIZE 120, 010 OF oDlg PICTURE "@E 99,999,999,999.99" Font oFont PIXEL

ACTIVATE MsDialog oDlg CENTER 

RETURN

