#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} BANCO001
//TODO Descri��o auto-gerada.
@version undefined

@type function
/*/
user function BANCO001()


	Local aArea := SB1->(GetArea())
	Local cCod:= ""
	Local cDescNova := ""

	cCod := FwInputBox("Informe o codigo do produto", cCod)
	cDescNova := FwInputBox("Informe a nova descri��o", cDescNova)
	
	
	DbSelectArea("SB1")
	SB1->(DbSetOrder(1)) //Posiciona no indice 1
	SB1->(DbGoTop())
	
	// posiciona o produto de c�digo 000002
	If SB1->(dbSeek(FWXFilial("SB1")+ cCod))
	 Alert("Produto localizado! " + SB1->B1_DESC + "A descri��o do produto ser� alterada!", "Aten��o" )
	Else 
	 Alert("Produto "+ SB1->B1_DESC + " n�o localizado!")
	EndIf

	// Iniciar a transa��o.
	Begin Transaction
	
		
		
		If SB1->(DbSeek(FWxFilial('SB1') + cCod))
			RecLock('SB1', .F.) //Trava registro para altera��o
	    	Replace B1_DESC With DescNova	
			SB1->(MsUnlock())
			MsgAlert("Altera��o efetuada!", "Aten��o")
		Else
			MsgAlert("Produto n�o localizado", "Aten��o")
	//	DisarmTransaction()
	End Transaction
	
	RestArea(aArea)
	
return
