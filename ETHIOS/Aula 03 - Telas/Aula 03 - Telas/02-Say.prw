#Include 'TOTVS.CH'

/*/{Protheus.doc} U_Say
    @type		Function
    @author		Milton J.dos Santos
    @since		01/03/2020
    @version	1.0.0
    @param		Nenhum
    @return		Vazio (nil)
    @example    Exemplo da utilizacao do SAY 
    @see		https://tdn.engpro.totvs.com.br/display/tec/@+...+SAY
/*/

User Function Say()
Local oDlg, oFont, oSay

DEFINE MsDialog oDlg TITLE "Exemplo do Say" FROM 180,180 TO 550,700 PIXEL

// Cria Fonte para visualização
oFont := TFont():New('Courier new',,-18,.T.)

// Cria o Objeto tSay usando o comando @ .. SAY 
@ 10,10 SAY oSay PROMPT 'Texto para exibicao' SIZE 200,20 COLORS CLR_RED,CLR_WHITE FONT oFont OF oDlg PIXEL 

ACTIVATE MsDialog oDlg CENTERED

Return
