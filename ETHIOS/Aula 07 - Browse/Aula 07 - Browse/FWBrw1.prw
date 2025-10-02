#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWBROWSE.CH"

/*/{Protheus.doc} U_FWBrw1
    @type		Function
    @author		Milton J.dos Santos
    @since		01/03/2020
    @version	1.0.0
    @param		Nenhum
    @return		Vazio (nil)
    @example    Exemplo da utilizacao do FWBrowse
				colunas baseado no dicionário de dados
    @see		https://tdn.totvs.com/display/public/PROT/FwBrowse
/*/

User Function FWBrw1()
 
Local oBrowse
Local oColumn
Local oDlg
 
//---------------------------------------------------// Abertura da tabela//-------------------------------------------------------------------
DbSelectArea("SX2")
DbSetOrder(1)
 
//--------------------------------------------------------// Define a janela do Browse//-------------------------------------------------------
DEFINE DIALOG oDlg FROM 0,0 TO 600,800 PIXEL
 
//------------------------------------------------------- // Define o Browse //----------------------------------------------------------------
DEFINE FWBROWSE oBrowse DATA TABLE ALIAS "SX2" OF oDlg
 
//-------------------------------------------------------- // Cria uma coluna de marca/desmarca//----------------------------------------------
ADD MARKCOLUMN oColumn DATA { || If(.T./* Funcao com a regra*/,'LBOK','LBNO') };
DOUBLECLICK { |oBrowse| MsgAlert("/*Funcao que atualiza a regra*/") };
HEADERCLICK { |oBrowse| MsgAlert("/*Funcao executada no clique do header */") } OF oBrowse

//aBrowse[oBrowse:nAt,01],oOK,oNO)
 
//---------------------------------------------------- // Cria uma coluna de status //--------------------------------------------------------
ADD STATUSCOLUMN oColumn DATA { || If(.T./* Funcao com a regra */,'BR_VERDE','BR_VERMELHO') };
DOUBLECLICK { |oBrowse| Msg("/*Funcao executada no duplo clique na coluna*/")} OF oBrowse
 
//--------------------------------------------------- // Adiciona legenda no Browse //--------------------------------------------------------
ADD LEGEND DATA 'X2_CHAVE $ "AA1|AA2"'      COLOR "GREEN"   TITLE "Chave teste 1" OF oBrowse
ADD LEGEND DATA '!(X2_CHAVE $ "AA1|AA2")'   COLOR "RED"     TITLE "Chave teste 2" OF oBrowse
 
//------------------------------------------------------------- // Adiciona as colunas do Browse //------------------------------------------
ADD COLUMN oColumn DATA { || X2_CHAVE   } TITLE "Chave" SIZE 3 OF oBrowse
ADD COLUMN oColumn DATA { || X2_ARQUIVO } TITLE "Arquivo" SIZE 10 OF oBrowse
ADD COLUMN oColumn DATA { || X2_NOME    } TITLE DecodeUTF8("Descricao") SIZE 40 OF oBrowse
ADD COLUMN oColumn DATA { || X2_MODO    } TITLE "Modo" SIZE 1 OF oBrowse
 
//--------------------------------------------------- // Ativacao do Browse//----------------------------------------------------------------
ACTIVATE FWBROWSE oBrowse
 
//-------------------------------------------------// Ativacao do janela//-------------------------------------------------------------------
ACTIVATE DIALOG oDlg CENTERED
 
Return
