#Include 'TOTVS.CH'
#Include 'FWMVCDef.ch'

/*/{Protheus.doc} U_MrkBrw1
    @type		Function
    @author		Milton J.dos Santos
    @since		01/03/2020
    @version	1.0.0
    @param		Nenhum
    @return		Vazio (nil)
    @example    Exemplo da utilizacao de MarkBrow
    @see		https://tdn.totvs.com/display/public/framework/MarkBrow
/*/
/*
    O componente visual MarkBrow permite que os elementos de um browser sejam marcados ou desmarcados.

    Exemplos de tabelas que tem o campo OK para testar essa rotina
        SA2 - A2_OK
        SA6 - A6_OK
        SB1 - B1_OK
        SB7 - B7_OK
        SC9 - C9_OK
        SF1 - F1_OK
        SD1 - D1_OK
        SF2 - F2_OK
        SD2 - D2_OK
        SE1 - E1_OK
        SE2 - E2_OK
*/

User Function MrkBrw1()

Private aRotina := MenuDef()

MarkBrow("SE1","E1_OK",,,.T.,GetMark())

Return

Static Function MenuDef()
Local aRotina := {}

//ADD OPTION aRotina TITLE "Pesquisar"        ACTION 'PesqBrw'    OPERATION 1 ACCESS 0 
//ADD OPTION aRotina Title 'Visualizar'       Action 'AxVisual'   OPERATION 2 ACCESS 0
//ADD OPTION aRotina Title 'Incluir'          Action 'AxInclui'   OPERATION 3 ACCESS 0
//ADD OPTION aRotina Title 'Alterar'          Action 'AxAltera'   OPERATION 4 ACCESS 0
//ADD OPTION aRotina Title 'Excluir'          Action 'AxDeleta'   OPERATION 5 ACCESS 0
ADD OPTION aRotina Title 'Rotina Browser'   Action 'U_Posic()'  OPERATION 2 ACCESS 0


Return aRotina

User Function Posic()

oObjMBrw:= GetMarkBrow()
oObjMBrw:oBrowse:GoTop()
oObjMBrw:oBrowse:Refresh()

Return
