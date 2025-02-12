#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} BANCO001
//TODO Descrição auto-gerada.
@version undefined

@type function
/*/
user function BANCO001()


	Local aArea := SB1->(GetArea())
	Local cCod:= ""
	Local cDescNova := ""

	cCod := FwInputBox("Informe o codigo do produto", cCod)
	cDescNova := FwInputBox("Informe a nova descrição", cDescNova)
	
	
	DbSelectArea("SB1")
	SB1->(DbSetOrder(1)) //Posiciona no indice 1
	SB1->(DbGoTop())
	
	// posiciona o produto de código 000002
	If SB1->(dbSeek(FWXFilial("SB1")+ cCod))
	 Alert("Produto localizado! " + SB1->B1_DESC + "A descrição do produto será alterada!", "Atenção" )
	Else 
	 Alert("Produto "+ SB1->B1_DESC + " não localizado!")
	EndIf

	// Iniciar a transação.
	Begin Transaction
	
		
		
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
