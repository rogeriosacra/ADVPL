#include 'protheus.ch'
#include 'parmtype.ch'


/*/{Protheus.doc} BANCO004
//TODO Descri��o auto-gerada.

@since 2018
@version undefined
@type function
/*/
User Function BANCO004()
	
	Local aArea := SB1->(GetArea())
	Local cCod:= ""
	Local cDescNova := ""
	
	cCod := FwInputBox("Informe o codigo do produto", cCod)
	cDescNova := FwInputBox("Informe a nova descri��o", cDescNova)
	
	DbSelectArea('SB1')
	Sb1->(DbSetOrder(1))
	Sb1->(DbGoTop())
	
	// Iniciar a transa��o.
	Begin Transaction
	
		MsgInfo("A descri��o do produto ser� alterada!", "Aten��o")
		
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
