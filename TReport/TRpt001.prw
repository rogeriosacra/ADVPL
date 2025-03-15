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

	Local oReport
	Local cAlias := getNextAlias()//retorna um alias para ser usado
	
	OReport := RptStruc(cAlias)
	
	OReport:printDialog()//Gera tela de impressão

Return

Static Function RPrint(oReport,cAlias) //monta a query após receber os dois parâmetros: objeto oReport e o Alias 

	Local oSecao1 := oReport:Section(1) //método Section retorna um objeto do tipo TRsection (Seção) parâmetro 1 indica numero da seção
	
	oSecao1:BeginQuery() //Método BeginQuery indica que uma query será usada uma query, embedded sql
	
		BeginSQL Alias cAlias//Sintaxe embedded SQL, cAlias foi passado por parâmetro 
		
			SELECT
			B1_FILIAL FILIAL, B1_COD CODIGO, B1_DESC DESCRICAO, B1_TIPO TIPO, B1_ATIVO ATIVO
				FROM %Table:SB1% SB1
					WHERE B1_FILIAL = '01' AND B1_MSBLQL <> '1' AND D_E_L_E_T_ = ''
				GROUP BY B1_FILIAL, B1_COD,B1_DESC,B1_TIPO,B1_ATIVO
		
		EndSQL //Encerra o BeginSQL
		
	oSecao1:EndQuery() //Encerra o BeginQuery
	oReport:SetMeter((cAlias)->(RecCount()))//Método setmeter, gera barra de progresso contando quantidade de registros existentes no Arquivo ALIAs
		
	oSecao1:Print()//Método para impressão do relatório
	

Return

Static Function RptStruc(cAlias)//Após receber como parâmetro o alias contendo os registros da consulta SQL, Cria a estrutura do relatório com colunas, títulos de colunas.

Local cTitulo := "Produtos ativos"
Local cHelp := "Permite imprimir relatório de produtos"
Local oReport
Local oSection1

//Instanciando a classe TReport:
oReport := TReport():New('TRPT001',cTitulo,,{|oReport|RPrint(oReport, cAlias)},cHelp)

//Seção
oSection1 := TRSection():New(oReport, "Produtos",{"SB1"})

TRCell():New(oSection1,"FILIAL","SB1","Filial") //Defini as colunas dentro da seção para cada coluna dos registros 
TRCell():New(oSection1,"CODIGO", "SB1", "Codigo") 
TRCell():New(oSection1,"DESCRICAO", "SB1", "Descricao") 
TRCell():New(oSection1,"TIPO", "SB1", "Tipo")
TRCell():New(oSection1,"ATIVO", "SB1", "Ativo")


Return (oReport)

