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
    @see		(https://tdn.totvs.com/display/tec/ShowHelpDlg)
/*/

User Function SHD
Local aProblema	:= {}
Local aSolucao	:= {}
 
aAdd( aProblema, 'Problema 01' )
aAdd( aProblema, 'Problema 02' )
aAdd( aProblema, 'Problema 03' )
aAdd( aProblema, 'Problema 04' )
aAdd( aProblema, 'Problema 05' )
 
aAdd( aSolucao, 'Solu��o 01' )
aAdd( aSolucao, 'Solu��o 02' )
aAdd( aSolucao, 'Solu��o 03' )
aAdd( aSolucao, 'Solu��o 04' )
aAdd( aSolucao, 'Solu��o 05' )
 
ShowHelpDlg( 'Exemplo', aProblema, , aSolucao, )
 
//OU
 
ShowHelpDlg( 'Exemplo', { 'Problema 01', 'Problema 02', 'Problema 03' }, , {'Solu��o 01'}, )


//Apresenta a mensagem de ajuda do sistema.
//Sintaxe
//ShowHelpDlg ( [ cCabec], [ aProbl], [ nLinProbl], [ aSolucao], [ nLinSoluc] ) --> Nil

//Par�metros/Elementos
/*----------*----------*-------------------------------------------------------------------------------*
 | Nome	    | Tipo	   | Descri��o                                                                     |
 *----------+----------+-------------------------------------------------------------------------------*
 | cCabec	| Caracter | Indica o t�tulo da janela que ser� apresentada.		                       |
 | aProbl	| Vetor	   | Indica o array que cont�m o texto com a mensagem de problema.	               |	
 | nLinProbl| Num�rico | Indica o n�mero de linhas para apresentar a mensagem de problema.             | 
 |          |          | Observa��o: O n�mero m�ximo permitido s�o 5 linhas.		                   |
 | aSolucao	| Vetor	   | Indica o array que cont�m o texto com a mensagem de solu��o.	               |	
 | nLinSoluc| Nulo	   | Indica o n�mero de linhas para apresentar a mensagem de solu��o.              |
 |          |          | Observa��o: O n�mero m�ximo permitido s�o 5 linhas.		                   |
 *----------*----------*-------------------------------------------------------------------------------*/

 
Return( Nil )
