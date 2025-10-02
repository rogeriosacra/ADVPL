#Include "TOTVS.CH"
#Include "TopConn.ch"
#Include "FWMVCDef.ch"
#Include 'parmtype.ch'

// Define dos modos das rotinas
#DEFINE VISUALIZAR	2
//#DEFINE INCLUIR		3
#DEFINE ALTERAR	 	4
#DEFINE EXCLUIR	  	5
#DEFINE OK	  		1
#DEFINE CANCELA		2
#DEFINE ENTER		Chr(13)+Chr(10)

/*/{Protheus.doc} U_FWMBr1
    @type		Function
    @author		Milton J.dos Santos
    @since		01/03/2020
    @version	1.0.0
    @param		Nenhum
    @return		Vazio (nil)
    @example    Exemplo da utilizacao do FWMBrowse, cria um objeto do tipo grid, botões laterais e detalhes das
				colunas baseado no dicionário de dados
    @see		https://tdn.totvs.com/pages/releaseview.action?pageId=62390842
/*/

User Function FWMBr1()

Local cFiltro	:= ""
Local oDlgMrk 	:= Nil

Private cCadastro	:= "Dados do Cliente"
Private cAlias  	:= "SA1"
//Private aRotina   := MenuDef()
//Private aColumns	:= {}

cFiltro := ""		//	"SA1->A1_MSBLQL <> '1'"

dbSelectArea(cAlias)
(cAlias)->(dbSetOrder(1)) // A1_FILIAL + A1_COD
(cAlias)->(dbGotop())

dbSelectArea(cAlias)
oBrowse := FWMBrowse():New()
oBrowse:SetAlias( cAlias )
oBrowse:SetDescription( cCadastro ) 
oBrowse:SetFilterDefault( cFiltro )  
oBrowse:SetSizeBrowse(100)

// Legendas para o browse
oBrowse:AddLegend('A1_MSBLQL == "1"', 'BR_VERMELHO'	, 'Bloqueado'	)
oBrowse:AddLegend('A1_MSBLQL == "2"', 'BR_VERDE'	, 'Ativo'		)
oBrowse:AddLegend('A1_MSBLQL == " "', 'BR_AMARELO'	, 'Indefinido'	)

cAliasMrk := "SA1"

oMrkBrowse:SetFieldMark("A1_MSBLQL")
oMrkBrowse:SetOwner(oDlgMrk)
oMrkBrowse:SetAlias(cAliasMrk)
oMrkBrowse:SetMenuDef("ATFA012") 
oMrkBrowse:bMark    := {|| AF012Mark(cAlias )}
oMrkBrowse:bAllMark := {|| AF012Inv( cAlias ) }
oMrkBrowse:SetDescription("")
//oMrkBrowse:SetColumns(aColumns)

oBrowse:Activate()

Return

