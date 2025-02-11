#Include 'Protheus.ch'
#Include "FWMVCDef.ch"

/*/{Protheus.doc} rlexcel2
Exemplo gerar arquivo Excel em duas abas com advpl
@type function
@author Curso Desenvolvendo relatórios com ADVPL - RCTI Treinamentos
@since 2019
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see www.rctitreinamentos.com.br
/*/

User Function RLExcel2()

	MsgInfo("Este programa tem como objetivo imprimir relatórios em Excel")
	
	Processa({||MntQry() },,"Processando...")
	MsAguarde({|| GeraExcel()},,"O arquivo Excel está sendo gerado...")
	
		dbSelectArea("TR1")
		dbCloseArea()
	

Return Nil


/** Montando a função da Query **/
Static Function MntQry()

	Local cQuery := ""
	
	//pegar os dados da base de dados
	
cQuery := " SELECT A1_COD AS COD_CLI,A1_NOME AS NOME,C5_NUM AS PEDIDO,C5_EMISSAO AS EMISSAO, C6_QTDVEN AS QTDVEN,C6_PRCVEN VALOR,B1_DESC AS DESCRICAO "   
   	cQuery += " FROM SA1990 SA1, SC5990 SC5, SC6990 SC6, SB1990 SB1 "
   		cQuery += " WHERE SA1.D_E_L_E_T_ = '' AND "
   			cQuery += " C5_FILIAL = '01' AND SC5.D_E_L_E_T_ = '' AND C5_CLIENTE = A1_COD AND "
   		cQuery += " C6_FILIAL = '01' AND SC6.D_E_L_E_T_ = '' AND C6_NUM = C5_NUM AND "
   	cQuery += " B1_FILIAL = '01' AND SB1.D_E_L_E_T_ = '' AND B1_COD = C6_PRODUTO "  
 cQuery += " ORDER BY A1_FILIAL,A1_COD,C5_FILIAL,C5_NUM,C6_FILIAL,C6_ITEM "
	
		If Select("TR1") <> 0
			DbSelectArea("TR1")
			DbCloseArea()
		EndIf	
		
		cQuery := ChangeQuery(cQuery)
		DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),'TR1',.F.,.T.)
		
Return Nil

/*** Função para gerar o arquivo Excel FWMsExcel()  **/

Static Function GeraExcel()
	Local oExcel := FWMSEXCEL():New()
	Local lOK := .F.
	Local cArq := ""
	Local cDirTmp := "C:\SPOOL\"
	
		dbSelectArea("TR1")
		TR1->(dbGoTop())

		
		// Atributos da classe
		
		oExcel:SetFontSize(12)
		oExcel:SetFont("Arial")
		oExcel:SetTitleBold(.T.)
		oExcel:SetBgGeneralColor("#333")
		oExcel:SetTitleFrColor("#FFFF00")
		oExcel:SetLineFrColor("#A9A9A9")
		oExcel:Set2LineFrColor("#FFFFFF")
		
		// ABA 1
		
	oExcel:AddWorkSheet("ABA 1")
	oExcel:AddTable("ABA 1","CLIENTES")
	oExcel:AddColumn("ABA 1","CLIENTES","COD_CLI",1,1)
	oExcel:AddColumn("ABA 1","CLIENTES","NOME",1,1)
	oExcel:AddColumn("ABA 1","CLIENTES","PEDIDO",1,1)
		
		//ABA 2
		
	oExcel:AddWorkSheet("ABA 2")
	oExcel:AddTable("ABA 2","PEDIDOS")
	oExcel:AddColumn("ABA 2","PEDIDOS","PEDIDO",1,1)
	oExcel:AddColumn("ABA 2","PEDIDOS","EMISSAO",1,1)
	oExcel:AddColumn("ABA 2","PEDIDOS","QTDVEN",1,1)
	oExcel:AddColumn("ABA 2","PEDIDOS","VALOR",3,3)
	oExcel:AddColumn("ABA 2","PEDIDOS","DESCRICAO",1,1)
	
		While TR1->(!EOF())
		
		oExcel:AddRow("ABA 1","CLIENTES",{TR1->(COD_CLI),;
													  TR1->(NOME),;
													  TR1->(PEDIDO)})
													  
		 oExcel:AddRow("ABA 2","PEDIDOS",{ TR1->(PEDIDO),;
													  TR1->(sToD(EMISSAO)),;
					Ç]~ÇÇ								  TR1->(QTDVEN),;
													  TR1->(VALOR),;
													  TR1->(DESCRICAO)})
													     
			lOk := .T.
			TR1->(dbSkip())
		
		EndDo
		
		oExcel:Activate()
	
		cArq := CriaTrab(NIL, .F.) + ".xml"
		oExcel:GetXMLFile(cArq)
		
			If __CopyFile(cArq,cDirTmp + cArq)
				If lOK
					oExcelApp := FWMSEXCEL():New()
					oExcelApp:WorkBooks:Open(cDirTmp + cArq)
					oExcelApp:SetVisible(.T.)
					oExcelApp:Destroy()
					
				MsgInfo("O arquivo Excel foi gerado no dirtério: " + cDirTmp + cArq + ". ")
					
				EndIf
				Else
						MsgAlert("Erro ao cpiar o arquivo Excel!!")
				EndIf
		
		

Return Nil


