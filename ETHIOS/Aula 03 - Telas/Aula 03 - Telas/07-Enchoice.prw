#Include 'TOTVS.CH'

/*/{Protheus.doc} U_Ench2
    @type		Function
    @author		Milton J.dos Santos
    @since		01/03/2020
    @version	1.0.0
    @param		Nenhum
    @return		Vazio (nil)
    @example    Exemplo da utilizacao do comando Enchoice  (uma tela com vários campos conforme cadastro na SX3)
    @see		(https://tdn.totvs.com/pages/)
/*/

User Function Ench2
Local cAlias
Local nReg := 1
Local nOpc := 1
Local aPos
Local aAlterEnch
Local nModelo

Private aCpoEnch := {"A1_COD","A1_NOME"}

Enchoice(cAlias, nReg, nOpc, /*aCRA*/, /*cLetra*/, /*cTexto*/, aCpoEnch, aPos, aAlterEnch,nModelo,/*nColMens*/,/* cMensagem*/,/* cTudoOk*/, oDlg, lF3,lMemoria, lColumn, caTela, lNoFolder, lProperty)

Return
