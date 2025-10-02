#INCLUDE "TOTVS.CH"
 
/*/ {Protheus.doc} User Function Aviso
    (Exemplos de funcoes de alerta)
    @type  Function
    @author Milton J.dos Santos
    @since 01/03/2020
    @version 1.0.0
    @param Nenhum
    @return Vazio (nil)
    @example
    (examples)
    @see (https://tdn.totvs.com/pages/viewpage.action?pageId=23889130)
/*/

User Function Aviso()
Local nOpc	:= 0
 
// Sintaxe
// Aviso( <cTitulo>, <cTexto>, <aBot�es>, <nTamanho> )   

nOpc := Aviso( "Exemplo", 'Mensagem', { "Sim", "N�o", "Sim - Todos", "N�o - Todos" }, 3, "Titulo da Descri��o",, 'ENGRENAGEM', .F., 5000 )
 
If nOpc == 1
	MsgInfo( 'Sim', 'Exemplo' )
ElseIf nOpc == 2
	MsgInfo( 'N�o', 'Exemplo' )
ElseIf nOpc == 3
	MsgInfo( 'Sim - Todos', 'Exemplo' )
ElseIf nOpc == 4
	MsgInfo( 'N�o - Todos', 'Exemplo' )
Endif
 
Return( Nil )
