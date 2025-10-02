#INCLUDE "TOTVS.CH"

/*/ {Protheus.doc} User Function SHD
    (Exemplos de funcoes de alerta)
    @type		Function
    @author		Milton J.dos Santos
    @since		01/03/2020
    @version	1.0.0
    @param		Nenhum
    @return		Vazio (nil)
    @example    (examples)
    @see		(https://tdn.totvs.com/display/tec/ShowHelpCpo)
/*/

User Function SHC()		// ShowHelpCpo()
Local aAjuda := {}
Local aValid := {}
 
aAdd( aAjuda, 'Ajuda 01' )
aAdd( aAjuda, 'Ajuda 02' )
aAdd( aAjuda, 'Ajuda 03' )
aAdd( aAjuda, 'Ajuda 04' )
aAdd( aAjuda, 'Ajuda 05' )
 
aAdd( aValid, 'Validação 01' )
aAdd( aValid, 'Validação 02' )
aAdd( aValid, 'Validação 03' )
aAdd( aValid, 'Validação 04' )
aAdd( aValid, 'Validação 05' )
 
ShowHelpCpo( 'Exemplo', aAjuda, , aValid, )
 
// OU
 
ShowHelpCpo( 'Exemplo', { 'Ajuda 01', 'Ajuda 02', 'Ajuda 03' }, , {'Validação 01'}, )
 
//Apresenta a mensagem de ajuda do campo.
//Sintaxe
//ShowHelpCpo ( [ cCabec], [ aAjuda], [ nLinAjuda], [ aValid], [ nLinValid] ) --> Nil

//Parâmetros/Elementos
/*----------*----------*-------------------------------------------------------------------------------*
 | Nome	    | Tipo	   | Descrição	                                                                   |
 *----------+----------+-------------------------------------------------------------------------------*
 | cCabec	| Caracter | Indica o título da janela que será apresentada.		                       |
 | aAjuda	| Vetor	   | Indica o array que contêm o texto com a mensagem de ajuda do campo.		   |
 | nLinAjuda| Numérico | Indica o número de linhas para apresentar a mensagem de ajuda do campo.	   |	
 | aValid	| Vetor	   | Indica o array que contêm o texto com a mensagem das validações do campo.	   |	
 | nLinValid| Nulo	   | Indica o número de linhas para apresentar a mensagem das validações do campo. |
 *----------*----------*-------------------------------------------------------------------------------*/

Return( Nil )
