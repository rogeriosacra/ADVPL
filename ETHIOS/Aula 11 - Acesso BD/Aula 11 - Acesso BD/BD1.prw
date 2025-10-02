#include 'protheus.ch'
#include 'parmtype.ch'

/*/ {Protheus.doc} User Function BD1
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

User Function BD1()
Local aArea := SB1->(GetArea())
	
	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
    SB1->(DbGoTop())
	
    If SB1->(dbSeek(FWXFilial("SB1")+ "000002"))
		Alert("Achou o produto " + SB1->B1_DESC)
	Else
		Alert("Nao achou o codigo 0000002")
	EndIf
	
	RestArea(aArea)
	
Return
