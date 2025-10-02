#INCLUDE "PROTHEUS.CH"

User Function MsExplorer()
Local oDlg		:= Nil
Local oExpl		:= Nil
Local aPanels	:= {}

//	Instancia Objeto
	oExpl := MsExplorer():New("Titulo da MsExplorer",10,10,400,700,oDlg,/*lToolBar*/,/*lAddressBar*/,/*lDefBar*/,/*oTreeFont*/,/*cBitmap*/,/*nBmpWidth*/,/*oParent*/)//Cria EnchoiceButtons
	oExpl:AddDefButton("CLIPS"		,"ToolTip 01"	,{|| MsgInfo("Botao ZeroUm"		,"Titulo") }	,/*cDefaultAct*/	,/*bWhen*/,/*nWidth*/,"Botao Zero Um - 01")
	oExpl:AddDefButton("CLIENTE"	,"ToolTip 02"	,{|| MsgInfo("Botao ZeroDois"	,"Titulo") }	,/*cDefaultAct*/	,/*bWhen*/,/*nWidth*/,"Botao Zero Um - 02")
	oExpl:AddDefButton("CHAT"		,"ToolTip 03"	,{|| MsgInfo("Botao ZeroTres"	,"Titulo") }	,/*cDefaultAct*/	,/*bWhen*/,/*nWidth*/,"Botao Zero Um - 03")
	oExpl:AddDefButton("COMSOM"		,"ToolTip 04"	,{|| MsgInfo("Botao ZeroQuatro"	,"Titulo") }	,/*cDefaultAct*/	,/*bWhen*/,/*nWidth*/,"Botao Zero Um - 04")
	oExpl:AddDefButton("CARGA"		,"ToolTip 04"	,{|| MsgInfo("Botao ZeroCinco"	,"Titulo") }	,/*cDefaultAct*/	,/*bWhen*/,/*nWidth*/,"Botao Zero Um - 05")
	
//	Cria um item da Arvore
	
	aAdd(aPanels,    oExpl:AddTree("Item01","BR_LARANJA"	,"BR_VERDE","#1000",.T.))

//	Cria itens na Arvore
	aAdd(aPanels,    oExpl:AddItem("S1.1"	,"BR_ROXO" ,"#1100",.T.))
	aAdd(aPanels,    oExpl:AddItem("S1.2"	,"BR_ROXO" ,"#1200",.T.))//Adiciona um sub-item composto na Arvore
	aAdd(aPanels,    oExpl:AddTree("S1.3"	,"BR_PRETO","BR_BRANCO","#1300",.T.))
	aAdd(aPanels,    oExpl:AddItem("S1.3.1"	,"BR_ROXO" ,"#1310",.T.))
	aAdd(aPanels,    oExpl:AddItem("S1.3.2"	,"BR_ROXO" ,"#1320",.T.))
	aAdd(aPanels,    oExpl:AddItem("S1.3.3"	,"BR_ROXO" ,"#1330",.T.))

	oExpl:EndTree() // Fecha subitem
	oExpl:EndTree() // Fecha item
	
//	Cria um novo item da Arvore
	aAdd(aPanels,    oExpl:AddTree("Item02","BR_LARANJA"	,"BR_VERDE","#2000",.T.))
	aAdd(aPanels,    oExpl:AddItem("S2.1","BR_ROXO","#2100",.T.))
	aAdd(aPanels,    oExpl:AddItem("S2.2","BR_ROXO","#2200",.T.))
	oExpl:EndTree() //Fecha Item
	
//	Desenha nos paineis de cada item
	@50,50 SAY "SELECIONOU A OPCAO: Item01"	PIXEL SIZE 150,25 OF oExpl:GetPanel(aPanels[ 1])
	@50,50 SAY "SELECIONOU A OPCAO: S1.1" 	PIXEL SIZE 150,25 OF oExpl:GetPanel(aPanels[ 2])
	@50,50 SAY "SELECIONOU A OPCAO: S1.2" 	PIXEL SIZE 150,25 OF oExpl:GetPanel(aPanels[ 3])
	@50,50 SAY "SELECIONOU A OPCAO: S1.3" 	PIXEL SIZE 150,25 OF oExpl:GetPanel(aPanels[ 4])
	@50,50 SAY "SELECIONOU A OPCAO: S1.3.1"	PIXEL SIZE 150,25 OF oExpl:GetPanel(aPanels[ 5])
	@50,50 SAY "SELECIONOU A OPCAO: S1.3.2"	PIXEL SIZE 150,25 OF oExpl:GetPanel(aPanels[ 6])
	@50,50 SAY "SELECIONOU A OPCAO: S1.3.3"	PIXEL SIZE 150,25 OF oExpl:GetPanel(aPanels[ 7])
	@50,50 SAY "SELECIONOU A OPCAO: Item02"	PIXEL SIZE 150,25 OF oExpl:GetPanel(aPanels[ 8])
	@50,50 SAY "SELECIONOU A OPCAO: S2.1" 	PIXEL SIZE 150,25 OF oExpl:GetPanel(aPanels[ 9])
	@50,50 SAY "SELECIONOU A OPCAO: S2.2" 	PIXEL SIZE 150,25 OF oExpl:GetPanel(aPanels[10])
	
//	Exibe a MsExplorer                                                                
	oExpl:Activate(.T.)

Return
