#INCLUDE "TOTVS.CH"
 
/*/ {Protheus.doc} User Function MsgYesNo
    (Exemplos de funcoes de alerta)
    @type		Function
    @author		Milton J.dos Santos
    @since		01/03/2020
    @version	1.0.0
    @param		Nenhum
    @return		Vazio (nil)
    @example    (examples)
    @see		(https://tdn.totvs.com/pages/viewpage.action?pageId=24347000)
/*/

User Function MsgYesNo()
// Pop-Up que mostra um icone de Interrogação e uma mensagem na tela e espera que o usuário 
// decida, por meio dos botões Sim e Não, qual ação será tomada. A opção padrão é o Sim já 
// selecionado apenas para confirmar. Permite o uso de Titulo na tela 

// Sintaxe
// MsgYesNo( <cTexto>, <cTitulo> )

If MsgYesNo( 'Confirma?', 'Exemplo' )
	MsgInfo( 'Sim', 'Exemplo' )
Else
	MsgInfo( 'Nao', 'Exemplo' )
Endif
 
Return( Nil )
 