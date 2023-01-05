#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} BANCO002
//TODO Descrição auto-gerada.
@author RCTI TREINAMENTOS
@since 2018
@version undefined

@type function
/*/
user function BANCO002()
	Local aArea := SB1->(GetArea())
	Local cMsg := ''
	Local cCodpro := ''
	
	cCodPro:= FwInputBox("Informe o código do produto para pesquisa: ", "")
	
	dbSelectArea("SB1")
	SB1->(dbSetOrder(1))
	SB1->(dbGoTop())
	
	cMsg := Posicione(	'SB1',;
						1,;
						FWXfilial('SB1')+ cCodpro,;
						'B1_DESC')

	If cMsg <> ''					
	    MsgInfo("Descrição Produto: " + cCodPro + "->"+cMsg)
	Else
	    Alert("Descrição Produto: " + cCodPro + " -> Produto não Localizado")
	EndIf
	
	RestArea(aArea)
return
