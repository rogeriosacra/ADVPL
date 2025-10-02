#Include "TOTVS.CH"

/*/{Protheus.doc} U_Legend
    @type		Function
    @author		Milton J.dos Santos
    @since		01/03/2020
    @version	1.0.0
    @param		Nenhum
    @return		Vazio (nil)
    @example    Exemplo da utilizacao de FWLegend
    @see		https://tdn.totvs.com/display/public/PROT/FWLegend
/*/

User Function Legend()
Local oLegenda as Object
 
oLegenda := FWLegend():New()
 
oLegenda:Add("", "BR_VERDE"		, "Verde"	)
oLegenda:Add("", "BR_AZUL"		, "Azul"	)
oLegenda:Add("", "BR_VERMELHO"	, "Vermelho")
oLegenda:Add("", "BR_AMARELO"	, "Amarelo"	)
oLegenda:Add("", "BR_BRANCO"	, "Branco"	)
oLegenda:Add("", "BR_CINZA"		, "Cinza"	)
oLegenda:Add("", "BR_LARANJA"	, "Laranja"	)
oLegenda:Add("", "BR_MARROM"	, "Marrom"	)

oLegenda:Activate()
oLegenda:View()
 
oLegenda:Deactivate()
 
oLegenda:SetNumber(.T.)
 
oLegenda:Activate()
oLegenda:View()
 
oLegenda:Deactivate()
 
FreeObj(oLegenda)
 
Return( .T. )

/*
	Abaixo a lista das cores suportadas:
    =====================================
    "RED"     ou "BR_VERMELHO"
    "GREEN"   ou "BR_VERDE"
    "YELLOW"  ou "BR_AMARELO"
    "BLUE"    ou "BR_AZUL"
    "WHITE"   ou "BR_BRANCO"
    "GRAY"    ou "BR_CINZA"
    "ORANGE"  ou "BR_LARANJA"
    "BROWN"   ou "BR_MARROM"
    "PINK"    ou "BR_PINK"
    "BLACK"   ou "BR_PRETO"
    "VIOLET"  ou "BR_VIOLETA"
    "HGREEN"  ou "BR_VERDE_ESCURO"
    "LBLUE"   ou "BR_AZUL_CLARO"
    "DISABLE" ou "BR_VERMELHO"
    "ENABLE"  ou "BR_VERDE"
*/ 
