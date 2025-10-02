#Include 'TOTVS.CH'

/*/{Protheus.doc} U_CheckBox
    @type		Function
    @author		Milton J.dos Santos
    @since		01/03/2020
    @version	1.0.0
    @param		Nenhum
    @return		Vazio (nil)
    @example    Exemplo da utilizacao de CheckBox 
    @see		https://tdn.engpro.totvs.com.br/display/tec/@+...+CHECKBOX

/*/

User Function CheckBox()
Local oDlg, oChkBox, lCheck := .F.

DEFINE MsDialog oDlg TITLE "Exemplo CheckBox" FROM 100,100 TO 450,400 PIXEL

// Cria o Objeto tCheckBox usando o comando @ .. CHECKBOX
@ 10,10 CHECKBOX oChkBox VAR lCheck PROMPT "Selecione" SIZE 60,15 OF oDlg PIXEL 

ACTIVATE MsDialog oDlg CENTERED

Return
