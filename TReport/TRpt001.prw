#Include 'Protheus.ch'
#Include 'TopConn.ch'
#Include 'totvs.ch'

/*/{Protheus.doc} trpt001
Exemplo de relatorio utilizando Treport em edvpl
@type function
@author Curso Desenvolvendo relat�rios com ADVPL - RCTI Treinamentos
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
	
	OReport:printDialog()//Gera tela de impress�o

Return

Static Function RPrint(oReport,cAlias) //monta a query ap�s receber os dois par�metros: objeto oReport e o Alias 

	Local oSecao1 := oReport:Section(1) //m�todo Section retorna um objeto do tipo TRsection (Se��o) par�metro 1 indica numero da se��o
	
	oSecao1:BeginQuery() //M�todo BeginQuery indica que uma query ser� usada uma query, embedded sql
	
		BeginSQL Alias cAlias//Sintaxe embedded SQL, cAlias foi passado por par�metro 
		
			SELECT
			B1_FILIAL FILIAL, B1_COD CODIGO, B1_DESC DESCRICAO, B1_TIPO TIPO, B1_ATIVO ATIVO
				FROM %Table:SB1% SB1
					WHERE B1_FILIAL = '01' AND B1_MSBLQL <> '1' AND D_E_L_E_T_ = ''
				GROUP BY B1_FILIAL, B1_COD,B1_DESC,B1_TIPO,B1_ATIVO
		
		EndSQL //Encerra o BeginSQL
		
	oSecao1:EndQuery() //Encerra o BeginQuery
	oReport:SetMeter((cAlias)->(RecCount()))//M�todo setmeter, gera barra de progresso contando quantidade de registros existentes no Arquivo ALIAs
		
	oSecao1:Print()//M�todo para impress�o do relat�rio
	

Return

Static Function RptStruc(cAlias)//Ap�s receber como par�metro o alias contendo os registros da consulta SQL, Cria a estrutura do relat�rio com colunas, t�tulos de colunas.

Local cTitulo := "Produtos ativos"
Local cHelp := "Permite imprimir relat�rio de produtos"
Local oReport
Local oSection1

//Instanciando a classe TReport:
oReport := TReport():New('TRPT001',cTitulo,,{|oReport|RPrint(oReport, cAlias)},cHelp)

//Se��o
oSection1 := TRSection():New(oReport, "Produtos",{"SB1"})

TRCell():New(oSection1,"FILIAL","SB1","Filial") //Defini as colunas dentro da se��o para cada coluna dos registros 
TRCell():New(oSection1,"CODIGO", "SB1", "Codigo") 
TRCell():New(oSection1,"DESCRICAO", "SB1", "Descricao") 
TRCell():New(oSection1,"TIPO", "SB1", "Tipo")
TRCell():New(oSection1,"ATIVO", "SB1", "Ativo")


Return (oReport)

