#INCLUDE "TOTVS.CH"
 
/*/ {Protheus.doc} User Function MsgStop
    (Exemplos de funcoes de alerta)
    @type		Function
    @author		Milton J.dos Santos
    @since		01/03/2020
    @version	1.0.0
    @param		Nenhum
    @return		Vazio (nil)
    @example    (examples)
    @see		(https://tdn.totvs.com/pages/viewpage.action?pageId=24346998)
/*/

User Function MsgStop()
// Pop-Up que indica uma mensagem de atenção ao usuário, 
// pode ser utilizada para indicar alguma ação errada do usuário 
// que gerou erro, semelhante ao Alert() mas este PERMITE TÍTULO PARA A TELA 

// Sintaxe
// MsgStop( <cTexto>, <cTitulo> )

MsgStop( 'Advertencia', 'Exemplo' )
 
Return( Nil )                  
