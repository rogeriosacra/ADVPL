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

// Mostra um Pop-Up com um desenho de balão com a letra "i" indicando que é um alerta informativo, 
// Sinaliza ao usuário acerca de dados importantes sobre um determinado assunto. 
// A função a Inclusão de um título 

// Sintaxe
// MsgInfo( <cTexto>, <cTitulo> )

MsgInfo( 'Titulo', 'Mensagem' )
 
Return( Nil )
