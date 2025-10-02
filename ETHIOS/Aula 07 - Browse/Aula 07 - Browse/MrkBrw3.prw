#INCLUDE "TOTVS.CH"
#INCLUDE "FWMVCDEF.CH"

/*/{Protheus.doc} MrkBrw3
    @type		Function
    @author		Milton J.dos Santos
    @since		01/03/2020
    @version	1.0.0
    @param		Nenhum
    @return		Vazio (nil)
    @example    Exemplo da utilizacao de FWMrkBrw
    @see		https://tdn.totvs.com/display/public/framework/MarkBrow
/*/

User Function MrkBrw3()
Private oBrowse
	
Private aRotina	:= MenuDef()

	oBrowse := FWMarkBrowse():New()
	oBrowse:SetAlias("GXI")							// Alias da tabela utilizada
	oBrowse:SetMenuDef("GFEA116")					// Nome do fonte onde esta a função MenuDef
	oBrowse:SetFieldMark("GXI_MARKBR")
	oBrowse:SetDescription("Recebimento de Fatura de Frete")      	// Descrição do browse      //"Recebimento de Fatura de Frete"
	oBrowse:SetAllMark({|| GFEA116MARK()})
	
	oBrowse:AddLegend("GXI_EDISIT == '1'", "BLUE"  , "Importado" ) //Legenda do Browser //"Importado"
	oBrowse:AddLegend("GXI_EDISIT == '2'", "YELLOW", "Importado com erro") //"Criado"
	oBrowse:AddLegend("GXI_EDISIT == '3'", "RED"   , "Rejeitado" ) //"Rejeitado"
	oBrowse:AddLegend("GXI_EDISIT == '4'", "GREEN" , "Processado")
	
	oBrowse:Activate()                                       

Return(Nil)

//-------------------------------------------------------
//	MenuDef
//-------------------------------------------------------
Static Function MenuDef()
Local aRotina := {}
	ADD OPTION aRotina TITLE "Pesquisar"        ACTION "AxPesqui"        OPERATION 1 ACCESS 0 	// "Pesquisar"
	ADD OPTION aRotina TITLE "Visualizar"       ACTION "VIEWDEF.GFEA116" OPERATION 2 ACCESS 0 	// "Visualizar"
	ADD OPTION aRotina TITLE "Importar"         ACTION "GFEA116IMP()"    OPERATION 3 ACCESS 0 	// "Importar"
	ADD OPTION aRotina TITLE "Alterar"          ACTION "VIEWDEF.GFEA116" OPERATION 4 ACCESS 0   // "Alterar"
	ADD OPTION aRotina TITLE "Processar"        ACTION "GFEA116PRO()"    OPERATION 6 ACCESS 0   // "Processar"
	ADD OPTION aRotina TITLE "Excluir Sel."     ACTION "GFEA116EXC()" 	 OPERATION 5 ACCESS 0   // "Excluir Todos"
	ADD OPTION aRotina TITLE "Selecionar Todos" ACTION "GFEA116MKT()"    OPERATION 5 ACCESS 0   // "Selecionar Todos"
	ADD OPTION aRotina TITLE "Imprimir"         ACTION "VIEWDEF.GFEA116" OPERATION 8 ACCESS 0 	// "Imprimir"
Return aRotina

