#INCLUDE 'Protheus.ch'
#INCLUDE 'Parmtype.ch'


User Function Banco001()

Local aArea := SB1->(GetArea())

cCodPro:= FwInputBox("Informe o c�digo do produto", "")

DbSelectArea('SB1')
SB1->(DbSetOrder(1))
SB1->(DbGoTop())

If SB1->(DbSeek(FWXFilial("SB1")+ CValToChar(cCodPro)))
    MsgInfo("Descri��o do produto:  " + SB1->B1_DESC)
Else
    Alert("Produto n�o localizado")
EndIf    

RestArea(aArea)
    
Return
