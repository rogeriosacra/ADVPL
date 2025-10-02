#Include 'TOTVS.CH'

/*/{Protheus.doc} U_PERGUNTE
    @type		Function
    @author		Milton J.dos Santos
    @since		01/03/2020
    @version	1.0.0
    @param		Nenhum
    @return		Vazio (nil)
    @example    Exemplo da utilizacao do comando PERGUNTE
    @see		https://tdn.totvs.com/pages/releaseview.action?pageId=6814979
/*/


User Function Pergunte()     

Pergunte("MATR030", .T.) 

If MV_PAR01 == 1
	ApMsgInfo("Opção escolhida foi a 1")
Else    
	ApMsgInfo("Opção escolhida foi a 2")
EndIf

Return 

