#Include 'TOTVS.CH'

/*/{Protheus.doc} U_VldMoeda
    @type		Function
    @author		Milton J.dos Santos
    @since		01/03/2020
    @version	1.0.0
    @param		Nenhum
    @return		Vazio (nil)
    @example    Exemplo da utilizacao de VldMoeda
    @see		https://tdn.totvs.com/display/public/PROT/VldMoeda
/*/

/*
	Ponto de entrada executado na ação de confirmação  quando
	é informado a taxa da moeda. Permite ao usuário   validar
	se as taxas informadas são válidaas de acordo com a regra
	já definida.
*/

User Function VldMoeda()
Local aValores	:= ParamIxb[1]
Local cModule	:= ParamIxb[2]
Local lValido	:= .F.

lValido := MsgYesNo("A moeda está certa ?")

Return lValido
