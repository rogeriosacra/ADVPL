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
 
aAdd( aValid, 'Valida��o 01' )
aAdd( aValid, 'Valida��o 02' )
aAdd( aValid, 'Valida��o 03' )
aAdd( aValid, 'Valida��o 04' )
aAdd( aValid, 'Valida��o 05' )
 
ShowHelpCpo( 'Exemplo', aAjuda, , aValid, )
 
// OU
 
ShowHelpCpo( 'Exemplo', { 'Ajuda 01', 'Ajuda 02', 'Ajuda 03' }, , {'Valida��o 01'}, )
 
//Apresenta a mensagem de ajuda do campo.
//Sintaxe
//ShowHelpCpo ( [ cCabec], [ aAjuda], [ nLinAjuda], [ aValid], [ nLinValid] ) --> Nil

//Par�metros/Elementos
/*----------*----------*-------------------------------------------------------------------------------*
 | Nome	    | Tipo	   | Descri��o	                                                                   |
 *----------+----------+-------------------------------------------------------------------------------*
 | cCabec	| Caracter | Indica o t�tulo da janela que ser� apresentada.		                       |
 | aAjuda	| Vetor	   | Indica o array que cont�m o texto com a mensagem de ajuda do campo.		   |
 | nLinAjuda| Num�rico | Indica o n�mero de linhas para apresentar a mensagem de ajuda do campo.	   |	
 | aValid	| Vetor	   | Indica o array que cont�m o texto com a mensagem das valida��es do campo.	   |	
 | nLinValid| Nulo	   | Indica o n�mero de linhas para apresentar a mensagem das valida��es do campo. |
 *----------*----------*-------------------------------------------------------------------------------*/

Return( Nil )
