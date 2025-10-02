#INCLUDE "TOTVS.CH"

/*/ {Protheus.doc} User Function MsgAlert
    (Exemplos de funcoes de alerta)
    @type  Function
    @author Milton J.dos Santos
    @since 01/03/2020
    @version 1.0.0
    @param Nenhum
    @return Vazio (nil)
    @example
    (examples)
    @see (https://tdn.totvs.com/pages/)
/*/

User Function MsgAlert()
// � um Pop-Up com o icone de Exclama��o, que o objetivo de alertar o usu�rio 
// sobre um ponto de aten��o, sobre algo importante 
// Permite a inclus�o de um t�tulo 

// Sintaxe
// MsgAlert( <cTexto>, <cTitulo> )

// ApMsgAlert - Mensagem de alerta

MsgAlert( 'Alerta', 'Exemplo' )
 
Return( Nil ) 

#Include "Protheus.ch"

User Function TestAlert()
Local cMsg		:= "Alerta que ser� mostrado na caixa de di�logo."
Local cCaption	:= "Teste do ApMsgAlert"

ApMsgAlert(cMsg, cCaption)

Return
