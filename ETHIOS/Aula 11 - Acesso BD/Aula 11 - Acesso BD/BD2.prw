#include 'protheus.ch'
#include 'parmtype.ch'

/*/ {Protheus.doc} User Function BD2
    (Exemplos de funcoes de Banco de Dados)
    @type		Function
    @author		Milton J.dos Santos
    @since		01/03/2020
    @version	1.0.0
    @param		Nenhum
    @return		Vazio (nil)
    @example    (examples)
    @see		(https://tdn.totvs.com/display/tec/Banco+de+Dados)
/*/

User Function BD2()
Local aArea := SB1->(GetArea())
Local cMsg := ''
	
dbSelectArea("SB1")
SB1->(dbSetOrder(1))
SB1->(dbGoTop())
	
cMsg := Posicione(	'SB1',;
					1,;
					FWXfilial('SB1')+ '000002',;
					'B1_DESC')
						
Alert("Descrição Produto: " +cMsg, "AVISO")
	
RestArea(aArea)

Return