#Include 'protheus.ch'
#Include 'parmtype.ch'
#Include 'TopConn.ch'

/*/ {Protheus.doc} User Function BD3
    (Exemplos de funcoes de Banco de Dados)
    @type		Function
    @author		Milton J.dos Santos
    @since		01/03/2020
    @version	1.0.0
    @param		Nenhum
    @return		Vazio (nil)
    @example    (examples)
    @see		(https://tdn.totvs.com/display/tec/Banco+de+Dados)
/*/

User Function BD3()
	
Local aArea := SB1->(GetArea())
Local cQuery := ""
Local aDados := {}
	
cQuery := " SELECT "
cQuery += " B1_COD AS CODIGO, "
cQuery += " B1_DESC AS DESCRICAO "
cQuery += " FROM "
cQuery += " "+ RetSQLName("SB1")+ " SB1 "
cQuery += " WHERE "
cQuery += " B1_MSBLQL != '1' "

TCQuery cQuery New Alias "TMP"
		
While ! TMP->(EoF())
	AADD(aDados, TMP->CODIGO)
	AADD(aDados, TMP->DESCRICAO)
	TMP->(DbSkip())
EndDo
		
Alert(Len(aDados))
	
For nCount := 1 To Len(aDados)
	MsgInfo(aDados[nCount])
Next nCount
	
TMP->(DbCloseArea())
RestArea(aArea)
	
Return
