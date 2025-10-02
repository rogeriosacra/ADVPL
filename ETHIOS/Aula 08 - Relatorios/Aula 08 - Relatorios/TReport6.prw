#include "protheus.ch"
#include "report.ch"
 
/*/ {Protheus.doc} TReport6

	Impressão de relatório

    (Exemplos de funcoes de relatorio TREPORT)
	
    @type		Function
    @author		Milton J.dos Santos
    @since		01/03/2020
    @version	1.0.0
    @param		Nenhum
    @return		Vazio (nil)
    @example    (Examplos)
    @see (https://tdn.totvs.com/pages/)
	
/*/
User Function TReport6()
Local oReport
Local oSA1
Local oSC5
Local oSC6
 
Pergunte("REPORT",.F.)
 
DEFINE REPORT oReport NAME "TReport2" TITLE "Pedidos de Venda" PARAMETER "REPORT" ACTION {|oReport| PrintReport(oReport)}
 
    DEFINE SECTION oSA1 OF oReport TITLE "Cliente" TABLES "SA1" //TOTAL IN COLUMN //PAGE HEADER
    oSA1:SetPageBreak()
 
        DEFINE CELL NAME "A1_COD" OF oSA1 ALIAS "SA1"
        DEFINE CELL NAME "A1_NOME" OF oSA1 ALIAS "SA1"
        DEFINE CELL NAME "A1_VEND" OF oSA1 ALIAS "SA1"
        DEFINE CELL NAME "A1_MCOMPRA" OF oSA1 ALIAS "SA1"
 
    DEFINE SECTION oSC5 OF oSA1 TITLE "Pedido" TABLE "SC5" //PAGE HEADER
 
        DEFINE CELL NAME "NUM" OF oSC5 TITLE "Pedido" SIZE 10
        DEFINE CELL NAME "C5_NUM" OF oSC5 ALIAS "SC5"
        DEFINE CELL NAME "C5_TIPO" OF oSC5 ALIAS "SC5"
        DEFINE CELL NAME "C5_VEND1" OF oSC5 ALIAS "SC5"
         
        // Conta quantos pedidos foram feitos para este cliente
        DEFINE FUNCTION FROM oSC5:Cell("C5_NUM") OF oSA1 FUNCTION COUNT TITLE "Pedidos"
 
 
        DEFINE SECTION oSC6 OF oSC5 TITLE "Itens" TABLE "SC6","SB1" TOTAL TEXT "Valor total do pedido" TOTAL IN COLUMN //PAGE HEADER
 
            DEFINE CELL NAME "C6_ITEM" OF oSC6 ALIAS "SC6"
            DEFINE CELL NAME "C6_PRODUTO" OF oSC6 ALIAS "SC6"
            DEFINE CELL NAME "B1_DESC" OF oSC6 ALIAS "SB1"
            DEFINE CELL NAME "B1_GRUPO" OF oSC6 ALIAS "SB1"
            DEFINE CELL NAME "C6_UM" OF oSC6 ALIAS "SC6"
            DEFINE CELL NAME "C6_QTDVEN" OF oSC6 ALIAS "SC6"
            DEFINE CELL NAME "C6_PRCVEN" OF oSC6 ALIAS "SC6"
            DEFINE CELL NAME "C6_VALOR" OF oSC6 ALIAS "SC6"
             
            // Conta quantidade de itens dos pedidos e imprime somente no final da pagina
            DEFINE FUNCTION FROM oSC6:Cell("C6_ITEM") FUNCTION COUNT END PAGE
            // Faz a somatoria do pedido
            DEFINE FUNCTION FROM oSC6:Cell("C6_VALOR") FUNCTION SUM
            // Guarda o maior valor entre os itens de pedido, imprime no final da seção e depois no final do relatório
            DEFINE FUNCTION FROM oSC6:Cell("C6_VALOR") FUNCTION MAX TITLE "Maior Valor"
            // Guarda o menor valor entre os itens de pedido mas não imprime no final da seção mas imprime no final do relatório
            DEFINE FUNCTION FROM oSC6:Cell("C6_VALOR") FUNCTION MIN NO END SECTION TITLE "Menor Valor"
            // Guarda a média entre os itens de pedido não imprime no final da seção mas imprime no final do relatório
            DEFINE FUNCTION FROM oSC6:Cell("C6_VALOR") FUNCTION AVERAGE NO END SECTION TITLE "Valor Médio"
 
oReport:PrintDialog()
Return
 
Static Function PrintReport(oReport)
#IFDEF TOP
    Local cAlias := GetNextAlias()
 
    MakeSqlExp("REPORT")
     
    BEGIN REPORT QUERY oReport:Section(1)
     
    BeginSql alias cAlias
        SELECT A1_COD,A1_NOME,A1_VEND,A1_MCOMPRA,
            C5_NUM NUM,C5_NUM,C5_TIPO,C5_VEND1,C5_CLIENTE,
            C6_ITEM,C6_PRODUTO,C6_UM,C6_QTDVEN,C6_PRCVEN,C6_VALOR,C6_NUM,
            B1_DESC,B1_GRUPO
         
        FROM %table:SA1% SA1, %table:SC5% SC5, %table:SC6% SC6, %table:SB1% SB1
         
        WHERE A1_FILIAL = %xfilial:SA1% AND SA1.%notDel% AND
            C5_FILIAL = %xfilial:SC5% AND SC5.%notDel% AND C5_CLIENTE = A1_COD AND
            C6_FILIAL = %xfilial:SC6% AND SC6.%notDel% AND C6_NUM = C5_NUM AND
            B1_FILIAL = %xfilial:SB1% AND SB1.%notDel% AND B1_COD = C6_PRODUTO
         
        ORDER BY A1_FILIAL,A1_COD,
            C5_FILIAL,C5_NUM,
            C6_FILIAL,C6_ITEM
    EndSql
     
    END REPORT QUERY oReport:Section(1) PARAM mv_par01
     
    oReport:Section(1):Section(1):SetParentQuery()
    oReport:Section(1):Section(1):SetParentFilter({|cParam| (cAlias)->C5_CLIENTE == cParam},{|| (cAlias)->A1_COD})
     
    oReport:Section(1):Section(1):Section(1):SetParentQuery()
    oReport:Section(1):Section(1):Section(1):SetParentFilter({|cParam| (cAlias)->C6_NUM == cParam},{|| (cAlias)->C5_NUM})
 
    oReport:Section(1):Print()
#ENDIF
Return