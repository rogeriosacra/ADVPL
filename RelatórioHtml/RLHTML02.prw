#Include 'Protheus.ch'

/*/{Protheus.doc} RLHTML02
Exemplo de relat�rio em HTML com a folha de estilo CSS embutida no c�digo ADVPL.
@type function
@author Desenvolvendo relat�rios com ADVPL - RCTI Treinamentos
@since2019
@version 1.0
@see www.rctitreinamentos.com.br
/*/

User Function RLHTML02()

If MsgYesNo("Deseja imprimir o relat�rio HTM?")
		
	Processa({||MntQry() 	},,"Processando...")
	MsAguarde( { || GeraHTML() },,"O arquivo HTM est� sendo Gerado... ")
	
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
   cHtml += "</head>" 
   cHtml += ' <style type="text/css">'
   	cHtml += '  #table-b { '
   cHtml += "font-family: 'Lucida Sans Unicode', 'Lucida Grande', Sans-Serif;" 
   cHtml += "font-size: 11px;" 
   cHtml += "background: #fff;" 
   cHtml += "margin: 10px;" 
   cHtml += "width: 1000x; " 
   cHtml += "border-collapse: collapse; " 
   cHtml += "text-align: left; } " 
   
   cHtml += "#table-b th { " 
   cHtml += "font-size: 14px; " 
   cHtml += "font-weight: bold; " 
   cHtml += "color: #333; " 
   cHtml += "padding: 10px 8px; " 
   cHtml += "border-bottom: 2px solid #999; } " 
   
   cHtml += "#table-b td { "   
   cHtml += "border-bottom: 1px solid #555; "  
   cHtml += "color: #333; "   
   cHtml += "padding: 6px 8px; } " 
   
   cHtml += "#table-b tbody tr:hover td { " 
   cHtml += " background-color: #90caf9; "
   cHtml += "} "
   
   cHtml += "</style> <body>" 
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
   cHtml += "<th width='200'>Descri��o</th>" 
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
   	
   	nRet := ShellExecute("open",cFile,"","C:\teste_html\Index.htm",1)
   
Return nRet


