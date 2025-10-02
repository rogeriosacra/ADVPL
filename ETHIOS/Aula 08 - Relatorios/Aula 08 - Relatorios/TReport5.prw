#Include "TOTVS.ch"
#Include "Report.Ch"

/*/ {Protheus.doc} TReport4

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

User Function TReport4()
	Local oReport

	oReport := DefCell()
	oReport:PrintDialog()
Return

Static Function DefCell()
	Local cPerg := "INFOR2"
	Local cTitulo := "TITULO A PAGAR"
	Local aOrd := {}
	                
	Local oDados1
	Local oDados2
	Local oReport

	aAdd( aOrd, "Fornecedor"   )
	aAdd( aOrd, "Titulo"       )
	aAdd( aOrd, "Emissão"      )
	aAdd( aOrd, "Vencimento"   )
	aAdd( aOrd, "Vencto. Real" )
	
	CriaSX1( cPerg )
	Pergunte( cPerg, .F. )

	oReport := TReport():New("TREPORT_SIMPLES",cTitulo,cPerg,;
	{|oReport| DefPrint( oReport, aOrd, cTitulo )},"Este relatório irá imprimir informações do contas a pagar conforme parâmetros informados.")

	DEFINE SECTION oDados1 OF oReport TABLES "SE2" TITLE cTitulo ORDERS aOrd
	DEFINE CELL NAME "E2_FORNECE"	OF oDados1 ALIAS "SE2"
	DEFINE CELL NAME "E2_LOJA"	   OF oDados1 ALIAS "SE2"
	DEFINE CELL NAME "E2_NOMFOR"	OF oDados1 ALIAS "SE2"
	DEFINE CELL NAME "E2_VALOR"	OF oDados1 ALIAS "SE2"
	DEFINE CELL NAME "E2PAGO"	   OF oDados1 ALIAS "SE2" TITLE "Vlr. Pago" PICTURE "@E 999,999,999.99"
	DEFINE CELL NAME "E2_SALDO"	OF oDados1 ALIAS "SE2"
Return( oReport )

Static Function DefPrint( oReport, aOrd, cTitulo )
	Local cSE2 := GetNextAlias()
	Local cOrder := ""
	
	Local oSection10 := oReport:Section(1)
	Local oSection11 //:= oReport:Section(1):Section(1)
		
	Local oBreak
	Local oFunc1, OfUNC2
	

	//Fornecedor
	If oSection10:GetOrder() == 1 
   	cOrder := "%E2_FORNECE,E2_LOJA,E2_NUM%"
 	//Titulo
	Elseif oSection10:GetOrder() == 2 
   	cOrder := "%E2_NUM,E2_FORNECE,E2_LOJA%"
	//Emissao
	Elseif oSection10:GetOrder() == 3 
   	cOrder := "%E2_EMISSAO,E2_FORNECE,E2_LOJA%"
	//Vencimento
	Elseif oSection10:GetOrder() == 4 
   	cOrder := "%E2_VENCTO,E2_FORNECE,E2_LOJA%"
	//Vencimento Real
	Elseif oSection10:GetOrder() == 5 
   	cOrder := "%E2_VENCREA,E2_FORNECE,E2_LOJA%"
	Endif
	
	If mv_par07==1 // Sintetico
		cOrder := "%E2_FORNECE, E2_LOJA%"
		
		oSection10:BeginQuery()
			BeginSQL Alias cSE2
				Column E2_VALOR	As Numeric(12,2)
				Column E2PAGO     As Numeric(12,2)
				Column E2_SALDO	As Numeric(12,2)
				%NoParser%
				
				SELECT 	E2_FORNECE, E2_LOJA, E2_NOMFOR, SUM(E2_VALOR) E2_VALOR, SUM(E2_SALDO) AS E2_SALDO, SUM(E2_VALOR-E2_SALDO) AS E2PAGO
				FROM		%Table:SE2%
				WHERE 	E2_FILIAL = %xFilial:SE2% AND
							E2_FORNECE BETWEEN %Exp:mv_par01% AND %Exp:mv_par02% AND 
							E2_TIPO BETWEEN %Exp:mv_par03% AND %Exp:mv_par04% AND
							E2_VENCTO BETWEEN %Exp:mv_par05% AND %Exp:mv_par06% AND
							%NotDel%
				GROUP BY E2_FORNECE, E2_LOJA, E2_NOMFOR
				ORDER BY %Exp:cOrder%
			EndSQL
		oSection10:EndQuery()	
	Else
		DEFINE SECTION oSection11 OF oSection10 TABLES "SE2" TITLE cTitulo
		DEFINE CELL NAME "E2_PREFIXO"	OF oSection11 ALIAS "SE2"
		DEFINE CELL NAME "E2_NUM"	   OF oSection11 ALIAS "SE2"
		DEFINE CELL NAME "E2_PARCELA"	OF oSection11 ALIAS "SE2"
		DEFINE CELL NAME "E2_TIPO"	   OF oSection11 ALIAS "SE2"
		DEFINE CELL NAME "E2_FORNECE"	OF oSection11 ALIAS "SE2"
		DEFINE CELL NAME "E2_LOJA"	   OF oSection11 ALIAS "SE2"
		DEFINE CELL NAME "E2_NOMFOR"	OF oSection11 ALIAS "SE2"
		DEFINE CELL NAME "E2_EMISSAO"	OF oSection11 ALIAS "SE2"
		DEFINE CELL NAME "E2_VENCTO"	OF oSection11 ALIAS "SE2"
		DEFINE CELL NAME "E2_VENCREA"	OF oSection11 ALIAS "SE2"
		DEFINE CELL NAME "E2_VALOR"	OF oSection11 ALIAS "SE2"
		DEFINE CELL NAME "E2PAGO"	   OF oSection11 ALIAS "SE2" TITLE "Vlr. Pago" PICTURE "@E 999,999,999.99"
		DEFINE CELL NAME "E2_SALDO"	OF oSection11 ALIAS "SE2"

		// Desabilito as celulas que contem os dados sinteticos
		oSection10:Cell("E2_VALOR"):Disable()
		oSection10:Cell("E2PAGO"):Disable()
		oSection10:Cell("E2_SALDO"):Disable()
		
		oSection10:BeginQuery()
			BeginSQL Alias cSE2
				Column E2_EMISSAO	As Date
				Column E2_VENCTO	As Date
				Column E2_VENCREA	As Date
				Column E2_VALOR	As Numeric(12,2)
				Column E2PAGO     As Numeric(12,2)
				Column E2_SALDO	As Numeric(12,2)
				%NoParser%
				
				SELECT 	E2_FILIAL, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA, E2_NOMFOR,
							E2_EMISSAO, E2_VENCTO, E2_VENCREA, E2_VALOR, E2_SALDO, (E2_VALOR-E2_SALDO) AS E2PAGO
				FROM		%Table:SE2%
				WHERE 	E2_FILIAL = %xFilial:SE2% AND
							E2_FORNECE BETWEEN %Exp:mv_par01% AND %Exp:mv_par02% AND 
							E2_TIPO BETWEEN%Exp:mv_par03% AND %Exp:mv_par04% AND
							E2_VENCTO BETWEEN %Exp:mv_par05% AND %Exp:mv_par06% AND
							%NotDel%
				ORDER BY %Exp:cOrder%
			EndSQL
		oSection10:EndQuery()
		
		//Para recuperar a query utilizanda no SQL Embedded
		//aQry := GetLastQuery()
		//Alert( aQry[2] )
		
		oSection11:SetParentQuery()
		oSection11:SetParentFilter({|cParam| (cSE2)->( E2_FILIAL + E2_FORNECE + E2_LOJA ) == cParam },{|| (cSE2)->( E2_FILIAL + E2_FORNECE + E2_LOJA ) })
		oBreak := TRBreak():New( oSection10, oSection10:Cell("E2_FORNECE"), "Fornecedor", )
		oBreak:SetPageBreak(mv_par08==1)
		
		oFunc1 := TRFunction():New(oSection11:Cell("E2_VALOR"),"x","SUM",oBreak,"","@E 999,999,999.99",/*[ uFormula ]*/ ,/*[ lEndSection ]*/ ,/*[ lEndReport ]*/)
		oFunc2 := TRFunction():New(oSection11:Cell("E2_SALDO"),"x","SUM",oBreak,"","@E 999,999,999.99",/*[ uFormula ]*/ ,/*[ lEndSection ]*/ ,/*[ lEndReport ]*/)
		
		oSection11:SetTotalInLine(.F.)
	EndIf	

	oReport:SetTitle(cTitulo+ " - Por ordem de: "+aOrd[oSection10:GetOrder()])
	
	oSection10:Print()
Return

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | Inform.prw           | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - CriaSX1()                                              |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Funcao que cria o grupo de perguntas se necessario              |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
Static Function CriaSx1( cPerg )
Local aP := {}
Local i := 0
Local cSeq
Local cMvCh
Local cMvPar
Local aHelp := {}

/******
Parametros da funcao padrao
---------------------------
PutSX1(cGrupo,;
cOrdem,;
cPergunt,cPerSpa,cPerEng,;
cVar,;
cTipo,;
nTamanho,;
nDecimal,;
nPresel,;
cGSC,;
cValid,;
cF3,;
cGrpSxg,;
cPyme,;
cVar01,;
cDef01,cDefSpa1,cDefEng1,;
cCnt01,;
cDef02,cDefSpa2,cDefEng2,;
cDef03,cDefSpa3,cDefEng3,;
cDef04,cDefSpa4,cDefEng4,;
cDef05,cDefSpa5,cDefEng5,;
aHelpPor,aHelpEng,aHelpSpa,;
cHelp)

Característica do vetor p/ utilização da função SX1
---------------------------------------------------
[n,1] --> texto da pergunta
[n,2] --> tipo do dado
[n,3] --> tamanho
[n,4] --> decimal
[n,5] --> objeto G=get ou C=choice
[n,6] --> validacao
[n,7] --> F3
[n,8] --> definicao 1
[n,9] --> definicao 2
[n,10] -> definicao 3
[n,11] -> definicao 4
[n,12] -> definicao 5
***/
aAdd(aP,{"Fornecedor de"             ,"C",6,0,"G",""                    ,"SA2",""   ,""   ,"","",""})
aAdd(aP,{"Fornecedor ate"            ,"C",6,0,"G","(mv_par02>=mv_par01)","SA2",""   ,""   ,"","",""})
aAdd(aP,{"Tipo de"                   ,"C",3,0,"G",""                    ,"05" ,""   ,""   ,"","",""})
aAdd(aP,{"Tipo ate"                  ,"C",3,0,"G","(mv_par04>=mv_par03)","05" ,""   ,""   ,"","",""})
aAdd(aP,{"Vencimento de"             ,"D",8,0,"G",""                    ,""   ,""   ,""   ,"","",""})
aAdd(aP,{"Vencimento ate"            ,"D",8,0,"G","(mv_par06>=mv_par05)",""   ,""   ,""   ,"","",""})
aAdd(aP,{"Aglutinar pagto.de fornec.","N",1,0,"C",""                    ,""   ,"Sim","Nao","","",""})
aAdd(aP,{"Salta página p/ fornecedor","N",1,0,"C",""                    ,""   ,"Sim","Nao","","",""})

aAdd(aHelp,{"Informe o código do fornecedor.","inicial."})
aAdd(aHelp,{"Informe o código do fornecedor.","final."})
aAdd(aHelp,{"Tipo de título inicial."})
aAdd(aHelp,{"Tipo de título final."})
aAdd(aHelp,{"Digite a data do vencimento incial."})
aAdd(aHelp,{"Digite a data do vencimento final."})
aAdd(aHelp,{"Aglutinar os títulos do mesmo forne-","cedor totalizando seus valores."})
aAdd(aHelp,{"Saltar página por quebra de","fornecedor. Sim ou Não?"})

For i:=1 To Len(aP)
	cSeq   := StrZero(i,2,0)
	cMvPar := "mv_par"+cSeq
	cMvCh  := "mv_ch"+IIF(i<=9,Chr(i+48),Chr(i+87))
	
	PutSx1(cPerg,;
	cSeq,;
	aP[i,1],aP[i,1],aP[i,1],;
	cMvCh,;
	aP[i,2],;
	aP[i,3],;
	aP[i,4],;
	0,;
	aP[i,5],;
	aP[i,6],;
	aP[i,7],;
	"",;
	"",;
	cMvPar,;
	aP[i,8],aP[i,8],aP[i,8],;
	"",;
	aP[i,9],aP[i,9],aP[i,9],;
	aP[i,10],aP[i,10],aP[i,10],;
	aP[i,11],aP[i,11],aP[i,11],;
	aP[i,12],aP[i,12],aP[i,12],;
	aHelp[i],;
	{},;
	{},;
	"")
Next i
Return