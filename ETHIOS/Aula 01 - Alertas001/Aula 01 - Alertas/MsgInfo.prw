#INCLUDE "TOTVS.CH"
 
/*/ {Protheus.doc} User Function MsgInfo
    (Exemplos de funcoes de alerta)
    @type		Function
    @author 	Milton J.dos Santos
    @since		01/03/2020
    @version	1.0.0
    @param		Nenhum
    @return		Vazio (nil)
    @example
    (examples)
    @see (https://tdn.totvs.com/display/tec/MsgInfo)
/*/

User Function MsgInfo()

// Mostra um Pop-Up com um desenho de bal�o com a letra "i" indicando que � um alerta informativo, 
// Sinaliza ao usu�rio acerca de dados importantes sobre um determinado assunto. 
// A fun��o a Inclus�o de um t�tulo 

// Sintaxe
// MsgInfo( <cTexto>, <cTitulo> )

MsgInfo( 'Titulo', 'Mensagem' )
 
Return( Nil )
