#Include 'TOTVS.CH'

/*/{Protheus.doc} U_BUTTON
    @type		Function
    @author		Milton J.dos Santos
    @since		01/03/2020
    @version	1.0.0
    @param		Nenhum
    @return		Vazio (nil)
    @example    Exemplo da utilizacao do comando BUTTON
    @see		https://tdn.totvs.com/pages/releaseview.action?pageId=6814974
/*/

/*
    Este exemplo verifica permissoes de acesso do  usuario e por isso deve ser executado via SIGAMDI
*/

User Function EnchBar()
Local aButtons := {}
Local oDlg
Local oBtn
Local lOk

DEFINE MSDIALOG oDlg TITLE "Exemplo de EnchoiceBar" FROM 000,000 TO 400,600 PIXEL 	

Aadd( aButtons, {"HISTORIC", {|| TestHist()}, "Historico...", "Historico" , {|| .T.}} )     		

@ -15,-15 BUTTON oBtn PROMPT "..." SIZE 1,1 PIXEL OF oDlg           

ACTIVATE MSDIALOG oDlg ON INIT (EnchoiceBar(oDlg,{||lOk:=.T.,oDlg:End()},{||oDlg:End()},,@aButtons))

Return 

Static Function TestHist()	
ApMsgInfo("Mostra historico")
Return

