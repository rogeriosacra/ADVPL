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
// É um Pop-Up com o icone de Exclamação, que o objetivo de alertar o usuário 
// sobre um ponto de atenção, sobre algo importante 
// Permite a inclusão de um título 

// Sintaxe
// MsgAlert( <cTexto>, <cTitulo> )

// ApMsgAlert - Mensagem de alerta

MsgAlert( 'Alerta', 'Exemplo' )
 
Return( Nil ) 

#Include "Protheus.ch"

User Function TestAlert()
Local cMsg		:= "Alerta que será mostrado na caixa de diálogo."
Local cCaption	:= "Teste do ApMsgAlert"

ApMsgAlert(cMsg, cCaption)

Return
