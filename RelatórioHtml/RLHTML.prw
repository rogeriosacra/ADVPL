#Include 'Protheus.ch'
#Include 'Parmtype.ch'

/*/{Protheus.doc} Graf001
Exemplo de relat�rio em formato HTM utilizando advpl
@type function
@author Curso Desenvolvendo relat�rios com ADVPL - RCTI Treinamentos
@since 2019
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see www.rctitreinamentos.com.br
/*/

User Function RLHTML()

	If MsgYesNo("Deseja imprimir o relat�rio HTML?")
		
	Processa({||MntQry() 	},,"Processando...")
	MsAguarde( { || GeraHTML() },,"O arquivo HTML est� sendo Gerado... ")
	
	Else
		Alert("<b>Cancelado pero usu�rio.</b>")
		Return Nil
	EndIf
	
Return

/** Fun��o est�tica que monta a pesquisa em SQL  **/
Static Function MntQry()

  Local cQuery := " "

 cQuery +=  " SELECT B1_FILIAL AS FILIAL, B1_COD AS CODIGO, "
 	cQuery += " B1_DESC AS DESCRICAO, B1_TIPO AS TIPO, " 
 cQuery += " B1_GRUPO AS GRUPO, B1_POSIPI AS IPI FROM SB1990 WHERE D_E_L_E_T_ = '' "

	cQuery := ChangeQuery(cQuery)
		DbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), 'HT1', .F., .T.)

Return Nil

/** Fun��o para gerar o HTML **/

Static Function GeraHTML()

	Local cHtml := "" 
	Local cFile := "C:\teste_html\Index.htm"
	Local dData := Date() //armazenando a data atual
	
	nH := fCreate(cFile)
		If nH == -1
			MsgStop("Falha ao criar o arquivo HTML "+ Str(Ferror()))
				Return
		EndIf
		
		// Montagem do HTML.
	cHtml += '<html xmlns="http://www.w3.org/1999/xhtml">' 
   cHtml += '<head>' 
   cHtml += '<meta charset="iso-8859-1">'       
   cHtml += '<title>Relat�rio de produtos</title>' 
   cHtml += "<link rel='stylesheet' href='estilo-darck.css' />"
   cHtml += "</head>" 
   
   cHtml += "<body>" 
   cHtml += "<div id='cabec'>" 
   cHtml += "   <center>"
   cHtml += "<table width='331' id='table-b' summary='Produtos'>" 
   
   cHtml += "<tr>" 
   cHtml += " <td width='252' scope='row'><font face='arial'><b>Parametros:</b></font><br />" 
   cHtml += " <font face='arial'>Data de atualiza��o: "+ DToC(dData) +" </font><br /> <font face='arial'></font></td>" 
   
   cHtml += " </tr>" 
   cHtml += "</table></center>" 
   
   cHtml += "<p align=center><font face='Lucida Sans Unicode' size='6'><u>Relat�rio exemplo</u></font></p>" 
	cHtml += "  <center>" 
   cHtml += "<table width='1000' id='table-b' summary='Produtos'>" 
   cHtml += "<tr align='center'>" 
   cHtml += "<th width='72' scope='row'>Filial</th>" 
   cHtml += "<th width='100' scope='row'>Codigo</th>" 
   cHtml += "<th width='200'>Descricao</th>" 
   cHtml += "<th width='72'>Tipo</th>" 
   cHtml += "<th width='72'>Grupo</th>" 
   cHtml += "<th width='100'>Ipi</th>" 
   cHtml += "</tr>" 
   
   	FWrite(nH,cHtml)
   		cHtml := ""
   
   	While HT1->(!EOF())
   		
   		cHtml += "<tr><td>"+ HT1->(FILIAL) + "</td>"
   		cHtml += "<td>"+HT1->(CODIGO)+"</td>"
   		cHtml += "<td>"+HT1->(DESCRICAO)+"</td>"
   		cHtml += "<td>"+HT1->(TIPO)+"</td>"
   		cHtml += "<td>"+HT1->(GRUPO)+"</td>"
   		cHtml += "<td>"+HT1->(IPI)+"</td></tr>"
   		
   			FWrite(nH,cHtml)
   				cHtml := ""
   				HT1->(dbSkip())
   	
   	EndDO
   	
   		 FClose(nH)
   		
   	MsgInfo("Arquivo gerado com sucesso!!")
   	
   	//Abrindo o arquivo 
   	
   	nRet := ShellExecute("open",cFile,"","C:\teste_html\",1)
   
Return nRet

