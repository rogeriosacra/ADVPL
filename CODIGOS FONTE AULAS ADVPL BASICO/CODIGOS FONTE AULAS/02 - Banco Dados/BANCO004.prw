#include 'protheus.ch'
#include 'parmtype.ch'


/*/{Protheus.doc} BANCO004
//TODO Descrição auto-gerada.

@since 2018
@version undefined
@type function
/*/
User Function BANCO004()
	
	Local aArea := SB1->(GetArea())
	Local cCod:= ""
	Local cDescNova := ""
	
	cCod := FwInputBox("Informe o codigo do produto", cCod)
	cDescNova := FwInputBox("Informe a nova descrição", cDescNova)
	
	DbSelectArea('SB1')
	Sb1->(DbSetOrder(1))
	Sb1->(DbGoTop())
	
	// Iniciar a transação.
	Begin Transaction
	
		MsgInfo("A descrição do produto será alterada!", "Atenção")
		
		If SB1->(DbSeek(FWxFilial('SB1') + cCod))
			RecLock('SB1', .F.) //Trava registro para alteração
	    	Replace B1_DESC With DescNova	
			SB1->(MsUnlock())
			MsgAlert("Alteração efetuada!", "Atenção")
		Else
			MsgAlert("Produto não localizado", "Atenção")
	//	DisarmTransaction()
	End Transaction
	RestArea(aArea)
	
return
