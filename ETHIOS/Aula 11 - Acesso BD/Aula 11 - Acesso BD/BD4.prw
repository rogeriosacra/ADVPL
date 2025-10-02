#include 'protheus.ch'
#include 'parmtype.ch'

/*/ {Protheus.doc} User Function BD4
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

User Function BD4()
Local aArea := SB1->(GetArea())
	
	DbSelectArea('SB1')
	Sb1->(DbSetOrder(1))
	Sb1->(DbGoTop())

	Begin Transaction
	
		MsgInfo("A descrição do produto será alterada!", "Atenção")
		
	If SB1->(DbSeek(FWxFilial('SB1') + '000002'))
		RecLock('SB1', .F.) //Trava registro para alteração
	Replace B1_DESC With "MONITOR DELL 42 PL"
	
		SB1->(MsUnlock())
	EndIf
		MsgAlert("Alteração efetuada!", "Atenção")

	End Transaction
	RestArea(aArea)
	
Return
