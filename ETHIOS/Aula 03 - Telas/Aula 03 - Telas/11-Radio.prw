#Include 'TOTVS.CH'

/*/{Protheus.doc} U_Radio
    @type		Function
    @author		Milton J.dos Santos
    @since		01/03/2020
    @version	1.0.0
    @param		Nenhum
    @return		Vazio (nil)
    @example    Exemplo da utilizacao do comando Radio (janela/formulario)
    @see		(https://tdn.totvs.com/pages/)
/*/

User Function Radio
Local oDlg, oRadio
Local nRadio	:= 1

DEFINE MsDialog oDlg TITLE "Exemplo de Radio" FROM 0,0 TO 400,600 PIXEL 

@ 08,10 RADIO oRadio VAR nRadio ITEMS 'Item x', 'Item 2','Item 3', 'Item 4'  OF oDlg ON CHANGE { || Alert( 'Mudando de Opcao' ) } SIZE 110,10 PIXEL

ACTIVATE MsDialog oDlg CENTER 

RETURN

