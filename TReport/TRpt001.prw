#Include 'Protheus.ch'
#Include 'TopConn.ch'
#Include 'totvs.ch'

/*/{Protheus.doc} trpt001
Exemplo de relatorio utilizando Treport em edvpl
@type function
@author Curso Desenvolvendo relatórios com ADVPL - RCTI Treinamentos
@since 2019
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see www.rctitreinamentos.com.br
/*/

User Function TRpt001()

	Local oReport := Nil
	Local cPerg := Padr("TRPT002",10)

	Pergunte(cPerg,.T.) //SX1

	oReport := Rpt01(cPerg)
	oReport:PrintDialog()

Return

Static Function RPT02(oReport) //monta a query após receber os dois parâmetros: objeto oReport e o Alias

	Local oSection1 := oReport:Section(1) //método Section retorna um objeto do tipo TRsection (Seção) parâmetro 1 indica numero da seção
	Local cQuery := ""
	//Local cNumProd := ""

	//oSecao1:BeginQuery() //Método BeginQuery indica que uma query será usada uma query, embedded sql

	//BeginSQL Alias cAlias//Sintaxe embedded SQL, cAlias foi passado por parâmetro

	cQuery :=	" SELECT " + CRLF
	cQuery +=	" B1_COD CODIGO, B1_FILIAL FILIAL,  B1_DESC DESCRICAO, B1_TIPO TIPO, B1_ATIVO ATIVO " + CRLF
	cQuery +=	" FROM " + RetSqlName("SB1")+ " B1 " + CRLF
	cQuery +=	" WHERE B1_FILIAL = '' AND B1_MSBLQL <> '1' AND D_E_L_E_T_ = '' " + CRLF
	cQuery +=   " AND B1_TIPO = '"+MV_PAR01+"' AND B1.D_E_L_E_T_ = '' " + CRLF 
	cQuery +=	" GROUP BY B1_FILIAL, B1_COD,B1_DESC,B1_TIPO,B1_ATIVO " + CRLF

	//EndSQL //Encerra o BeginSQL

	//oSecao1:EndQuery() //Encerra o BeginQuery
	//oReport:SetMeter((cAlias)->(RecCount()))//Método setmeter, gera barra de progresso contando quantidade de registros existentes no Arquivo ALIAs
	//Verifica se a tabela ja está aberta.
	If Select("TEME") <> 0
		DbSelectArea("TEME")
		DbCloseArea()
	EndIf

	TCQUERY cQuery NEW ALIAS "TEME"

	DbSelectArea("TEME")
	TEME->(dbGoTop())

	oReport:SetMeter(TEME->(LastRec()))

	While !EOF()
		If oReport:Cancel()
			Exit
		EndIf
		//Iniciando a primeira seção
		oSection1:Init()
		oReport:IncMeter()

		//cNumProd := TEME->B1_COD
		IncProc("Imprimindo PRODUTO"+ Alltrim(TEME->B1_COD))

		//Imprimindo primeira seção:
		oSection1:Cell("B1_DESC"):SetValue(TEME->B1_FILIAL)
		oSection1:Cell("B1_COD"):SetValue(TEME->B1_COD)
		oSection1:Cell("B1_DESC"):SetValue(TEME->B1_DESC)
		oSection1:Cell("B1_TIPO"):SetValue(TEME->B1_TIPO)
		oSection1:Cell("B1_ATIVO"):SetValue(TEME->B1_ATIVO)
		oSection1:Printline()

		TEME->(dbSkip())



		oReport:ThinLine()

		oSection1:Finish()

	EndDo



	oSection1:Print()//Método para impressão do relatório


Return

Static Function Rpt01(cNome)//Após receber como parâmetro o alias contendo os registros da consulta SQL, Cria a estrutura do relatório com colunas, títulos de colunas.

	Local cTitulo := "Produtos ativos"
	Local cHelp := "Permite imprimir relatório de produtos"
	Local oReport
	Local oSection1

//Instanciando a classe TReport:
//oReport := TReport():New('TRPT001',cTitulo,,{|oReport|RPrint(oReport, cAlias)},cHelp)
	oReport := TReport():New(cNome,cTitulo,cNome,{|oReport| RPT02(oReport)},cHelp)

	oReport:SetPortrait() //Definindo a orientação como retrato

//Seção
  //oSection1 := TRSection():New(oReport, "Produtos",{"SB1"})
	//oSection1 := TRSection():New(oReport, "Clientes",{"SB1"}, NIL,.F.,.T.)
	//oSection1 := TRSection():New(oReport, "PRODUTOS",{"SB1"})

	oSection1 := TRSection():New(oReport, "PRODUTOS",{"SB1"}, NIL,.F.,.T.)
	TRCell():New(oSection1,"B1_FILIAL"  ,"TEME","FILIAL"	,"@!",40)
	TRCell():New(oSection1,"B1_COD"		,"TEME","CODIGO"  		,"@!",40)
	TRCell():New(oSection1,"B1_DESC"  ,"TEME","DESCRICAO"	,"@!",100)
	TRCell():New(oSection1,"B1_TIPO"  ,"TEME","TIPO"	,"@!",20)
	TRCell():New(oSection1,"B1_ATIVO"  ,"TEME","ATIVO"	,"@!",30)

	/*TRCell():New(oSection1,"FILIAL","SB1","Filial") //Defini as colunas dentro da seção para cada coluna dos registros
	TRCell():New(oSection1,"CODIGO", "SB1", "Codigo")
	TRCell():New(oSection1,"DESCRICAO", "SB1", "Descricao")
	TRCell():New(oSection1,"TIPO", "SB1", "Tipo")
	TRCell():New(oSection1,"ATIVO", "SB1", "Ativo")*/

	oSection1:SetPageBreak(.F.) //Quebra de seção


Return (oReport)

