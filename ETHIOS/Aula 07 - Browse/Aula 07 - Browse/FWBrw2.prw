#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWBROWSE.CH"

/*/{Protheus.doc} U_FWBrw2
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

User Function FWBrw2()
  
Local oBrowse
Local oColumn
Local oDlg
  
// Abertura da tabela
DbSelectArea("SX2")
DbSetOrder(1)
 
//Define a janela do Browse
oDlg = TDialog():New(0, 0, 600, 800,,,,,,,,,,.T.)
 
// Define o Browse
oBrowse := FWBrowse():New(oDlg)
oBrowse:SetDataTable(.T.)
oBrowse:SetAlias("SX2")
 
// Cria uma coluna de marca/desmarca
oColumn := oBrowse:AddMarkColumns({||If(.T./*Funcao de Marca/desmaca*/,'LBOK','LBNO')},{|oBrowse|/*Funcao de DOUBLECLICK*/},{|oBrowse|/* Funcao de HEADERCLICK*/})
 
// Cria uma coluna de status
oColumn := oBrowse:AddStatusColumns({||If(.T./*Funcao de avaliacao de status*/,'BR_VERDE','BR_VERMELHO')},{|oBrowse|/*Função de DOUBLECLICK*/})
 
// Adiciona legenda no Browse
oBrowse:AddLegend('X2_CHAVE $ "AA1|AA2"'    ,"GREEN","Chave teste 1")
oBrowse:AddLegend('!(X2_CHAVE $ "AA1|AA2")' ,"RED"  ,"Chave teste 2")
 
// Adiciona as colunas do Browse
oColumn := FWBrwColumn():New()
oColumn:SetData({||X2_CHAVE})
oColumn:SetTitle("Chave")
oColumn:SetSize(3)
oBrowse:SetColumns({oColumn})
 
oColumn := FWBrwColumn():New()
oColumn:SetData({||X2_ARQUIVO})
oColumn:SetTitle("Arquivo")
oColumn:SetSize(10)
oBrowse:SetColumns({oColumn})
 
oColumn := FWBrwColumn():New()
oColumn:SetData({||X2_NOME})
oColumn:SetTitle(DecodeUTF8("Descricao"))
oColumn:SetSize(40)
oBrowse:SetColumns({oColumn})
 
oColumn := FWBrwColumn():New()
oColumn:SetData({||X2_MODO})
oColumn:SetTitle("Modo")
oColumn:SetSize(1)
oBrowse:SetColumns({oColumn})
 
// Ativação do Browse
oBrowse:Activate()
 
// Ativação da janela
oDlg:Activate(,,,.T.)
 
Return
