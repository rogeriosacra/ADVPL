#INCLUDE "PROTHEUS.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"

//Namespace totvs.protheus.backoffice.fiscal.configurador.consult.tax.operations

User Function ConsMovFis()

    Local oNewPag         := NIL
    Local oStepWiz        := NIL
    Local aCoords         := FWGetDialogSize()
    Local nSteps          := 0
    Local lAllSelect    := .T. // Variável para controlar a seleção de todos os itens
    Local lAllImp       := .T. // Variável para controlar a seleção de todos os impostos
    Local aCampos       := {}
    Local aEstrutura    := {}

    Private oFont18       := TFont():New('Arial',,18,,.F.,,,,,.F.,.F.) // Fonte do texto
    Private lAllPerfil    := .T.
    Private aResumoTax    := {}
    Private aDadosOrdem := {}
    Private oMarkOrdem  := NIL
    Private oImposto    := NIL
    Private oMarkSA1    := NIL
    Private oMarkSB1    := NIL
    Private oMarkSA2    := NIL
    Private oMarkSF4    := NIL
    Private oMarkSF7    := NIL
    Private oMarkCFC    := NIL

    Private dDataDeSFT    := FirstYDate(dDataBase)
    Private dDataAteSFT   := LastYDate(dDataBase)

    oStepWiz:= FWWizardControl():New(,{aCoords[3] * 0.8, aCoords[4] * 0.8})
    oStepWiz:ActiveUISteps()

    //----------------------
    // Pagina 1 - Início
    //----------------------
    nSteps +=1

    oNewPag := oStepWiz:AddStep(cValToChar(nSteps))
    //Altera a descrição do step
    oNewPag:SetStepDescription("Início") //"Início"
    //Define o bloco de construção
    oNewPag:SetConstruction({|Panel|TelaAprest(Panel)})
    oNewPag:SetNextAction({||.T. }) 
    //------------------------------
    // Pagina 2 - Cadastro de produtos
    //-----------------------------

    nSteps +=1
    oNewPag := oStepWiz:AddStep(cValToChar(nSteps))
    //Altera a descrição do step
    oNewPag:SetStepDescription("Produto") //"Produto"
    //Define o bloco de construção
    oNewPag:SetConstruction({|Panel|MarkTabela(Panel, "SB1", @lAllSelect, @oMarkSB1)})
    oNewPag:SetNextAction({||.T. }) 

    //------------------------------
    // Pagina 3 - Cadastro de Clientes
    //-----------------------------

    nSteps +=1
    oNewPag := oStepWiz:AddStep(cValToChar(nSteps))
    //Altera a descrição do step
    oNewPag:SetStepDescription("Cliente") //"Cliente"
    //Define o bloco de construção
    oNewPag:SetConstruction({|Panel|MarkTabela(Panel, "SA1", @lAllSelect, @oMarkSA1)})
    oNewPag:SetNextAction({||.T. }) 
    //Define o bloco ao clicar no botão Próximo

    //------------------------------
    // Pagina 4 - Cadastro de Fornecedores
    //-----------------------------

    nSteps +=1
    oNewPag := oStepWiz:AddStep(cValToChar(nSteps))
    //Altera a descrição do step
    oNewPag:SetStepDescription("Fornecedor") //"Fornecedor"
    //Define o bloco de construção
    oNewPag:SetConstruction({|Panel|MarkTabela(Panel, "SA2", @lAllSelect, @oMarkSA2)})
    oNewPag:SetNextAction({||.T. }) 
    //Define o bloco ao clicar no botão Próximo


    //------------------------------
    // Pagina 5 - Cadastro de TES
    //-----------------------------

    nSteps +=1
    oNewPag := oStepWiz:AddStep(cValToChar(nSteps))
    //Altera a descrição do step
    oNewPag:SetStepDescription("TES") //"Fornecedor"
    //Define o bloco de construção
    oNewPag:SetConstruction({|Panel|MarkTabela(Panel, "SF4", @lAllSelect, @oMarkSF4)})
    oNewPag:SetNextAction({||.T. }) 
    //Define o bloco ao clicar no botão Próximo


    //------------------------------
    // Pagina 6 - Cadastro de Exceção Fiscal
    //-----------------------------

    nSteps +=1
    oNewPag := oStepWiz:AddStep(cValToChar(nSteps))
    //Altera a descrição do step
    oNewPag:SetStepDescription("Exceção Fiscal") //"Fornecedor"
    //Define o bloco de construção
    oNewPag:SetConstruction({|Panel|MarkTabela(Panel, "SF7", @lAllSelect, @oMarkSF7)})
    oNewPag:SetNextAction({||.T. }) 
    //Define o bloco ao clicar no botão Próximo


    //------------------------------
    // Pagina 7 - Cadastro de UF x UF
    //-----------------------------
/*
    nSteps +=1
    oNewPag := oStepWiz:AddStep(cValToChar(nSteps))
    //Altera a descrição do step
    oNewPag:SetStepDescription("UF x UF") //"Fornecedor"
    //Define o bloco de construção
    oNewPag:SetConstruction({|Panel|MarkTabela(Panel, "CFC", @lAllSelect, @oMarkCFC)})
    oNewPag:SetNextAction({||.T. }) 
    //Define o bloco ao clicar no botão Próximo
*/
    
    //------------------------------
    // Pagina 8 - Selecione o Imposto
    //-----------------------------

    nSteps +=1
    oNewPag := oStepWiz:AddStep(cValToChar(nSteps))
    //Altera a descrição do step
    oNewPag:SetStepDescription("Impostos") //"Fornecedor"
    //Define o bloco de construção
    oNewPag:SetConstruction({|Panel|SelectTax(Panel, @lAllImp,@oImposto)})
    oNewPag:SetNextAction({||.T. }) 
    //Define o bloco ao clicar no botão Próximo

    //------------------------------
    // Pagina 9 - Filtros
    //----------------------------- 

    nSteps +=1
    oNewPag := oStepWiz:AddStep(cValToChar(nSteps))
    //Altera a descrição do step
    oNewPag:SetStepDescription("Filtros") //"Filtros"
    //Define o bloco de construção
    oNewPag:SetConstruction({|Panel|FiltraSFT(Panel,@oMarkOrdem)})
    oNewPag:SetNextAction({||FwMsgRun(,{|oSay| Concluir( aCampos, aEstrutura, oSay,oMarkSB1,oMarkSA1,oMarkSA2,oMarkSF4,oMarkSF7,oMarkCFC,oImposto,oMarkOrdem ) },"Processando Informações...","") .OR. .T. }) //"Processando Informações..."

 
    oStepWiz:Activate()
    oStepWiz:Destroy()

Return NIL

//-------------------------------------------------------------------
/*/{Protheus.doc} TelaAprest()

/*/
//-------------------------------------------------------------------
Static Function TelaAprest(oPanel)

    Local cTexto    := ""
    Local oPanel1   := NIL
    Local oLayer    := NIL
    Local oSayIntro := NIL

    cTexto += "<table width='100%' border=0 cellpadding='15' cellspacing='5' align:'justify'>"
    cTexto += "<tr>"
    cTexto += "<td colspan='5'>"

    cTexto += "<p>O relatório de operações fiscais permite a personalização por meio da inclusão de campos adicionais, <br><br>"
    cTexto += "conforme as regras e particularidades do ambiente tributário da empresa. Ele é gerado automaticamente a partir das informações contidas na tabela de livros fiscais." + "<br><br>"

    cTexto += "</td>"
    cTexto += "</tr>"
    cTexto += "</table>"

    oLayer := FWLayer():New()
    oLayer:Init(oPanel, .F.)
    oLayer:AddLine('LIN1', 60, .F.)

    oPanel1  := oLayer:getLinePanel('LIN1')

    oSayIntro := TSay():New(5,5,{||cTexto},oPanel1,,oFont18,,,,.T.,,,(oPanel1:nWidth / 2) - 10,(oPanel1:nHeight / 2) - 10,,,,,,.T.)

Return NIL


Static Function FiltraSFT(oPanel,oMarkOrdem)

    Local oSayOrigem := NIL
    Local oSayTitulo := NIL

    Local oLayer   := NIL
    Local oPanel0  := NIL
    Local oPanel1  := NIL
    Local oPanel2  := NIL

    Local aFields := {}
    Local aEstrut := {}

    Local aCamposOrdem := {}
    Local aCmpBrw      := {}

    Local oGetsSFT := NIL

    oLayer := FWLayer():New()
    oLayer:Init(oPanel,.F.)
    oLayer:AddLine('LIN0', 10, .F.)
    oLayer:AddLine('LIN1', 45, .F.)
    oLayer:addCollumn('LIN1_COL1',100,.F.,'LIN1')
    oLayer:AddLine('LIN2', 45, .F.)
    oLayer:addCollumn('LIN2_COL1',100,.F.,'LIN2')
    oLayer:AddWindow('LIN2_COL1','W1',"Ordem de geração",100,.F.,.F.,,'LIN2') //"Ordem de geração"

    oPanel0 := oLayer:getLinePanel('LIN0')
    oPanel1 := oLayer:getColPanel('LIN1_COL1', 'LIN1')
    oPanel2 := oLayer:getWinPanel('LIN2_COL1', 'W1', 'LIN2')

    // Título da página
    oSayTitulo := TSay():New(5,5,{||"Utilize os filtros abaixo para selecionar as operações do livro fiscal"},oPanel0,,oFont18,,,,.T.,,,(oPanel0:nWidth / 2) - 10,(oPanel0:nHeight / 2) - 10) //"Utilize os filtros abaixo para selecionar os produtos que serão adicionados ou removidos do(s) perfil(is) selecionado(s)"

    // CORREÇÃO PRINCIPAL - Montagem da MsMGet com RegToMemory
    aEstrut := MontaEstrut('SFT')
    aEval(aEstrut, {|x| aAdd(aFields, x[2])})
    
    // Inicializar as variáveis na memória (IMPORTANTE!)
    RegToMemory("SFT", .T., .F.)
    
    // Ajustar as coordenadas do MsMGet
    oGetsSFT := MsmGet():New(,,3,,,,aFields,{0,3,(oPanel1:nClientHeight-4)/2,(oPanel1:nClientWidth/2)-5},,,,,,oPanel1,,,.T.,,,.T.,aEstrut,,,,,.T.)

    // Seleção das origens
    oSayOrigem := TSay():New(0,0,{|| "Selecione a ordenação a ser considerada"},oPanel2,,oFont18,,,,.T.,,,15,0,,,,,,.T.) //"Selecione a ordenação a ser considerada"

    //Monta os campos do cliente
    aCmpBrw  := CamposBrw('aDadosOrdem', 'oMarkOrdem', 'ORDENACAO')

    aCamposOrdem    := HeaderMark(aCmpBrw, .F.)

    //Monta array de resumo dos clientes selecionados
    aDadosOrdem  := LoadTax(oMarkOrdem, 'ORDENACAO')

    //Browse de cliente
    ADDBrwArrayMark(@oMarkOrdem, .T.,aCamposOrdem, aDadosOrdem, oPanel2,.F.)


Return

//-------------------------------------------------------------------
/*/{Protheus.doc} MontaEstrut()

Função responsável por retornar a estrutura dos campos utilizados nas
MGMGET's dos filtros.
/*/
//-------------------------------------------------------------------
Static Function MontaEstrut(cTpEstrut)

    Local aRet := {}
    Local nPos := 0
    Local nTamData  := TamSx3("FT_ENTRADA")[1]
    //Local cXBF0G := alltrim(posicione("SXB", 1, "F0G1", "XB_ALIAS")) 

    Do Case

        Case cTpEstrut == "SFT"
            
            // Estrutura para o filtro da SFT

            nPos := AddStruct(@aRet)

            aRet[nPos][01] := "Data de"
            aRet[nPos][02] := 'dDataDeSFT'
            aRet[nPos][03] := 'D'
            aRet[nPos][04] := nTamData
            aRet[nPos][06] := PesqPict("SFT", "FT_ENTRADA")
            aRet[nPos][10] := FirstYDate(dDataBase)
            aRet[nPos][12] := {|| .T. }

            //aRet[nPos][10] := CriaVar('FT_ENTRADA')
            //aRet[nPos][07] := {||}//{||VldGet("F0G1_COD", cCodTes, @cDescTes)}
            //aRet[nPos][11] := "SFT"
//            _SetNamedPrvt( "dDataDeSFT" , CTOD("//"), 'totvs.protheus.backoffice.fiscal.configurador.consult.tax.operations.OperationReport')

            // Descrição

            nPos := AddStruct(@aRet)

            aRet[nPos][01] := "Data Ate"
            aRet[nPos][02] := 'dDataAteSFT'
            aRet[nPos][03] := 'D'
            aRet[nPos][04] := nTamData
            aRet[nPos][06] := PesqPict("SFT", "FT_ENTRADA")
            aRet[nPos][10] := LastYDate(dDataBase)
            aRet[nPos][12] := {|| .T. }

            //aRet[nPos][10] := CriaVar('FT_ENTRADA')
            //aRet[nPos][12] := {||.F.}
//            _SetNamedPrvt( "dDataAteSFT" , CTOD("//"), 'totvs.protheus.backoffice.fiscal.configurador.consult.tax.operations.OperationReport')

        
    EndCase

Return aRet

//-------------------------------------------------------------------
/*/{Protheus.doc} AddStruct()

Função responsável por adicionar um item de estrutura com os valores
DEFAULT. Este item será utilizado pela função MontaEstrut para composição
das MGMGET's utilizadas nos steps de filtro.

/*/
//-------------------------------------------------------------------
Static Function AddStruct(aEstruct)

    Local nPosicao   := 0

    DEFAULT aEstruct := {}

    Aadd(aEstruct,{})
    nPosicao := Len(aEstruct)

    Aadd(aEstruct[nPosicao],'')			// 01 - Titulo
    Aadd(aEstruct[nPosicao],'')			// 02 - Campo
    Aadd(aEstruct[nPosicao],'')			// 03 - Tipo
    Aadd(aEstruct[nPosicao],0)			// 04 - Tamanho
    Aadd(aEstruct[nPosicao],0)			// 05 - Decimal
    Aadd(aEstruct[nPosicao],'')			// 06 - Picture
    Aadd(aEstruct[nPosicao],{|| .T. })	// 07 - Valid
    Aadd(aEstruct[nPosicao],.F.)		// 08 - Obrigat
    Aadd(aEstruct[nPosicao],1)			// 09 - Nivel
    Aadd(aEstruct[nPosicao],'')			// 10 - Inicializador Padrão
    Aadd(aEstruct[nPosicao],'')			// 11 - F3
    Aadd(aEstruct[nPosicao],{|| })		// 12 - When
    Aadd(aEstruct[nPosicao],.F.)		// 13 - Visual
    Aadd(aEstruct[nPosicao],.F.)		// 14 - Chave
    Aadd(aEstruct[nPosicao],'')			// 15 - Box - Opção do combo
    Aadd(aEstruct[nPosicao],0)			// 16 - Folder
    Aadd(aEstruct[nPosicao],.F.)		// 17 - Não Alterável
    Aadd(aEstruct[nPosicao],'')			// 18 - PictVar
    Aadd(aEstruct[nPosicao],'N')		// 19 - Gatilho

Return nPosicao


//-------------------------------------------------------------------
/*/{Protheus.doc} MarkTabela

Função que realiza a montagem de um browse
com opção de mark.

/*/
//-------------------------------------------------------------------
Static Function MarkTabela(oPanel, cTabela, lAllPerfil,oMark)

    Local cAliasF20  := GetNextAlias()
    Local cQuery     := ""
    Local aCampos    := {}
    Local aColumns   := {}
    Local oLayer     := FWLayer():new()
    Local oPanel1     := NIL
    Local oPanel2     := NIL
    Local oSayTitulo := NIL

    //Chama função para montar query e array com os campos do Header
    cQuery := MontaQRY("SX3", {cTabela}, @aCampos)
    conout(cQuery)
    //Chama função para montar as colunas do aHeader
    aColumns  := HeaderMark(aCampos)

    //Cria Layer
    oLayer:Init(oPanel,.F.)

    // Adicionando linhas
    oLayer:AddLine('L1',10,.F.)
    oLayer:AddLine('L2',90,.F.)
    oPanel1 := oLayer:getLinePanel('L1')
    oPanel2 := oLayer:getLinePanel('L2')

    //Crio o TSay na primeira linha da Layer
    oSayTitulo := TSay():New(5,5,{||"Selecione os campos da tabela de " + DescTabela(cTabela) + " que serão incluídos na consulta" },oPanel1,,oFont18,,,,.T.,,,(oPanel1:nWidth / 2) - 10,(oPanel1:nHeight / 2) - 10) 

    //Criando o Browse
    AddMarkBro(oPanel2, @lAllPerfil, aCampos, aColumns, cQuery, cAliasF20, @oMark)

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} MontaQRY()

Função responsável por centralizar as queries executadas nas etapas
dos paineis.

/*/
//-------------------------------------------------------------------
Static Function MontaQRY(cTpQuery, aParamQry, aCampos, cArrayRes, cObjREs,cCodF20)

    Local cQuery      := ""
    Local nX          := 0

    DEFAULT cArrayRes := ''
    DEFAULT cObjREs   := ''
    DEFAULT cCodF20   := ''

    aCampos := CamposBrw(cArrayRes, cObjRes, "SX3")

        cQuery  := "SELECT 0 OK"

    //Adiciona os campos do Header na seção do select
    For nX := 1 to Len(aCampos)
        cQuery  += " , " + aCampos[nX][1]
    Next nX

    Do Case

        Case cTpQuery == "SX3"

            cQuery  += " FROM " + RETSQLNAME("SX3") + " SX3 WHERE SX3.X3_ARQUIVO = " + ValToSql(aParamQry[1]) + " AND SX3.X3_TIPO <> 'M'"
            cQuery  += " AND SX3.X3_CONTEXT <> 'V' AND SX3.D_E_L_E_T_ = ' ' ORDER BY SX3.X3_CAMPO"
            //cQuery  += " AND SX3.X3_CONTEXT = 'R' AND SX3.D_E_L_E_T_ = ' ' AND SX3.X3_PROPRI <> 'U' ORDER BY SX3.X3_CAMPO"

    EndCase

Return cQuery

//-------------------------------------------------------------------
/*/{Protheus.doc} HeaderMark(aCampos, lQuery)

Fubnção responsável por criar as colunas do Header do Browse

/*/
//-------------------------------------------------------------------
Static Function HeaderMark(aCampos, lQuery)

    Local oColuna   := NIL
    Local aColumns  := {}
    Local nX        := 0

    DEFAULT lQuery  := .T.

    For nX  := 1 to Len(aCampos)
        oColuna := FWBrwColumn():New()	    // Cria objeto
        oColuna:SetEdit(.F.)    	   	    // Indica se <E9> editavel
        oColuna:SetTitle(aCampos[nX][2])	// Define titulo
        oColuna:SetType(aCampos[nX][3])	    // Define tipo
        oColuna:SetSize(aCampos[nX][4])	    // Define tamanho
        oColuna:SetPicture(aCampos[nX][5])  // Define picture
        oColuna:SetAlign(aCampos[nX][6])    // Define alinhamento
        If lQuery
            oColuna:SetData(&('{||'+aCampos[nX][1]+'}'))
        Else
            oColuna:SetData(&(aCampos[nX][7]))
        EndIf
        Aadd(aColumns,oColuna)
    Next nX

Return aColumns

//-------------------------------------------------------------------
/*/{Protheus.doc} SetMarkAll()

Função responsável por fazer controle de marcar ou desmarcar todas
as linhas do grid

/*/
//-------------------------------------------------------------------
Static Function SetMarkAll( oObjMark, lMarkAll )

    Local cMarkABB := ''

    //Busco o Alias do Browse
    cMarkABB := oObjMark:cAlias

    //Percorro todoas as linhas e marco/desmarco todas as linhas
    (cMarkABB)->( DbGoTop() )
    While (cMarkABB)->( !EOF() )
        (cMarkABB)->OK := Iif(lMarkAll,1,0)
        (cMarkABB)->( DbSkip() )
    EndDo

    //Retorno para a primeira linha
    (cMarkABB)->( DbGoTop() )

    //Atualizo a variável de controle e do refresh no Browse
    lMarkAll := !lMarkAll
    oObjMark:Refresh(,.T.)
    oObjMark:Refresh(,.T.)

Return

Static Function SetArMaAll(aCols,oObjMark, lMarkAll)

	Local nCount    := 0
    Local nPosMark  := len(aCols[1]) //Posição do campo de marcação
	
	For nCount := 1 To Len(aCols)
		If lMarkAll
			aCols[nCount][nPosMark] := "1"
		Else
			aCols[nCount][nPosMark] := "0"
		EndIf
	Next
	lMarkAll := !lMarkAll

    oObjMark:Refresh(,.T.)


Return Nil


//-------------------------------------------------------------------
/*/{Protheus.doc} DescTabela()

Função que retorna a descrição do tipo de perfil

/*/
//-------------------------------------------------------------------
Static Function DescTabela(cTabela)
    Local cRet  := Capital(Trim(FwSX2Util():GetX2Name(cTabela)))
Return cRet

//-------------------------------------------------------------------
/*/{Protheus.doc} AddMarkBro()

Função que monta o MarkBrowse

/*/
//-------------------------------------------------------------------
Static Function AddMarkBro(oPanel, lAllMark, aCampos, aColumns, cQuery, cAliasTab, oMark)

    Local bMark        := {||IIf((oMark:cAlias)->OK == 1, "LBOK", "LBNO")}
    Local bMarkOne     := {||IIf((oMark:cAlias)->OK == 0,(oMark:cAlias)->OK := 1, (oMark:cAlias)->OK := 0 )}
    Local bMarkAll     := {||SetMarkAll(@oMark, @lAllMark)}

    oMark := FwFormBrowse():New()
    oMark:AddMarkColumns(bMark,bMarkOne,bMarkAll)
    oMark:SetDataQuery(.T.)
    oMark:SetQuery(cQuery)
    oMark:SetAlias(cAliasTab)
    oMark:SetOwner(oPanel)
    oMark:SetColumns(aColumns)
    oMark:SetDoubleClick(bMarkOne)
    oMark:DisableDetails()
    oMark:DisableReport()
    oMark:DisableConfig()
    oMark:Activate()
    oMark:GoTop(.T.)
    oMark:SetFocus()

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} CamposBrw()

Função que monta array com os campos que farão parte do Browse

/*/
//-------------------------------------------------------------------
Static Function CamposBrw(cArrayRes, cObjRes, cAlias)

    Local aRet          := {}

    DEFAULT cArrayRes   := ''
    DEFAULT cObjRes     := ''

    Do Case

        Case cAlias == "SX3"

            //Campos que farão parte da seção select da query e do Header
            aAdd(aRet,{;
            "X3_CAMPO",; //Campo
            "Campo",;//Descrição
            "C",;//Tipo
            10,;//Tamanho
            "@!",;//Picture;
            "LEFT",;//Alinhamento
            '{|| ' + cArrayRes + '[' + cObjRes +':At()][1] }'})//Bloco de Código para exibição do resumo

            aAdd(aRet,{;
            "X3_TITULO",; //Campo
            "Título",;//Descrição
            "C",;//Tipo
            12,;//Tamanho
            "@!",;//Picture;
            "LEFT",;//Alinhamento
            '{|| ' + cArrayRes + '[' + cObjRes +':At()][2] }'})//Bloco de Código para exibição do resumo

            aAdd(aRet,{;
            "X3_DESCRIC",; //Campo
            "Descrição",;//Descrição
            "C",;//Tipo
            25,;//Tamanho
            "@!",;//Picture;
            "LEFT",;//Alinhamento
            '{|| ' + cArrayRes + '[' + cObjRes +':At()][2] }'})//Bloco de Código para exibição do resumo

        Case cAlias == "IMPOSTO"

            //Campos que farão parte da seção select da query e do Header
            aAdd(aRet,{;
            "TRB_IMPOST",; //Campo
            "Imposto",;//Descrição
            "C",;//Tipo
            20,;//Tamanho
            "@!",;//Picture;
            "LEFT",;//Alinhamento
            '{|| ' + cArrayRes + '[' + cObjRes +':At()][1] }'})//Bloco de Código para exibição do resumo

        Case cAlias == "ORDENACAO"

            //Campos que farão parte da seção select da query e do Header
            aAdd(aRet,{;
            "TRX_ORDEM",; //Campo
            "Ordenação",;//Descrição
            "C",;//Tipo
            20,;//Tamanho
            "@!",;//Picture;
            "LEFT",;//Alinhamento
            '{|| ' + cArrayRes + '[' + cObjRes +':At()][1] }'})//Bloco de Código para exibição do resumo
    
    EndCase

Return aRet

//------------------------------------------------------------------
/*/{Protheus.doc} AtualizaMsg

Função que será chamada para atualizar descrição da barra de status

/*/
//------------------------------------------------------------------
Static Function AtualizaMsg( oSay, cMsg )

    oSay:cCaption := (cMsg)
    ProcessMessages()

Return

Static Function SelectTax(oPanel,lAllImp,oImposto)

    Local oLayer       := FWLayer():new()
    Local oSayTitulo   := NIL
    Local oPanel1      := NIL
    Local oPanel2      := NIL
    Local oPanel3      := NIL
    Local aCmpBrw      := {}
    Local aColsTax     := {}

    //Criando a Layer
    oLayer:Init(oPanel,.F.)

    // Adicionando linhas
    oLayer:AddLine('L1',10,.F.)
    oLayer:AddLine('L2',90,.F.)
    oPanel1 := oLayer:getLinePanel('L1')
    oPanel2 := oLayer:getLinePanel('L2')
    //Adicionando colunas
    oLayer:addCollumn('C1',100,.F.,'L2')
    //Adicionando Window
    oLayer:AddWindow('C1','W1',"Impostos",100,.F.,.F.,,'L2') //"Impostos"
    //Painel 
    oPanel3 := oLayer:getWinPanel('C1','W1','L2')

    //Crio o TSay na primeira linha da Layer
    oSayTitulo := TSay():New(5,5,{||"Selecione os impostos que serão adicionados" },oPanel1,,oFont18,,,,.T.,,,(oPanel1:nWidth / 2) - 10,(oPanel1:nHeight / 2) - 10) //"Selecione os impostos que serão adicionados"

    //Monta os campos 
    aCmpBrw  := CamposBrw('aResumoTax', 'oImposto', 'IMPOSTO')

    aColsTax    := HeaderMark(aCmpBrw, .F.)

   //Monta array de resumo dos selecionados
    aResumoTax  := LoadTax(oImposto, 'IMPOSTO')

    //Browse 
    ADDBrwArrayMark(@oImposto, @lAllImp,aColsTax, aResumoTax, oPanel3,.T.)

Return

Static Function LoadTax(oObjtForm, cTab)
    Local aRet   := {}

    If cTab == 'IMPOSTO'
        Aadd(aRet,{"ICMS"               ,"ICMS"         ,"0"})
        Aadd(aRet,{"IPI"                ,"IPI"          ,"0"})
        Aadd(aRet,{"PIS Apuração"       ,"PIS_APUR"     ,"0"})
        Aadd(aRet,{"COFINS Apuração"    ,"COFINS_APUR"  ,"0"})
        Aadd(aRet,{"CSLL Apuração"      ,"CSLL_APUR"    ,"0"})
        Aadd(aRet,{"PIS Retenção"       ,"PIS_RETE"     ,"0"})
        Aadd(aRet,{"COFINS Retenção"    ,"COFINS_RETE"  ,"0"})
        Aadd(aRet,{"CSLL Retenção"      ,"CSLL_RETE"    ,"0"})
        Aadd(aRet,{"ISS"                ,"ISS"          ,"0"})
        Aadd(aRet,{"IRRF"               ,"IRRF"         ,"0"})
        Aadd(aRet,{"INSS"               ,"INSS"         ,"0"})
    Elseif cTab == "ORDENACAO"

        Aadd(aRet,{"NCM"                ,"NCM"          ,"0"})
        Aadd(aRet,{"Perfil Operação"    ,"PERFIL_OPER"  ,"0"})
    
    endif

Return aRet


Static Function ADDBrwArrayMark(oBrowse, lAllMark,aColsBrw, aArrayBrw, oOwner,lOpcAllMark)
    Local nPosMark     := len(aArrayBrw[1])
    Local bMark        := {||IIf(aArrayBrw[oBrowse:At()][nPosMark] == "0","LBNO","LBOK") }
    Local bMarkOne     := {||IIf(aArrayBrw[oBrowse:At()][nPosMark] == "0",aArrayBrw[oBrowse:At()][nPosMark] := "1", aArrayBrw[oBrowse:At()][nPosMark] := "0" )}
    Local bMarkAll     := {||IIf(lOpcAllMark,SetArMaAll(aArrayBrw,@oBrowse, @lAllMark),.F.)}

    oBrowse := FwFormBrowse():New()
    oBrowse:AddMarkColumns(bMark,bMarkOne,bMarkAll)
    oBrowse:SetColumns(aColsBrw)
    oBrowse:SetDataArray()
    oBrowse:SetArray(aArrayBrw)
    oBrowse:SetOwner(oOwner)
    oBrowse:DisableDetails()
    oBrowse:DisableReport()
    oBrowse:DisableConfig()
    oBrowse:Activate()
    oBrowse:SetFocus()
    oBrowse:Refresh(.T.)

Return

Static Function Concluir(aCampos,aEstrutura,oSay,oMarkSB1,oMarkSA1,oMarkSA2,oMarkSF4,oMarkSF7,oMarkCFC,oImposto, oMarkOrdem)
    Local cSelect   := ""
    Local cGroup    := ""
    Local cOrder    := ""
    Local cOpcOrdem := ""
    Local cJoin     := ""
    Local cWhere    := ""


    if Valtype(oMarkOrdem) == "O"
        cOpcOrdem:=MontaAgrup(oMarkOrdem, @cSelect, @cGroup, @cOrder, @cJoin)
    endif

    CamposFixos(@aCampos, @aEstrutura, cOpcOrdem)

    if Valtype(oMarkSB1) == "O"
        MontaSelecao(oMarkSB1, "SX3", @aCampos, @aEstrutura)
    endif
    if Valtype(oMarkSA1) == "O"
        MontaSelecao(oMarkSA1, "SX3", @aCampos, @aEstrutura)
    endif
    if Valtype(oMarkSA2) == "O"
        MontaSelecao(oMarkSA2, "SX3", @aCampos, @aEstrutura)
    endif
    if Valtype(oMarkSF4) == "O"
        MontaSelecao(oMarkSF4, "SX3", @aCampos, @aEstrutura)
    endif
    if Valtype(oMarkSF7) == "O"
        MontaSelecao(oMarkSF7, "SX3", @aCampos, @aEstrutura)
    endif
    if Valtype(oMarkCFC) == "O"
        MontaSelecao(oMarkCFC, "SX3", @aCampos, @aEstrutura)
    endif
    if Valtype(oImposto) == "O"
        MontaSelecao(oImposto, "IMPOSTO", @aCampos, @aEstrutura)
        MontaWhere(oImposto, @cWhere)
    endif

    MontaSelecao(, "FINAL", @aCampos, @aEstrutura)

    GeraExcel(aCampos, aEstrutura, oSay, cSelect, cGroup, cOrder, cJoin, cWhere)

    AtualizaMsg( oSay, "Processamento Concluído com Sucesso!") //"Processamento Concluído com Sucesso!"

Return .T.

Static Function CamposFixos(aCampos, aEstrutura, cOpcOrdem)
    Local aSX3Info  := {}
    
    if cOpcOrdem=="NCM"
        aSX3Info:= FWSX3Util():GetFieldStruct( "FT_POSIPI")
        Aadd(aCampos,{"FT_POSIPI",.F.}) 
        Aadd(aEstrutura,{"FT_POSIPI", "FT_POSIPI", aSX3Info[2], aSX3Info[3], aSX3Info[4] ,"FIXO"})  
    elseif cOpcOrdem=="PERFIL_OPER"
        aSX3Info:= FWSX3Util():GetFieldStruct( "F23_CODIGO")
        Aadd(aCampos,{"COD_OPER",.F.}) 
        Aadd(aEstrutura,{"COD_OPER", "CODIGO_PERFIL_OPER", aSX3Info[2], aSX3Info[3], aSX3Info[4] ,"FIXO"})
        aSX3Info:= FWSX3Util():GetFieldStruct( "F20_DESC")
        Aadd(aCampos,{"F20_DESC",.F.}) 
        Aadd(aEstrutura,{"F20_DESC", "DESC_PERFIL_OPERACAO", aSX3Info[2], aSX3Info[3], aSX3Info[4] ,"FIXO"})  
    endif

    aSX3Info:= FWSX3Util():GetFieldStruct( "FT_ESTADO")
    Aadd(aCampos,{"FT_ESTADO",.F.}) 
    Aadd(aEstrutura,{"FT_ESTADO", "FT_ESTADO", aSX3Info[2], aSX3Info[3], aSX3Info[4] ,"FIXO"})  

    aSX3Info:= FWSX3Util():GetFieldStruct( "FT_TIPO")
    Aadd(aCampos,{"FT_TIPO",.F.})
    Aadd(aEstrutura,{"FT_TIPO", "FT_TIPO", aSX3Info[2], aSX3Info[3], aSX3Info[4] ,"FIXO"})  

    aSX3Info:= FWSX3Util():GetFieldStruct( "FT_TIPOMOV")
    Aadd(aCampos,{"FT_TIPOMOV",.F.})
    Aadd(aEstrutura,{"FT_TIPOMOV", "FT_TIPOMOV", aSX3Info[2], aSX3Info[3], aSX3Info[4] ,"FIXO"})  

    aSX3Info:= FWSX3Util():GetFieldStruct( "FT_CFOP")
    Aadd(aCampos,{"FT_CFOP",.F.})
    Aadd(aEstrutura,{"FT_CFOP", "FT_CFOP", aSX3Info[2], aSX3Info[3], aSX3Info[4] ,"FIXO"})  

    aSX3Info:= FWSX3Util():GetFieldStruct( "FT_CFPS")
    Aadd(aCampos,{"FT_CFPS",.F.})
    Aadd(aEstrutura,{"FT_CFPS", "FT_CFPS", aSX3Info[2], aSX3Info[3], aSX3Info[4] ,"FIXO"})  

    aSX3Info:= FWSX3Util():GetFieldStruct( "FT_CLIEFOR")
    Aadd(aCampos,{"FT_CLIEFOR",.F.})
    Aadd(aEstrutura,{"FT_CLIEFOR", "FT_CLIEFOR", aSX3Info[2], aSX3Info[3], aSX3Info[4] ,"FIXO"})  

    aSX3Info:= FWSX3Util():GetFieldStruct( "FT_LOJA")
    Aadd(aCampos,{"FT_LOJA",.F.})
    Aadd(aEstrutura,{"FT_LOJA", "FT_LOJA", aSX3Info[2], aSX3Info[3], aSX3Info[4] ,"FIXO"})  

    aSX3Info:= FWSX3Util():GetFieldStruct( "FT_CLIENT")
    Aadd(aCampos,{"FT_CLIENT",.F.})
    Aadd(aEstrutura,{"FT_CLIENT", "FT_CLIENT", aSX3Info[2], aSX3Info[3], aSX3Info[4] ,"FIXO"})  

    aSX3Info:= FWSX3Util():GetFieldStruct( "FT_CLASFIS")
    Aadd(aCampos,{"ORIGEM",.F.})
    Aadd(aEstrutura,{"ORIGEM", "ORIGEM", aSX3Info[2], aSX3Info[3], aSX3Info[4] ,"FIXO"})  

    aSX3Info:= FWSX3Util():GetFieldStruct( "FT_VALCONT")
    Aadd(aCampos,{"FT_VALCONT",.F.})
    Aadd(aEstrutura,{"FT_VALCONT", "FT_VALCONT", aSX3Info[2], aSX3Info[3], aSX3Info[4] ,"FIXO"})  

    aSX3Info:= FWSX3Util():GetFieldStruct( "FT_ESPECIE")
    Aadd(aCampos,{"FT_ESPECIE",.F.})
    Aadd(aEstrutura,{"FT_ESPECIE", "FT_ESPECIE", aSX3Info[2], aSX3Info[3], aSX3Info[4] ,"FIXO"})  

    aSX3Info:= FWSX3Util():GetFieldStruct( "FT_PRODUTO")
    Aadd(aCampos,{"FT_PRODUTO",.F.})
    Aadd(aEstrutura,{"FT_PRODUTO", "FT_PRODUTO", aSX3Info[2], aSX3Info[3], aSX3Info[4] ,"FIXO"})  

    aSX3Info:= FWSX3Util():GetFieldStruct( "FT_TES")
    Aadd(aCampos,{"FT_TES",.F.})
    Aadd(aEstrutura,{"FT_TES", "FT_TES", aSX3Info[2], aSX3Info[3], aSX3Info[4] ,"FIXO"}) 

    aSize(aSX3Info,0) //Limpa o array
Return

Static Function MontaSelecao(oObjtForm, cTab, aCampos, aEstrutura)

    Local cAls      := Nil
    Local aAcols    := {}
    Local nX        := 0
    Local nLen      := 0
    Local aSX3Info  := {}

    If cTab == 'SX3'
        cAls:= oObjtForm:cAlias
        if select(cAls) > 0
        //Percorro todoas as linhas e marco/desmarco todas as linhas
            (cAls)->( DbGoTop() )
            While (cAls)->( !EOF() )
                If (cAls)->OK == 1
                    aSX3Info:= FWSX3Util():GetFieldStruct((cAls)->X3_CAMPO)
                    Aadd(aCampos,{(cAls)->X3_CAMPO,.T.}) 
                    Aadd(aEstrutura,{(cAls)->X3_CAMPO, (cAls)->X3_CAMPO, aSX3Info[2], aSX3Info[3], aSX3Info[4],"" })     
                EndIF
                (cAls)->( DbSkip() )
            EndDo

            //Volto para primeiro registro e atualizo o componente
            (cAls)->( DbGoTop() )
            FwFreeArray(aSX3Info)
        endif

    ElseIf cTab == 'IMPOSTO'

        aAcols:= aClone(oObjtForm:oData:aArray)
        if len(aAcols)>0
            nLen := len(aAcols[1])
            for nX:=1 to len(aAcols)
                if aAcols[nX][nLen] == "1" //Verifico se o campo está marcado

                    if alltrim(aAcols[nX][2]) == "ICMS"
                        Aadd(aCampos,{"ICMS",.T.})
                        Aadd(aEstrutura,{"ICMS_CST"     , "ICMS_CST"                            , "C", 2, 0 ,""})
                        Aadd(aEstrutura,{"ICMS_ALIQ"    , "ICMS_ALIQUOTA"                       , "N", TamSx3("FT_ALIQICM")[1], TamSx3("FT_ALIQICM")[2],""})
                        Aadd(aEstrutura,{"ICMS_LF_VB"   , "ICMS_LF_VLR_BASE"                    , "C", 10, 0 ,""})
                        Aadd(aEstrutura,{"ICMS_TES_P"   , "ICMS_TES_PERCENTUAL_REDUCAO_BASE"    , "C", 10, 0 ,""})
                        Aadd(aEstrutura,{"ICMS_LF_V"    , "ICMS_LF_VALOR"                       , "C", 10, 0 ,""})
                        Aadd(aEstrutura,{"ICMS_LF_VI"   , "ICMS_LF_VALOR_ISENTO"                , "C", 10, 0 ,""})
                        Aadd(aEstrutura,{"ICMS_LF_VO"   , "ICMS_LF_VALOR_OUTRO"                 , "C", 10, 0 ,""})
                        Aadd(aEstrutura,{"ICMS_LF_CO"   , "ICMS_LF_VALOR_COMPLEMENTAR"          , "C", 10, 0 ,""})
                        Aadd(aEstrutura,{"ICMS_LF_DI"   , "ICMS_LF_VALOR_DIFERIDO"              , "C", 10, 0 ,""})
                    elseif alltrim(aAcols[nX][2]) == "IPI"
                        Aadd(aCampos,{"IPI",.T.})
                        Aadd(aEstrutura,{"IPI_CST"      , "IPI_CST"                            , "C", 2, 0 ,""})
                        Aadd(aEstrutura,{"IPI_ALIQ"     , "IPI_ALIQUOTA"                       , "N", TamSx3("FT_ALIQIPI")[1], TamSx3("FT_ALIQIPI")[2],""})
                        Aadd(aEstrutura,{"IPI_LF_VB"    , "IPI_LF_VLR_BASE"                    , "C", 10, 0 ,""})
                        Aadd(aEstrutura,{"IPI_LF_V"     , "IPI_LF_VALOR"                       , "C", 10, 0 ,""})
                        Aadd(aEstrutura,{"IPI_LF_VI"    , "IPI_LF_VALOR_ISENTO"                , "C", 10, 0 ,""})
                        Aadd(aEstrutura,{"IPI_LF_VO"    , "IPI_LF_VALOR_OUTRO"                 , "C", 10, 0 ,""})
                    elseif alltrim(aAcols[nX][2]) == "PIS_APUR"
                        Aadd(aCampos,{"PIS_APUR",.T.})
                        Aadd(aEstrutura,{"PIS_CST"      , "PIS_CST"                             , "C", 2, 0 ,""})
                        Aadd(aEstrutura,{"PIS_AP_ALI"   , "PIS_APURACAO_ALIQUOTA"               , "N", TamSx3("FT_ALIQPIS")[1], TamSx3("FT_ALIQPIS")[2],""})
                        Aadd(aEstrutura,{"PIS_AP_VB"    , "PIS_APURACAO_VLR_BASE"               , "C", 10, 0 ,""})
                        Aadd(aEstrutura,{"PIS_AP_V"     , "PIS_APURACAO_VALOR"                  , "C", 10, 0 ,""})
                    elseif alltrim(aAcols[nX][2]) == "COFINS_APUR"
                        Aadd(aCampos,{"COFINS_APUR",.T.})
                        Aadd(aEstrutura,{"COF_CST"      , "COFINS_CST"                          , "C", 2, 0 ,""})
                        Aadd(aEstrutura,{"COF_AP_ALI"   , "COFINS_APURACAO_ALIQUOTA"            , "N", TamSx3("FT_ALIQCOF")[1], TamSx3("FT_ALIQCOF")[2],""})
                        Aadd(aEstrutura,{"COF_AP_VB"    , "COFINS_APURACAO_VLR_BASE"            , "C", 10, 0 ,""})
                        Aadd(aEstrutura,{"COF_AP_V"     , "COFINS_APURACAO_VALOR"               , "C", 10, 0 ,""})
                    elseif alltrim(aAcols[nX][2]) == "CSLL_APUR"
                        Aadd(aCampos,{"CSLL_APUR",.T.})
                        Aadd(aEstrutura,{"CSL_AP_ALI"   , "CSLL_APURACAO_ALIQUOTA"               , "N", TamSx3("FT_ALIQCSL")[1], TamSx3("FT_ALIQCSL")[2],""})
                        Aadd(aEstrutura,{"CSL_AP_VB"    , "CSLL_APURACAO_VLR_BASE"               , "C", 10, 0 ,""})
                        Aadd(aEstrutura,{"CSL_AP_V"     , "CSLL_APURACAO_VALOR"                  , "C", 10, 0 ,""})
                     elseif alltrim(aAcols[nX][2]) == "PIS_RETE"
                        Aadd(aCampos,{"PIS_RETE",.T.})
                        Aadd(aEstrutura,{"PIS_CST"      , "PIS_CST"                             , "C", 2, 0 ,""})
                        Aadd(aEstrutura,{"PIS_RT_ALI"   , "PIS_RETENCAO_ALIQUOTA"               , "N", TamSx3("FT_ARETPIS")[1], TamSx3("FT_ARETPIS")[2],""})
                        Aadd(aEstrutura,{"PIS_RT_VB"    , "PIS_RETENCAO_VLR_BASE"               , "C", 10, 0 ,""})
                        Aadd(aEstrutura,{"PIS_RT_V"     , "PIS_RETENCAO_VALOR"                  , "C", 10, 0 ,""})
                    elseif alltrim(aAcols[nX][2]) == "COFINS_RETE"
                        Aadd(aCampos,{"COFINS_RETE",.T.})
                        Aadd(aEstrutura,{"COF_CST"      , "COFINS_CST"                          , "C", 2, 0 ,""})
                        Aadd(aEstrutura,{"COF_RT_ALI"   , "COFINS_RETENCAO_ALIQUOTA"            , "N", TamSx3("FT_ARETCOF")[1], TamSx3("FT_ARETCOF")[2],""})
                        Aadd(aEstrutura,{"COF_RT_VB"    , "COFINS_RETENCAO_VLR_BASE"            , "C", 10, 0 ,""})
                        Aadd(aEstrutura,{"COF_RT_V"     , "COFINS_RETENCAO_VALOR"               , "C", 10, 0 ,""})
                    elseif alltrim(aAcols[nX][2]) == "CSLL_RETE"
                        Aadd(aCampos,{"CSLL_RETE",.T.})
                        Aadd(aEstrutura,{"CSL_RT_ALI"   , "CSLL_RETENCAO_ALIQUOTA"               , "N", TamSx3("FT_ARETCSL")[1], TamSx3("FT_ARETCSL")[2],""})
                        Aadd(aEstrutura,{"CSL_RT_VB"    , "CSLL_RETENCAO_VLR_BASE"               , "C", 10, 0 ,""})
                        Aadd(aEstrutura,{"CSL_RT_V"     , "CSLL_RETENCAO_VALOR"                  , "C", 10, 0 ,""})                                                                   
                    elseif alltrim(aAcols[nX][2]) == "ISS"
                        Aadd(aCampos,{"ISS",.T.})
                        Aadd(aEstrutura,{"FT_CODISS"    , "FT_CODISS"                           , "C", TamSx3("FT_CODISS")[1]   , TamSx3("FT_CODISS")[2] ,""})
                        Aadd(aEstrutura,{"FT_RECISS"    , "FT_RECISS"                           , "C", TamSx3("FT_RECISS")[1]   , TamSx3("FT_RECISS")[2] ,""})
                        Aadd(aEstrutura,{"FT_CNAE"      , "FT_CNAE"                             , "C", TamSx3("FT_CNAE")[1]     , TamSx3("FT_CNAE")[2]   ,""})
                        Aadd(aEstrutura,{"COD_T_MUNI"   , "COD_TRIB_MUNICIPAL"                  , "C", TamSx3("FT_TRIBMUN")[1]  , TamSx3("FT_TRIBMUN")[2],""})
                        Aadd(aEstrutura,{"ISS_CST"      , "ISS_CST"                             , "C", TamSx3("FT_CSTISS")[1]   , TamSx3("FT_CSTISS")[2] ,""})
                        Aadd(aEstrutura,{"ISS_ALIQ"     , "ISS_ALIQUOTA"                        , "N", TamSx3("FT_ALIQICM")[1]  , TamSx3("FT_ALIQICM")[2],""})
                        Aadd(aEstrutura,{"ISS_LF_VB"    , "ISS_LF_VLR_BASE"                     , "C", 10, 0 ,""})
                        Aadd(aEstrutura,{"ISS_LF_V"     , "ISS_LF_VALOR"                        , "C", 10, 0 ,""})
                    elseif alltrim(aAcols[nX][2]) == "IRRF"
                        Aadd(aCampos,{"IRRF",.T.})
                        Aadd(aEstrutura,{"IRRF_ALIQ"    , "IRRF_ALIQUOTA"                       , "N", TamSx3("FT_ALIQIRR")[1], TamSx3("FT_ALIQIRR")[2],""})
                        Aadd(aEstrutura,{"IRRF_LF_VB"   , "IRRF_LF_VLR_BASE"                    , "C", 10, 0 ,""})
                        Aadd(aEstrutura,{"IRRF_LF_V"    , "IRRF_LF_VALOR"                       , "C", 10, 0 ,""})   
                    elseif alltrim(aAcols[nX][2]) == "INSS"
                        Aadd(aCampos,{"INSS",.T.})
                        Aadd(aEstrutura,{"INSS_ALIQ"    , "INSS_ALIQUOTA"                       , "N", TamSx3("FT_ALIQINS")[1], TamSx3("FT_ALIQINS")[2],""})
                        Aadd(aEstrutura,{"INSS_LF_VB"   , "INSS_LF_VLR_BASE"                    , "C", 10, 0 ,""})
                        Aadd(aEstrutura,{"INSS_LF_V"    , "INSS_LF_VALOR"                       , "C", 10, 0 ,""})   
                    endif

                endif
            next
            
            FwFreeArray(aAcols)
        endif
    ElseIf cTab == 'FINAL'
        Aadd(aCampos,{"QTD_REPETI",.F.}) 
        Aadd(aEstrutura,{"QTD_REPETI"   , "QTD_REPETICOES"                      , "N", 14, 0 ,"FIXO"})
    EndIF


Return

Static Function MontaAgrup(oObjtForm, cSelect, cGroup, cOrder, cJoin)

    Local aAcols    := {}
    Local nX        := 0
    Local nLen      := 0
    Local cRet      := ""

    aAcols:= oObjtForm:oData:aArray
    if len(aAcols)>0
        nLen := len(aAcols[1])
        for nX:=1 to len(aAcols)
            if aAcols[nX][nLen] == "1" //Verifico se o campo está marcado
                cRet := alltrim(aAcols[nX][2])
                if cRet == "NCM"
                    cSelect +=" FT_POSIPI, "
                    cGroup  +=" FT_POSIPI, "
                    cOrder  +=" FT_POSIPI "
                    cJoin   += " "
                elseif cRet ==  "PERFIL_OPER"
                    cSelect +=" F23_CODIGO AS COD_OPER, "
		            cSelect +=" F20_DESC, "
                    cGroup  +=" F23_CODIGO, "
                    cGroup  +=" F20_DESC, "
                    cOrder  +=" F23_CODIGO "

                    cJoin +="    LEFT JOIN ("
                    cJoin +="    SELECT "
                    cJoin +="        F23_CODIGO,F23_CFOP,F20_DESC "
                    cJoin +="    FROM 
                    cJoin +="        "+RetSqlName("F20")+" F20 "
                    cJoin +="    JOIN "
                    cJoin +="        "+RetSqlName("F23")+" F23 	ON F20_CODIGO=F23_CODIGO AND F20_TIPO=F23_TIPOPF AND F23_FILIAL='"+xFilial("F23")+"' AND F23.D_E_L_E_T_=' ' "
                    cJoin +="    WHERE 
                    cJoin +="        F20_FILIAL='"+xFilial("F23")+"' AND F20_DESC NOT LIKE 'TOD%' AND F20.D_E_L_E_T_=' ' "
                    cJoin +="    ) AS F20F23 ON F23_CFOP = FT_CFOP "
                endif

            endif
        next
        
        FwFreeArray(aAcols)
    endif


Return(cRet)

Static Function MontaWhere(oObjtForm, cWhere)
    Local nX        := 0
    Local aAcols    := aClone(oObjtForm:oData:aArray)
    Local lSped     := .F.
    Local lEFD      := .F.
    Local lISS      := .F.

        if len(aAcols)>0
            nLen := len(aAcols[1])
            for nX:=1 to len(aAcols)
                if aAcols[nX][nLen] == "1" //Verifico se o campo está marcado

                    if !lSped .and. alltrim(aAcols[nX][2]) $ ("ICMS/IPI")
                        cWhere += " AND (SFT.FT_ESPECIE <> 'CF' OR (SFT.FT_ESPECIE = 'CF' AND SFT.FT_VALIPI > 0)) "
	                    cWhere += " AND (SFT.FT_ESPECIE <> 'BPR' OR (SFT.FT_ESPECIE = 'BPR' AND SFT.FT_PDV = ' ')) "
                        lSped:= .T.
                    elseif !lEFD .and. alltrim(aAcols[nX][2]) $ "PIS_APUR/COFINS_APUR/CSLL_APUR"
                        cWhere += " AND (FT_TIPOMOV = 'S' AND "
                        cWhere += " (( (SFT.FT_BASEPIS > 0  OR  SFT.FT_BASEPS3 > 0 ) OR SFT.FT_CSTPIS IN ('01','05','07','08','09','49')) OR "
                        cWhere += "     ( (SFT.FT_BASECOF > 0  OR  SFT.FT_BASECF3 > 0 ) OR SFT.FT_CSTCOF IN ('01','05','07','08','09','49')))  AND "
                        cWhere += "     ((SFT.FT_ESPECIE <> 'BPR') OR (SFT.FT_ESPECIE = 'BPR' AND SFT.FT_PDV = ' ')) "
                        cWhere += " ) OR "
                        cWhere += " (FT_TIPOMOV = 'E' AND "
                        cWhere += "     ( "
                        cWhere += "     (F4.F4_ATUATF <> 'S' AND (((SFT.FT_BASEPIS > 0  OR  SFT.FT_BASEPS3 > 0) OR SFT.FT_CSTPIS IN ('70','71','72','73','74','98','99'))  OR "
                        cWhere += "     ((SFT.FT_BASECOF > 0  OR  SFT.FT_BASECF3 > 0) OR SFT.FT_CSTCOF IN ('70','71','72','73','74','98','99')))) OR "
                        cWhere += "     (F4.F4_ATUATF   = 'S' AND ((SFT.FT_CSTCOF IN ('70','71','72','73','74','98','99')) OR "
                        cWhere += "     (SFT.FT_CSTPIS IN ('70','71','72','73','74','98','99')))) "
                        cWhere += " ) "
                        cWhere += " ) "
                        lEFD:= .T.                                    
                    elseif !lISS .and. alltrim(aAcols[nX][2]) == "ISS"
                        cWhere += " AND FT_TIPO='S' "
                        lISS:= .T.
                    endif

                endif
            next
            
            FwFreeArray(aAcols)
        endif

Return

Static Function QueryMov(aCampos, aEstrutura , cSelect, cGroup, cOrder, cJoin , cWhere)
	local cQry          := ""
    local cCamposAdc    := ""
    Local cCampoGroup   := ""
    Local nX            := 0
    Local cTabSFT       := RetSqlName("SFT")
    Local cTabSF4       := RetSqlName("SF4")
    Local cTabSB1       := RetSqlName("SB1")
    Local cTabSA1       := RetSqlName("SA1")
    Local cTabSA2       := RetSqlName("SA2")
    Local cTabSF7       := RetSqlName("SF7")
    Local cFilSFT       := "'"+xFilial("SFT")+"'"
    Local cFilSF4       := "'"+xFilial("SF4")+"'"
    Local cFilSB1       := "'"+xFilial("SB1")+"'"
    Local cFilSA1       := "'"+xFilial("SA1")+"'"
    Local cFilSA2       := "'"+xFilial("SA2")+"'"
    Local cFilSF7       := "'"+xFilial("SF7")+"'"
//  Local cDataDe       := "'"+DtoS(FirstYDate(dDataBase))+"'"
//  Local cDataAte      := "'"+DtoS(LastYDate(dDataBase))+"'"
    Local cDataDe       := "'"+Dtos(dDataDeSFT)+"'"
    Local cDataAte      := "'"+DtoS(dDataAteSFT)+"'"
    Local cIniSelect    := cSelect
    Local cIniGroup     := cGroup
    Local cIniOrder     := iif(empty(cOrder)," 1 ",cOrder)
    

    for nX:=1 to len(aCampos)
        if aCampos[nX][1] == "ICMS"
            cCamposAdc += ", " + "SUBSTRING( FT_CLASFIS, 2, 2 ) AS ICMS_CST"+CHR(13)
            cCamposAdc += ", " + "FT_ALIQICM AS ICMS_ALIQ"+CHR(13)
            cCamposAdc += ", " + "(CASE WHEN FT_BASEICM>0 THEN 'Tem valor' ELSE 'Zerado' END ) AS ICMS_LF_VB"+CHR(13)
            cCamposAdc += ", " + "(CASE WHEN F4_BASEICM>0 THEN 'Tem valor' ELSE 'Zerado' END ) AS ICMS_TES_P"+CHR(13)
            cCamposAdc += ", " + "(CASE WHEN FT_VALICM >0 THEN 'Tem valor' ELSE 'Zerado' END ) AS ICMS_LF_V"+CHR(13)
            cCamposAdc += ", " + "(CASE WHEN FT_ISENICM>0 THEN 'Tem valor' ELSE 'Zerado' END ) AS ICMS_LF_VI"+CHR(13)
            cCamposAdc += ", " + "(CASE WHEN FT_OUTRICM>0 THEN 'Tem valor' ELSE 'Zerado' END ) AS ICMS_LF_VO"+CHR(13)
            cCamposAdc += ", " + "(CASE WHEN FT_ICMSCOM>0 THEN 'Tem valor' ELSE 'Zerado' END ) AS ICMS_LF_CO"+CHR(13)
            cCamposAdc += ", " + "(CASE WHEN FT_ICMSDIF>0 THEN 'Tem valor' ELSE 'Zerado' END ) AS ICMS_LF_DI"+CHR(13)

            cCampoGroup += ", " + "SUBSTRING( FT_CLASFIS, 2, 2 )"+CHR(13)
            cCampoGroup += ", " + "FT_ALIQICM"+CHR(13)
            cCampoGroup += ", " + "(CASE WHEN FT_BASEICM>0 THEN 'Tem valor' ELSE 'Zerado' END )"+CHR(13)
            cCampoGroup += ", " + "(CASE WHEN F4_BASEICM>0 THEN 'Tem valor' ELSE 'Zerado' END )"+CHR(13)
            cCampoGroup += ", " + "(CASE WHEN FT_VALICM >0 THEN 'Tem valor' ELSE 'Zerado' END )"+CHR(13)
            cCampoGroup += ", " + "(CASE WHEN FT_ISENICM>0 THEN 'Tem valor' ELSE 'Zerado' END )"+CHR(13)
            cCampoGroup += ", " + "(CASE WHEN FT_OUTRICM>0 THEN 'Tem valor' ELSE 'Zerado' END )"+CHR(13)
            cCampoGroup += ", " + "(CASE WHEN FT_ICMSCOM>0 THEN 'Tem valor' ELSE 'Zerado' END )"+CHR(13)
            cCampoGroup += ", " + "(CASE WHEN FT_ICMSDIF>0 THEN 'Tem valor' ELSE 'Zerado' END )"
        elseif aCampos[nX][1] == "IPI"
            cCamposAdc += ", " + "FT_CTIPI AS IPI_CST"+CHR(13)
            cCamposAdc += ", " + "FT_ALIQIPI AS IPI_ALIQ"+CHR(13)
            cCamposAdc += ", " + "(CASE WHEN FT_BASEIPI>0 THEN 'Tem valor' ELSE 'Zerado' END ) AS IPI_LF_VB"+CHR(13)
            cCamposAdc += ", " + "(CASE WHEN FT_VALIPI >0 THEN 'Tem valor' ELSE 'Zerado' END ) AS IPI_LF_V"+CHR(13)
            cCamposAdc += ", " + "(CASE WHEN FT_ISENIPI>0 THEN 'Tem valor' ELSE 'Zerado' END ) AS IPI_LF_VI"+CHR(13)
            cCamposAdc += ", " + "(CASE WHEN FT_OUTRIPI>0 THEN 'Tem valor' ELSE 'Zerado' END ) AS IPI_LF_VO"+CHR(13)

            cCampoGroup += ", " + "FT_CTIPI"+CHR(13)
            cCampoGroup += ", " + "FT_ALIQIPI"+CHR(13)
            cCampoGroup += ", " + "(CASE WHEN FT_BASEIPI>0 THEN 'Tem valor' ELSE 'Zerado' END )"+CHR(13)
            cCampoGroup += ", " + "(CASE WHEN FT_VALIPI >0 THEN 'Tem valor' ELSE 'Zerado' END )"+CHR(13)
            cCampoGroup += ", " + "(CASE WHEN FT_ISENIPI>0 THEN 'Tem valor' ELSE 'Zerado' END )"+CHR(13)
            cCampoGroup += ", " + "(CASE WHEN FT_OUTRIPI>0 THEN 'Tem valor' ELSE 'Zerado' END )"+CHR(13)

        elseif aCampos[nX][1] == "PIS_APUR"
            cCamposAdc += ", " + "FT_CSTPIS AS PIS_CST"+CHR(13)
		    cCamposAdc += ", " + "FT_ALIQPIS AS PIS_AP_ALI"+CHR(13)
		    cCamposAdc += ", " + "(CASE WHEN FT_BASEPIS>0 THEN 'Tem valor' ELSE 'Zerado' END ) AS PIS_AP_VB"+CHR(13)
		    cCamposAdc += ", " + "(CASE WHEN FT_VALPIS >0 THEN 'Tem valor' ELSE 'Zerado' END ) AS PIS_AP_V"+CHR(13)

            cCampoGroup += ", " + "FT_CSTPIS"+CHR(13)
		    cCampoGroup += ", " + "FT_ALIQPIS"+CHR(13)
		    cCampoGroup += ", " + "(CASE WHEN FT_BASEPIS>0 THEN 'Tem valor' ELSE 'Zerado' END )"+CHR(13)
		    cCampoGroup += ", " + "(CASE WHEN FT_VALPIS >0 THEN 'Tem valor' ELSE 'Zerado' END )"+CHR(13)
        elseif aCampos[nX][1] == "COFINS_APUR"
            cCamposAdc += ", " + "FT_CSTCOF AS COF_CST"+CHR(13)
		    cCamposAdc += ", " + "FT_ALIQCOF AS COF_AP_ALI"+CHR(13)
		    cCamposAdc += ", " + "(CASE WHEN FT_BASECOF>0 THEN 'Tem valor' ELSE 'Zerado' END ) AS COF_AP_VB"+CHR(13)
		    cCamposAdc += ", " + "(CASE WHEN FT_VALCOF >0 THEN 'Tem valor' ELSE 'Zerado' END ) AS COF_AP_V"+CHR(13)

            cCampoGroup += ", " + "FT_CSTCOF"+CHR(13)
		    cCampoGroup += ", " + "FT_ALIQCOF"+CHR(13)
		    cCampoGroup += ", " + "(CASE WHEN FT_BASECOF>0 THEN 'Tem valor' ELSE 'Zerado' END )"+CHR(13)
		    cCampoGroup += ", " + "(CASE WHEN FT_VALCOF >0 THEN 'Tem valor' ELSE 'Zerado' END )"+CHR(13)
        elseif aCampos[nX][1] == "CSLL_APUR"
		    cCamposAdc += ", " + "FT_ALIQCSL AS CSL_AP_ALI"+CHR(13)
		    cCamposAdc += ", " + "(CASE WHEN FT_BASECSL>0 THEN 'Tem valor' ELSE 'Zerado' END ) AS CSL_AP_VB"+CHR(13)
		    cCamposAdc += ", " + "(CASE WHEN FT_VALCSL >0 THEN 'Tem valor' ELSE 'Zerado' END ) AS CSL_AP_V"+CHR(13)

		    cCampoGroup += ", " + "FT_ALIQCSL"+CHR(13)
		    cCampoGroup += ", " + "(CASE WHEN FT_BASECSL>0 THEN 'Tem valor' ELSE 'Zerado' END )"+CHR(13)
		    cCampoGroup += ", " + "(CASE WHEN FT_VALCSL >0 THEN 'Tem valor' ELSE 'Zerado' END )"+CHR(13)
        elseif aCampos[nX][1] == "PIS_RETE"
            cCamposAdc += ", " + "FT_CSTPIS AS PIS_CST"+CHR(13)
		    cCamposAdc += ", " + "FT_ARETPIS AS PIS_RT_ALI"+CHR(13)
		    cCamposAdc += ", " + "(CASE WHEN FT_BRETPIS>0 THEN 'Tem valor' ELSE 'Zerado' END ) AS PIS_RT_VB"+CHR(13)
		    cCamposAdc += ", " + "(CASE WHEN FT_VRETPIS>0 THEN 'Tem valor' ELSE 'Zerado' END ) AS PIS_RT_V"+CHR(13)

            cCampoGroup += ", " + "FT_CSTPIS"+CHR(13)
		    cCampoGroup += ", " + "FT_ARETPIS"+CHR(13)
		    cCampoGroup += ", " + "(CASE WHEN FT_BRETPIS>0 THEN 'Tem valor' ELSE 'Zerado' END )"+CHR(13)
		    cCampoGroup += ", " + "(CASE WHEN FT_VRETPIS>0 THEN 'Tem valor' ELSE 'Zerado' END )"+CHR(13)
        elseif aCampos[nX][1] == "COFINS_RETE"
            cCamposAdc += ", " + "FT_CSTCOF AS COF_CST"+CHR(13)
		    cCamposAdc += ", " + "FT_ARETCOF AS COF_RT_ALI"+CHR(13)
		    cCamposAdc += ", " + "(CASE WHEN FT_BRETCOF>0 THEN 'Tem valor' ELSE 'Zerado' END ) AS COF_RT_VB"+CHR(13)
		    cCamposAdc += ", " + "(CASE WHEN FT_VRETCOF>0 THEN 'Tem valor' ELSE 'Zerado' END ) AS COF_RT_V"+CHR(13)

            cCampoGroup += ", " + "FT_CSTCOF"+CHR(13)
		    cCampoGroup += ", " + "FT_ARETCOF"+CHR(13)
		    cCampoGroup += ", " + "(CASE WHEN FT_BRETCOF>0 THEN 'Tem valor' ELSE 'Zerado' END )"+CHR(13)
		    cCampoGroup += ", " + "(CASE WHEN FT_VRETCOF >0 THEN 'Tem valor' ELSE 'Zerado' END )"+CHR(13)
        elseif aCampos[nX][1] == "CSLL_RETE"
		    cCamposAdc += ", " + "FT_ARETCSL AS CSL_RT_ALI"+CHR(13)
		    cCamposAdc += ", " + "(CASE WHEN FT_BRETCSL>0 THEN 'Tem valor' ELSE 'Zerado' END ) AS CSL_RT_VB"+CHR(13)
		    cCamposAdc += ", " + "(CASE WHEN FT_VRETCSL>0 THEN 'Tem valor' ELSE 'Zerado' END ) AS CSL_RT_V"+CHR(13)

		    cCampoGroup += ", " + "FT_ARETCSL"+CHR(13)
		    cCampoGroup += ", " + "(CASE WHEN FT_BRETCSL>0 THEN 'Tem valor' ELSE 'Zerado' END )"+CHR(13)
		    cCampoGroup += ", " + "(CASE WHEN FT_VRETCSL>0 THEN 'Tem valor' ELSE 'Zerado' END )"+CHR(13)
        elseif aCampos[nX][1] == "ISS"
		    cCamposAdc += ", " + "FT_CODISS"+CHR(13)
            cCamposAdc += ", " + "FT_RECISS"+CHR(13)
            cCamposAdc += ", " + "FT_CNAE"+CHR(13)
            cCamposAdc += ", " + "FT_TRIBMUN AS COD_T_MUNI"+CHR(13)
            cCamposAdc += ", " + "FT_CSTISS AS ISS_CST"+CHR(13)
            cCamposAdc += ", " + "FT_ALIQICM AS ISS_ALIQ"+CHR(13)
		    cCamposAdc += ", " + "(CASE WHEN FT_BASEICM>0 THEN 'Tem valor' ELSE 'Zerado' END ) AS ISS_LF_VB"+CHR(13)
		    cCamposAdc += ", " + "(CASE WHEN FT_VALICM>0 THEN 'Tem valor' ELSE 'Zerado' END ) AS ISS_LF_V"+CHR(13)

		    cCampoGroup += ", " + "FT_CODISS"+CHR(13)
            cCampoGroup += ", " + "FT_RECISS"+CHR(13)
            cCampoGroup += ", " + "FT_CNAE"+CHR(13)
            cCampoGroup += ", " + "FT_TRIBMUN"+CHR(13)
            cCampoGroup += ", " + "FT_CSTISS"+CHR(13)
            cCampoGroup += ", " + "FT_ALIQICM"+CHR(13)
		    cCampoGroup += ", " + "(CASE WHEN FT_BASEICM>0 THEN 'Tem valor' ELSE 'Zerado' END )"+CHR(13)
		    cCampoGroup += ", " + "(CASE WHEN FT_VALICM>0 THEN 'Tem valor' ELSE 'Zerado' END )"+CHR(13)
        elseif aCampos[nX][1] == "IRRF"
            cCamposAdc += ", " + "FT_ALIQIRR AS IRRF_ALIQ"+CHR(13)
		    cCamposAdc += ", " + "(CASE WHEN FT_BASEIRR>0 THEN 'Tem valor' ELSE 'Zerado' END ) AS IRRF_LF_VB"+CHR(13)
		    cCamposAdc += ", " + "(CASE WHEN FT_VALIRR>0 THEN 'Tem valor' ELSE 'Zerado' END ) AS IRRF_LF_V"+CHR(13)

            cCampoGroup += ", " + "FT_ALIQIRR"+CHR(13)
		    cCampoGroup += ", " + "(CASE WHEN FT_BASEIRR>0 THEN 'Tem valor' ELSE 'Zerado' END )"+CHR(13)
		    cCampoGroup += ", " + "(CASE WHEN FT_VALIRR >0 THEN 'Tem valor' ELSE 'Zerado' END )"+CHR(13)
        elseif aCampos[nX][1] == "INSS"
            cCamposAdc += ", " + "FT_ALIQINS AS INSS_ALIQ"+CHR(13)
		    cCamposAdc += ", " + "(CASE WHEN FT_BASEINS>0 THEN 'Tem valor' ELSE 'Zerado' END ) AS INSS_LF_VB"+CHR(13)
		    cCamposAdc += ", " + "(CASE WHEN FT_VALINS>0 THEN 'Tem valor' ELSE 'Zerado' END ) AS INSS_LF_V"+CHR(13)

            cCampoGroup += ", " + "FT_ALIQINS"+CHR(13)
		    cCampoGroup += ", " + "(CASE WHEN FT_BASEINS>0 THEN 'Tem valor' ELSE 'Zerado' END )"+CHR(13)
		    cCampoGroup += ", " + "(CASE WHEN FT_VALINS >0 THEN 'Tem valor' ELSE 'Zerado' END )"+CHR(13)
        else
            if aCampos[nX][2]//empty(aEstrutura[nX][6]) //para não adicionar de novo os campos fixos
                cCamposAdc += ", "+CHR(13)+ aCampos[nX][1]
                cCampoGroup += ", "+CHR(13)+ aCampos[nX][1]
            endif
        endif
    next

    cCamposAdc += ", " + "COUNT(*) AS QTD_REPETI"+CHR(13)

	BEGINCONTENT var cQry
            SELECT  %Exp:cIniSelect%
                FT_ESTADO,
                FT_TIPO,
                FT_TIPOMOV,
                FT_CFOP,
                FT_CFPS,
                FT_CLIEFOR,
                FT_LOJA,
                FT_CLIENT,
                SUBSTRING( FT_CLASFIS, 1, 1 )AS ORIGEM,
                (CASE WHEN FT_VALCONT>0 THEN 'Tem valor' ELSE 'Zerado' END ) AS FT_VALCONT,
                FT_ESPECIE,
                FT_PRODUTO,
                FT_TES
                %Exp:cCamposAdc%
            FROM 
                %Exp:cTabSFT% SFT
            %Exp:cJoin%
            INNER JOIN 
                %Exp:cTabSF4% F4 ON F4.F4_FILIAL=%Exp:cFilSF4% AND F4.F4_CODIGO=SFT.FT_TES AND F4.D_E_L_E_T_=' '
            INNER JOIN 
                %Exp:cTabSB1% B1 ON B1.B1_FILIAL=%Exp:cFilSB1% AND B1.B1_COD = FT_PRODUTO AND B1.D_E_L_E_T_=' '
            LEFT JOIN 
                %Exp:cTabSA1% SA1
                    ON SA1.A1_FILIAL=%Exp:cFilSA1% AND SA1.A1_COD = FT_CLIEFOR
                    AND SA1.A1_LOJA = FT_LOJA
                    AND SA1.D_E_L_E_T_ = ' '
                    AND (FT_TIPOMOV = 'S' OR (FT_TIPOMOV = 'E' AND FT_TIPO IN ('DB')))
            LEFT JOIN 
                %Exp:cTabSA2% SA2
                    ON SA2.A2_FILIAL=%Exp:cFilSA2% AND SA2.A2_COD = FT_CLIEFOR
                    AND SA2.A2_LOJA = FT_LOJA
                    AND SA2.D_E_L_E_T_ = ' '
                    AND (FT_TIPOMOV = 'E' OR (FT_TIPOMOV = 'S' AND FT_TIPO IN ('DB')))
            LEFT JOIN 
                %Exp:cTabSF7% F7 
                    ON F7.F7_FILIAL = %Exp:cFilSF7% AND F7.F7_GRTRIB = B1.B1_GRTRIB AND F7.F7_EST = SFT.FT_ESTADO
                    AND F7_GRPCLI = (CASE WHEN F7_GRPCLI <> '' THEN 
                                    (CASE WHEN (FT_TIPOMOV = 'S' OR (FT_TIPOMOV = 'E' AND FT_TIPO IN ('DB'))) THEN SA1.A1_GRPTRIB ELSE SA2.A2_GRPTRIB END) 
                                    ELSE '' END)
                    AND F7.D_E_L_E_T_ = ' '
            WHERE 
                SFT.FT_FILIAL=%Exp:cFilSFT%
                AND SFT.FT_ENTRADA BETWEEN %Exp:cDataDe% AND %Exp:cDataAte%
                %Exp:cWhere%
                AND SFT.D_E_L_E_T_ = ' '
            GROUP BY
                %Exp:cIniGroup%
                FT_ESTADO,
                FT_TIPO,
                FT_TIPOMOV,
                FT_CFOP,
                FT_CFPS,
                FT_CLIEFOR,
                FT_LOJA,
                FT_CLIENT,
                SUBSTRING(FT_CLASFIS, 1, 1),
                /* FT_VALCONT*/
                (CASE WHEN FT_VALCONT>0 THEN 'Tem valor' ELSE 'Zerado' END ),
                FT_ESPECIE,
                FT_PRODUTO,
                FT_TES
                /*ICMS_CST*/
                %Exp:cCampoGroup%
                
            ORDER BY %Exp:cIniOrder%

	ENDCONTENT

return cQry

Static Function GeraExcel(aCampos, aEstrutura, oSay, cSelect, cGroup, cOrder , cJoin, cWhere)
    Local cTitAux   := "Operações Fiscais"
    Local cQuery    := changeQuery(QueryMov(aCampos, aEstrutura, cSelect, cGroup, cOrder, cJoin, cWhere))

    Default cQryAux := ""

    //conout("--------------------------------------------->")
    //conout(cQuery)
    //conout("--------------------------------------------->")
    AtualizaMsg( oSay, "Processamento dados da query!")
    MontaExcel(cQuery, cTitAux, aEstrutura, oSay)

Return
 
Static Function MontaExcel(cQuery, cTitAux, aEstrutura, oSay)
    Local aArea       := GetArea()
    Local nAux        := 0
    Local oFWMsExcel
    Local oExcel
    Local cDiretorio  := GetTempPath()
    Local cArquivo    := 'Rel_operacoes_fiscais.xml'
    Local cArqFull    := cDiretorio + cArquivo
    Local cWorkSheet  := "Aba - Principal"
    Local cTable      := ""
    Local aColunas    := {}
    Local aLinhaAux   := {}
    Local cTitulo     := ""
    Local nTotal      := 0
    Local nAtual      := 0
    Local oQryImp     := NIL
    Local cAliasQry   := "" 
    Default cQuery   := ""
    Default cTitAux   := "Título"
     
    cTable := cTitAux
     
    //Se tiver a consulta
    If !Empty(cQuery)

        Memowrite('C:\TEMP\'+FunName()+ProcName()+'.SQL',cQuery)

        oQryImp := FwExecStatement():New(cQuery)
        cAliasQry := oQryImp:OpenAlias()
        
        nTotal := (cAliasQry)->(LastRec())

        For nAux := 1 To Len(aEstrutura)
            cTitulo := ""
             
            if aEstrutura[nAux][3] == "D"
                TCSetField(cAliasQry, aEstrutura[nAux][3], "D")
            endif
            cTitulo := Alltrim(aEstrutura[nAux][2])

            //Adicionando nas colunas
            aAdd(aColunas, cTitulo)
        Next
          
        //Criando o objeto que irá gerar o conteúdo do Excel
        oFWMsExcel := FWMSExcel():New()
        oFWMsExcel:AddworkSheet(cWorkSheet)
        oFWMsExcel:AddTable(cWorkSheet, cTable,.F.)
            
        //Adicionando as Colunas
        For nAux := 1 To Len(aColunas)
            oFWMsExcel:AddColumn(cWorkSheet, cTable, aColunas[nAux], 1, 1)
        Next
            
        //Definindo o total da barra
        DbSelectArea(cAliasQry)
        nAtual := 0

        While !(cAliasQry)->(EoF())
            nAtual++
            AtualizaMsg( oSay, "Processando registro "+cValToChar(nAtual)+" de "+cValToChar(nTotal)+"...")
            //Criando a linha
            aLinhaAux := Array(Len(aColunas))
            For nAux := 1 To Len(aEstrutura)
                aLinhaAux[nAux] := &("(cAliasQry)->"+aEstrutura[nAux][1])
            Next
                
            //Adiciona a linha no Excel
            oFWMsExcel:AddRow(cWorkSheet, cTable, aLinhaAux)
                
            (cAliasQry)->(DbSkip())
        EndDo
              
        //Ativando o arquivo e gerando o xml
        oFWMsExcel:Activate()
        oFWMsExcel:GetXMLFile(cArqFull)
         
        //Se tiver o excel instalado
        If ApOleClient("msexcel")
            oExcel := MsExcel():New()
            oExcel:WorkBooks:Open(cArqFull)
            oExcel:SetVisible(.T.)
            oExcel:Destroy()         
        EndIf
          
        (cAliasQry)->(DbCloseArea())
    EndIf
    oQryImp:Destroy()
    oQryImp:= Nil
    RestArea(aArea)
Return
