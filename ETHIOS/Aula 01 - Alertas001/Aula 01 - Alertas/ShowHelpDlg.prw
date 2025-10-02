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
 
aAdd( aSolucao, 'Solução 01' )
aAdd( aSolucao, 'Solução 02' )
aAdd( aSolucao, 'Solução 03' )
aAdd( aSolucao, 'Solução 04' )
aAdd( aSolucao, 'Solução 05' )
 
ShowHelpDlg( 'Exemplo', aProblema, , aSolucao, )
 
//OU
 
ShowHelpDlg( 'Exemplo', { 'Problema 01', 'Problema 02', 'Problema 03' }, , {'Solução 01'}, )


//Apresenta a mensagem de ajuda do sistema.
//Sintaxe
//ShowHelpDlg ( [ cCabec], [ aProbl], [ nLinProbl], [ aSolucao], [ nLinSoluc] ) --> Nil

//Parâmetros/Elementos
/*----------*----------*-------------------------------------------------------------------------------*
 | Nome	    | Tipo	   | Descrição                                                                     |
 *----------+----------+-------------------------------------------------------------------------------*
 | cCabec	| Caracter | Indica o título da janela que será apresentada.		                       |
 | aProbl	| Vetor	   | Indica o array que contêm o texto com a mensagem de problema.	               |	
 | nLinProbl| Numérico | Indica o número de linhas para apresentar a mensagem de problema.             | 
 |          |          | Observação: O número máximo permitido são 5 linhas.		                   |
 | aSolucao	| Vetor	   | Indica o array que contêm o texto com a mensagem de solução.	               |	
 | nLinSoluc| Nulo	   | Indica o número de linhas para apresentar a mensagem de solução.              |
 |          |          | Observação: O número máximo permitido são 5 linhas.		                   |
 *----------*----------*-------------------------------------------------------------------------------*/

 
Return( Nil )
