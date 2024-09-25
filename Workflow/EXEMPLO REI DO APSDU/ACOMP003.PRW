#include "rwmake.ch"        
#include "TbiConn.ch"
#include "TbiCode.ch"
#include "protheus.ch"
#INCLUDE "topconn.ch"


USER function ACOMP003( nOpcao, oProcess )
 
Private bXMSAPRO 	:= SuperGetMV("MV_XMSAPRO")
Private cxFilial 	:= ""
Private cCodLiber	:="000000"
Private cNivelApr	:="" 
Private lLiberou    := .F.

	Conout(" ( WF APROVAÇÃO) Data: "+dtoc(ddatabase)+ "Hora: "+time()+"Inicio Validação de Empresa")	

	
	if valtype(bXMSAPRO) != "L"
		Aviso("Atenção","Parametro MV_XMSAPRO cadastrado errado, verifique se o tipo e valor é LOGICO! O E-mai de WORKFLOW não será enviado!",{"OK"})	
		Return
	endif
    If ValType(nOpcao) = "A" 
      nOpcao := nOpcao[1]
    Endif  
                                 
	If nOpcao == NIL
		nOpcao := 0
	End

    ConOut("Opcao:")
    ConOut(nOpcao)
    
	If oProcess == NIL
		oProcess := TWFProcess():New( "PEDCOM", "Pedido de Compras" )
	End
  
	Conout(" ( WF APROVAÇÃO) Data: "+dtoc(ddatabase)+ "Hora: "+time()+" Passou por oProcess := TWFProcess():New( PEDCOM, Pedido de Compras ) ")	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
	//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
	//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
	//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	SetPrvt("CPAR,NBARRA,N_ITEM,C_MAT,C_DEST,CGRAP")
	SetPrvt("C_NUM,C_MOTIVO,N_TOTPC,CGRAPANT,N_TERMINA,N_DOHTML")
	SetPrvt("CRAIZ,NRET,NHLDHTM,NHLDSCP,CIND,C_PCANT")
	SetPrvt("N_QTDPC,N_FRTPC,A_ITENS,LCABEC,_AREGISTROS,NLIMITE")
	SetPrvt("CAB_NUM,CAB_EMIS,CAB_FORN,CAB_COND,CAB_NOME,_NI")
	SetPrvt("ARRAYCAB,ARRAYITENS,C_ITPED,NPRESUP,CAPROV,AINFO")
	SetPrvt("CMAILAP,CNOMEAP,CORIGEM,CABEC,NHDLVLR,NCOUNT")
	SetPrvt("NRESULT,CHTML,NHDLCONNECT")

	Conout(" ( WF APROVAÇÃO) Data: "+dtoc(ddatabase)+ "Hora: "+time()+" Vai entrar no Tipo De Opção: "+ alltrim(str(nOpcao)) )	

	Do Case
		Case nOpcao == 0
			Conout(" ( WF APROVAÇÃO) Data: "+dtoc(ddatabase)+ "Hora: "+time()+" Entrando no SPCIniciar" )	
			SPCIniciar( oProcess )                                                                        
			Conout(" ( WF APROVAÇÃO) Data: "+dtoc(ddatabase)+ "Hora: "+time()+" Saiu no SPCIniciar" )	
		Case nOpcao == 1
			Conout(" ( WF APROVAÇÃO) Data: "+dtoc(ddatabase)+ "Hora: "+time()+" Entrando no SPCRetorno")	
			SPCRetorno( oProcess )                                                                     
			Conout(" ( WF APROVAÇÃO) Data: "+dtoc(ddatabase)+ "Hora: "+time()+" Saiu no SPCRetorno")
		Case nOpcao == 2
		  Conout(" ( WF APROVAÇÃO) Data: "+dtoc(ddatabase)+ "Hora: "+time()+" Entrando no SPCTimeOut")
			SPCTimeOut( oProcess )                                                                      
			Conout(" ( WF APROVAÇÃO) Data: "+dtoc(ddatabase)+ "Hora: "+time()+" Saiu no SPCTimeOut")
	
	End
	Conout(" ( WF APROVAÇÃO) Data: "+dtoc(ddatabase)+ "Hora: "+time()+" Saiu do Tipo Opção: "+ alltrim(str(nOpcao)) )	

	oProcess:Free()	
RETURN		

/*Faz a Liberação Automática do Pedido*/
Static Function SPCRetorno( oProcess )
   
  cTipo:="PC" 	
 
  Conout("INICIO DE RETORNO WF APROVAÇÃO ( WF APROVAÇÃO) Data: "+dtoc(ddatabase)+ "Hora: "+time()+" Iniciando 1002  ")	
			
  RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'10002',,"BI")
  ConOut('Filial'+oProcess:oHtml:RetByName('Filial')+'Pedido No:'+oProcess:oHtml:RetByName('Pedido'))
  cNum:=alltrim(oProcess:oHtml:RetByName('Pedido'))
  cxFilial:=oProcess:oHtml:RetByName('FILIAL')                 
  cResp:=oProcess:oHtml:RetByName('RBAPROVA')               
  cJusti:=oProcess:oHtml:RetByName('lbmotivo')
  codAprov:=oProcess:oHtml:RetByName("lb_aprovador") 
  Conout("INICIO DE RETORNO WF APROVAÇÃO ( WF APROVAÇÃO) Data: "+dtoc(ddatabase)+ "Hora: "+time()+" codAprov1: "+ codAprov)	
  codAprov:=substr(codAprov,7,6)
  Conout("INICIO DE RETORNO WF APROVAÇÃO ( WF APROVAÇÃO) Data: "+dtoc(ddatabase)+ "Hora: "+time()+" codAprov2: "+ codAprov)	
   	         

  dbSelectArea("SC7")
  SC7->(dbSetOrder(1)) 
  SC7->(dbgotop())   
  
  if SC7->(dbSeek(cxFilial+cNum))

	cGrupo := SC7->C7_APROV
	cPCLib := SC7->C7_NUM
	cPCUser:= SC7->C7_USER
	Conout("RETORNO WF APROVAÇÃO ( WF APROVAÇÃO) Data: "+dtoc(ddatabase)+ "Hora: "+time()+" Grupo"+cGrupo+" cPCLib: "+ cPCLib +" cPCUser: "+cPCUser)
  else
  	Conout("INICIO DE RETORNO WF APROVAÇÃO ( WF APROVAÇÃO) Data: "+dtoc(ddatabase)+ "Hora: "+time()+" Não achou SC7 (1) cxFilial+cNum: "+ cxFilial+cNum)	
  endif
                                                                                                       
  If Select("SC7") > 0 
	SC7->(dbCloseArea()) 
  EndIf 
  
  Conout("( WF APROVAÇÃO) Data: "+dtoc(ddatabase)+ "Hora: "+time()+" cResp: " + cResp)

  if cResp == '1'
    nOpc:=2 //Libera
  else  
    nOpc:=3 //Bloqueia  
  endif
  Conout("( WF APROVAÇÃO) Data: "+dtoc(ddatabase)+ "Hora: "+time()+" cResp: " + cResp+" nOpc: "+alltrim(str(nOpc)))

  Conout("( WF APROVAÇÃO) Data: "+dtoc(ddatabase)+ "Hora: "+time()+" Vai entrar no WHILE DO SCR CHAVE:"+cxFilial+cTipo+cNum+codAprov)	  
  dbSelectArea("SCR")
  SCR->(dbSetOrder(2))
  SCR->(dbgotop())
 
  if SCR->(dbSeek(cxFilial+cTipo+cNum))
    Conout("( WF APROVAÇÃO) Data: "+dtoc(ddatabase)+ "Hora: "+time()+" Vai entrar no if SCR->(dbSeek(cxFilial+cTipo+cNum)):"+cxFilial+cTipo+cNum)	  
  
		  Conout("RETORNO WF APROVAÇÃO ( WF APROVAÇÃO) Data: "+dtoc(ddatabase)+ "Hora: "+time()+" Entrou no !SCR->(EOF()) .AND. cxFilial == SCR->CR_FILIAL .AND. cNum == SCR->CR_NUM"+ cxFilial+"X"+SCR->CR_FILIAL+"X"+cNum+"X"+SCR->CR_NUM )

	while !SCR->(EOF()) .AND. alltrim(cxFilial) == alltrim(SCR->CR_FILIAL) .AND. alltrim(cNum) == alltrim(SCR->CR_NUM)
	                     
		  Conout("RETORNO WF APROVAÇÃO ( WF APROVAÇÃO) Data: "+dtoc(ddatabase)+ "Hora: "+time()+" Entrou no while !SCR->(EOF()) .AND. cxFilial == SCR->CR_FILIAL .AND. cNum == SCR->CR_NUM" )

		  Conout("RETORNO WF APROVAÇÃO ( WF APROVAÇÃO) Data: "+dtoc(ddatabase)+ "Hora: "+time()+" Entrou no codAprov == SCR->CR_USER"+codAprov == SCR->CR_USER )
	
		  if codAprov == SCR->CR_USER 
			  
			  	Conout("RETORNO WF APROVAÇÃO ( WF APROVAÇÃO) Data: "+dtoc(ddatabase)+ "Hora: "+time()+" Entrou no if codAprov == SCR->CR_USER" )
		   
		        nTotal    := SCR->CR_TOTAL
		        cAprov    := SCR->CR_APROV
		        cCodLiber	:=SCR->CR_USER
		        cNivelApr	:=SCR->CR_NIVEL  	      
		        //lLiberou := MaAlcDoc({cNum,cTipo,nTotal,cAprov,,cGrupo,,,,,cJusti},date(),If(nOpc==2,4,6))  
			    Conout("( WF APROVAÇÃO) Data: "+dtoc(ddatabase)+ "Hora: "+time()+" Iniciando a função de Liberação/Bloqueio ") 
			    Conout("( WF APROVAÇÃO) Data: "+dtoc(ddatabase)+ "Hora: "+time()+" Aprovado:  "+cAprov+" Grupo: "+cGrupo+" Justificativa: "+cJusti) 
			        
					
			        //lLiberou := MaAlcDoc({SCR->CR_NUM,"PC",SCR->CR_TOTAL,SCR->CR_APROV,,},dDatabase,If(nOpc==2,4,6))
   			        lLiberou := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,SCR->CR_TOTAL,cAprov,,cGrupo,,,,,cJusti},date(),If(nOpc==2,4,6))
			    
			    if lLiberou
					  Conout("( WF APROVAÇÃO) Data: "+dtoc(ddatabase)+ "Hora: "+time()+" Fim da função de Liberação/Bloqueio (LIBEROU)")
				else
				    Conout("( WF APROVAÇÃO) Data: "+dtoc(ddatabase)+ "Hora: "+time()+" Fim da função de Liberação/Bloqueio (BLOQUEOU)")
				endif
			  exit
	      endif
	      SCR->(dbskip())
	enddo      
  else
  	Conout("RETORNO WF APROVAÇÃO ( WF APROVAÇÃO) Data: "+dtoc(ddatabase)+ "Hora: "+time()+" Não achou SCR(xxx): "+ cxFilial+cTipo+cNum+codAprov)		
  endif	
	
  If lLiberou

    If Select("SC7") > 0 
	    	SC7->(dbCloseArea()) 
		EndIf 
		dbselectarea("SC7")
    SC7->(dbSetOrder(1))       
    SC7->(dbgotop())
    SC7->(dbseek(cxFilial+cNum))
    
	  While !SC7->(Eof())
	  
	   	if SC7->C7_FILIAL+SC7->C7_NUM  == cxFilial+cNum		  
	   	
				Conout("( WF APROVAÇÃO) Data: "+dtoc(ddatabase)+ "Hora: "+time()+" Iniciando a Execução o Reclock(SC7,.F.) ")
				Reclock("SC7",.F.)  
				SC7->C7_CONAPRO := "L"
				Conout("( WF APROVAÇÃO) Data: "+dtoc(ddatabase)+ "Hora: "+time()+"Filial:" +SC7->C7_FILIAL+" Pedido:"+SC7->C7_NUM+" Valor do SC7->C7_CONAPRO: "+SC7->C7_CONAPRO )
				SC7->C7_OBS := AllTrim(SC7->C7_OBS)+"/"+cJusti
				Conout("( WF APROVAÇÃO) Data: "+dtoc(ddatabase)+ "Hora: "+time()+" Valor do SC7->C7_OBS: "+alltrim(SC7->C7_OBS)+" Valor do SC7->C7_CONAPRO: "+alltrim(SC7->C7_CONAPRO))
				SC7->(MsUnlock())
	     	Conout("( WF APROVAÇÃO) Data: "+dtoc(ddatabase)+ "Hora: "+time()+" Gravou SC7->(MsUnlock())")	     	
     	endif
			
			SC7->(dbSkip())
		
	  EndDo

      ConOut("( WF APROVAÇÃO) Filial: "+ cxFilial+ "Aprovando o Pedido: "+cNum )
      RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'10005',,"BI")       
      //finaliza o processo 
      oProcess:Finish()
			Conout("( WF APROVAÇÃO) Data: "+dtoc(ddatabase)+ "Hora: "+time()+" Fim a oProcess:Finish() ")

  Else                 
    //nOpc=2 finaliza o processo atual e re-inicia um novo    
    //nOpc=3 finaliza o processo atual e bloqueia o pedido   
    ConOut("( WF APROVAÇÃO) Filial: "+ cxFilial+ "Rastreia o Pedido: "+cNum+"Processo: "+oProcess:fProcessID+'.'+oProcess:fTaskID )
    RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,iif(nOpc=2,'10003','10004'),,"BI") 
    oProcess:Finish()

    dbSelectArea("SC7")
    if nOpc=2
      //Inicia o processo do proximo nivel
    		ConOut("( WF APROVAÇÃO)  Filial: "+ cxFilial+ " Inicia Chama SPCIniciar" )

	  SPCIniciar( oProcess ) 
    		ConOut("( WF APROVAÇÃO)  Filial: "+ cxFilial+ " Fim Chama SPCIniciar" )

	endif  

  EndIf
  
  cTipo:='PC'
  cDocto := cNum+Space(Len(SCR->CR_NUM)-Len(cNum))
  dbSelectArea("SCR")
  SCR->( dbSetOrder(2) )
  if !SCR->(dbSeek(cxFilial+cTipo+cDocto) )
  	Conout("INICIO DE RETORNO WF APROVAÇÃO (WF APROVAÇÃO) Data: "+dtoc(ddatabase)+ "Hora: "+time()+" Não achou SCR (1): "+ xFilial("SCR")+'PC'+cDocto )	  	
  endif
  
  cMSGAprov := iif(nOpc=2,'APROVADO','REPROVADO')
  cAviso:="NOTIFICAÇÃO - Pedido de Compra "+cMSGAprov+" - Pedido No "+cNum
  
  Conout("( WF APROVAÇÃO) Data: "+dtoc(ddatabase)+ "Hora: "+time()+" INICIANDO HTML ")

 
  //Mensagem
  xHTM := '<HTML><BODY>'
  xHTM += '<hr>'
  xHTM += '<p  style="word-spacing: 0; line-height: 100%; margin-top: 0; margin-bottom: 0">'
  xHTM += '<b><font face="Verdana" SIZE=3>'+cAviso+' &nbsp; '+dtoc(date())+'&nbsp;&nbsp;&nbsp;'+time()+'</b></p>'
  xHTM += '<hr>'
  xHTM += '<br>'
  xHTM += '<br>'                                 
  xHTM += 'O pedido em referencia foi '+cMSGAprov+' <BR><BR>'+iif(nOpc<>2,'Motivo: '+cJusti+'<BR><BR>','')+'-Data <b>'  +DTOC(date())+'</b> hora: <b>'+time()+'</b> <BR>-Responsável <b>'+UsrRetName(cCodLiber)+'</b> <br><br>'
  xHTM += '</BODY></HTML>'
  
  Conout("( WF APROVAÇÃO) Data: "+dtoc(ddatabase)+ "Hora: "+time()+" FIM xHTM ")

	dbSelectArea("SCR")
  SCR->(dbSetOrder(2))
  SCR->(dbgotop())
  SCR->(dbSeek(cxFilial+cTipo+cNum))
	
	Conout("( WF APROVAÇÃO) Data: "+dtoc(ddatabase)+ "Hora: "+time()+" Passou por SCR->(dbSeek(cxFilial+cTipo+cNum))" )

  while cxFilial=SCR->CR_FILIAL .and. SCR->CR_NUM = cNum

		Conout("( WF APROVAÇÃO) Data: "+dtoc(ddatabase)+ "Hora: "+time()+" while cxFilial=SCR->CR_FILIAL .and. SCR->CR_NUM = cNum" )
		
		Conout("( WF APROVAÇÃO) Data: "+dtoc(ddatabase)+ "Hora: "+time()+" Valores de cCodLiber: "+alltrim(cCodLiber)+" cNivelApr: "+alltrim(cNivelApr))

     if SCR->CR_USER<>cCodLiber .and. cNivelApr=SCR->CR_NIVEL //Avisa o mesmo nível
       
				Conout("( WF APROVAÇÃO) Data: "+dtoc(ddatabase)+ "Hora: "+time()+" Entrou no if SCR->CR_USER<>cCodLiber .and. cNivelApr=SCR->CR_NIVEL //Avisa o mesmo nível")

       cDestino:=UsrRetMail(SCR->CR_USER) 
       //Envia email de Aviso          
       Conout("( WF APROVAÇÃO) Data: "+dtoc(ddatabase)+ "Hora: "+time()+" Enviando E-MAIL PARA  "+alltrim(cDestino))
       ExxNVIAREMAIL('','Aviso - '+cAviso+'','Aviso - '+cAviso+'',xHTM,.t.,cDestino)              
       Conout("( WF APROVAÇÃO) Data: "+dtoc(ddatabase)+ "Hora: "+time()+" Enviado E-MAIL PARA  "+alltrim(cDestino))
     endif  
     SCR->(dbskip())

   enddo	  
    
   Conout("( WF APROVAÇÃO) Data: "+dtoc(ddatabase)+ "Hora: "+time()+" Avisando o Comprador")
   //Avisa o comprador
   if lLiberou .or. nOpc=3   
     //Envia email de Aviso
     ExxNVIAREMAIL('','Aviso - '+cAviso+'','Aviso - '+cAviso+'',xHTM,.t.,UsrRetMail(cPCUser))
     Conout("( WF APROVAÇÃO) Data: "+dtoc(ddatabase)+ "Hora: "+time()+" Avisou o Comprador"+cPCUser)
   endif  
	 
Return              



STATIC Function SPCIniciar( oProcess )
Local nTotal := _nXF := 0
Local i := 0
Local aMail := {}
Local cAssunto
//Local cHTML := AllTrim( WFGetMV("MV_WFHTM","/web/ruasag_teste_wf/html/") )
Local cHTML := AllTrim( "/workflow/")
//Local cIMAGE:= AllTrim( WFGetMV("MV_WFIMG","/web/ruasag_teste_wf/images/") )
Local cHttpServer := "http://" + AllTrim( WFGetMV( "MV_WFWS", "127.0.0.1" ) ) + "/messenger/"

    //Abre o HTML criado. Repare que o mesmo se encontra abaixo do RootPath
    cAssunto:= "Solicitação de Aprovacao de Pedido de Compra - Pedido No "+SC7->C7_NUM
	oProcess:NewTask( "Solicitação", cHTML+"wfw120pv.htm" )
//	oProcess:NewTask( "PEDCOM", "\workflow\wfw120p.htm" )
	oProcess:cSubject := cAssunto
	oProcess:bReturn := "U_WFW120P( 1 )"

	//  Timeout                                  dia          /        Hora       /  Minuto
	oProcess:bTimeOut := {{"U_WFW120P(2)", SuperGetMv("MV_WFDIAS",.F.,3) , SuperGetMv("MV_WFHORAS",.T.,12)  , 1 }}
	oHTML := oProcess:oHTML
	
//	oHtml:ValByName( "wf2p11", "WFHTTPRET.APL")
	
	/*** Preenche os dados do cabecalho ***/
	oHtml:ValByName( "EMISSAO", SC7->C7_EMISSAO )
	oHtml:ValByName( "FORNECEDOR", SC7->C7_FORNECE )    

	dbSelectArea('SA2')
	SA2->( dbSetOrder(1) )
	SA2->( dbSeek(xFilial('SA2')+SC7->C7_FORNECE+SC7->C7_LOJA) )
	oHtml:ValByName( "lb_nome", Posicione('SA2',1,xFilial('SA2')+SC7->C7_FORNECE+SC7->C7_LOJA,'A2_NOME') )    
	oHtml:ValByName( "lb_cond", Posicione('SE4',1,xFilial('SE4')+SC7->C7_COND,'E4_DESCRI') )    	
	oHtml:ValByName( "lb_comprador", UsrRetName(SC7->C7_USER) )    

	dbSelectArea('SC7')
	cxFilial := SC7->C7_FILIAL
	cNum := SC7->C7_NUM

	oHtml:ValByName( "EMPRESA_FILIAL", SM0->M0_FILIAL )
	oHtml:ValByName( "FILIAL", SC7->C7_FILIAL )
	oHtml:ValByName( "PEDIDO", SC7->C7_NUM )
 	oProcess:fDesc := "Pedido de Compras No "+ cNum


    SC7->( dbSetOrder(1) )
    SC7->( dbSeek(cxFilial+cNum) )

	//
	// Inicia-se o processo de identificação da cotação
	//
	DbSelectArea("SC8")
	SC8->( DbSetOrder(3) )
	if 	SC8->( DbSeek( cxFilial+SC7->C7_NUMCOT ) )
		oHtml:ValByName( "nCotacao"," - Nr.:"+SC7->C7_NUMCOT+" EM "+dtoc(SC8->C8_EMISSAO) )
	endif

	do while !SC8->( Eof() ) .and. (SC7->C7_FILIAL+SC7->C7_NUMCOT) = (SC8->C8_FILIAL+SC8->C8_NUM)

		if SC8->C8_FORNECE == SC7->C7_FORNECE .and. SC8->C8_LOJA == SC7->C7_LOJA
		
			AAdd( (oHtml:ValByName( "cotacao.item" )),SC8->C8_ITEM )
			AAdd( (oHtml:ValByName( "cotacao.codigo" )),SC8->C8_PRODUTO )
			AAdd( (oHtml:ValByName( "cotacao.descricao" )),Posicione('SB1',1,xFilial('SB1')+SC8->C8_PRODUTO,'B1_DESC') )
			AAdd( (oHtml:ValByName( "cotacao.fornecedor" )),Posicione('SA2',1,xFilial('SA2')+C8_FORNECE,'A2_NREDUZ') )
			AAdd( (oHtml:ValByName( "cotacao.total" )),TRANSFORM( SC8->C8_TOTAL,'@E 99,999.99' ) )		                     
			AAdd( (oHtml:ValByName( "cotacao.entrega" )),dtoc(SC8->C8_DATPRF) )		                     
			AAdd( (oHtml:ValByName( "cotacao.condPag" )),Posicione('SE4',1,xFilial('SE4')+SC8->C8_COND,'E4_DESCRI') )
			++_nXF
		
		endif
			
		SC8->( DbSkip() )
	
	enddo 


	if _nXF = 0
		
		oHtml:ValByName( "nCotacao"," - NÃO HOUVE COTAÇÃO PARA ESTE PEDIDO DE COMPRA" )
		AAdd( (oHtml:ValByName( "cotacao.item" )), SPACE( LEN(SC8->C8_ITEM) ) )
		AAdd( (oHtml:ValByName( "cotacao.codigo" )), SPACE( LEN(SC8->C8_PRODUTO) ) )
		AAdd( (oHtml:ValByName( "cotacao.descricao" )),SPACE( LEN(SC8->C8_PRODUTO) ) )
		AAdd( (oHtml:ValByName( "cotacao.fornecedor" )), SPACE( LEN(SA2->A2_NREDUZ) ) )
		AAdd( (oHtml:ValByName( "cotacao.total" )),SPACE(9) )
		AAdd( (oHtml:ValByName( "cotacao.entrega" )), space(10) )
		AAdd( (oHtml:ValByName( "cotacao.condPag" )), space( len(SE4->E4_DESCRI) ) )

	endif

aUltPrc	:= {0,0,0}

	dbSelectArea('SC7')    
    While !SC7->( Eof() ) .and. SC7->C7_FILIAL+SC7->C7_NUM = cxFilial+cNum

       aUltPrc	:= U_UltPrc(SC7->C7_PRODUTO)
       
       nTotal := nTotal + C7_TOTAL
       AAdd( (oHtml:ValByName( "produto.item" )),SC7->C7_ITEM )
       AAdd( (oHtml:ValByName( "produto.codigo" )),SC7->C7_PRODUTO )

       dbSelectArea('SB1')
       SB1->( dbSetOrder(1) )
       SB1->( dbSeek(xFilial('SB1')+SC7->C7_PRODUTO) )    

       AAdd( (oHtml:ValByName( "produto.descricao" )),Posicione('SB1',1,xFilial('SB1')+SC7->C7_PRODUTO,'B1_DESC') )
       AAdd( (oHtml:ValByName( "produto.quant" )),TRANSFORM( SC7->C7_QUANT,'@E 99,999.99' ) )		              
       AAdd( (oHtml:ValByName( "produto.preco" )),TRANSFORM( SC7->C7_PRECO,'@E 99,999.99' ) )		                     
       AAdd( (oHtml:ValByName( "produto.total" )),TRANSFORM( SC7->C7_TOTAL,'@E 99,999.99' ) )		                     
       AAdd( (oHtml:ValByName( "produto.unid" )) ,SB1->B1_UM )		              
       AAdd( (oHtml:ValByName( "produto.entrega" )),dtoc(SC7->C7_DATPRF) )		                     
       AAdd( (oHtml:ValByName( "produto.condPag" )),Posicione('SE4',1,xFilial('SE4')+SC7->C7_COND,'E4_DESCRI') )		                     

	   AAdd( (oHtml:ValByName( "produto.ultimo" )), aUltPrc[1] )    
	   AAdd( (oHtml:ValByName( "produto.penult" )), aUltPrc[2] )    
	   AAdd( (oHtml:ValByName( "produto.antepe" )), aUltPrc[3] )    
/*
	   AAdd( (oHtml:ValByName( "produto.ultpreco" )),TRANSFORM(aUltPrc[1],'@E 99,999,999.99' ) )    
       AAdd( (oHtml:ValByName( "produto.ultqtde" )),TRANSFORM(aUltPrc[2],'@E 99,999,999.99' ) )    
       AAdd( (oHtml:ValByName( "produto.penutpreco" )),TRANSFORM(aUltPrc[3],'@E 99,999,999.99' ) )    
	   AAdd( (oHtml:ValByName( "produto.penutqtde" )),TRANSFORM(aUltPrc[1],'@E 99,999,999.99' ) )    
       AAdd( (oHtml:ValByName( "produto.antepepreco" )),TRANSFORM(aUltPrc[2],'@E 99,999,999.99' ) )    
       AAdd( (oHtml:ValByName( "produto.antepeqtde" )),TRANSFORM(aUltPrc[3],'@E 99,999,999.99' ) )    
*/       

       WFSalvaID('SC7','C7_WFID',oProcess:fProcessID)

       SC7->( dbSkip() )

    Enddo

    oHtml:ValByName( "lbValor" ,TRANSFORM( nTotal,'@E 99,999.99' ) )		              	
    oHtml:ValByName( "lbFrete" ,TRANSFORM( 0,'@E 99,999.99' ) )		              	    
    oHtml:ValByName( "lbTotal" ,TRANSFORM( nTotal,'@E 99,999.99' ) )		              	    

	oProcess:ClientName( UsrRetName(WFCodUser("BI")) )
	oProcess:UserSiga := WFCodUser("BI")         
    
	aMail:={}
	
	dbSelectArea("SCR") 
	SCR->(dbgotop())
	SCR->(dbSetOrder(2))
	
	if SCR->(dbSeek(xFilial("SCR")+'PC'+cNum))
	
	
		while !SCR->(EOF()) 
	
	      if alltrim(cxFilial) == alltrim(SCR->CR_FILIAL) .AND. alltrim(cNum) == Alltrim(SCR->CR_NUM)
	      
			  //if SCR->CR_STATUS='02' Customização passar para todos os aprovadores ate visto
			    if !empty(UsrRetMail(SCR->CR_USER)) 	      
			      aadd(aMail,{UsrRetName(SCR->CR_USER),UsrRetMail(SCR->CR_USER),SCR->CR_USER})  
			      oHtml:ValByName("lb_aprovador", SCR->CR_USER )
			      oHtml:ValByName("usr", SCR->CR_USER )
			    else
			  	  Aviso("Aviso","Email não cadastrado para o usuário >> "+UsrRetName(CR_USER),{"Ok"},1)  
			    endif  	    
			  //endif
		  
		  endif
		  SCR->(dbskip())	  
		enddo
	else	
		Conout(" ( WF APROVAÇÃO) Data: "+dtoc(ddatabase)+ "Hora: "+time()+"Este pedido não existe SCR (Aprovadores)")	
	endif
	
	oProcess:cTo :=  "pedcom"  
	if len(aMail)>0
	
      cMailID := oProcess:Start()
      RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'10001','Processo do Pedido '+cNum+' iniciado!' )	

      for i:=1 to len(aMail)       

          cAviso:="Solicitação de Aprovacao de Pedido de Compra - Pedido No "+oProcess:oHtml:RetByName('Pedido')+' da empresa '+SM0->M0_FILIAL
          cDestino:=aMail[i,2] 
          cLink:=cHttpServer+"emp" + SM0->M0_CODIGO + "/pedcom/" + cMailID + ".htm"          

          //Envia email de Aviso
          xHTM := '<HTML><BODY>'
          xHTM += '<hr>'
          xHTM += '<p  style="word-spacing: 0; line-height: 100%; margin-top: 0; margin-bottom: 0">'
          xHTM += '<b><font face="Verdana" SIZE=3>'+cAviso+' &nbsp; em '+dtoc(date())+'&nbsp;&nbsp;&nbsp;'+time()+'</b></p>'
          xHTM += '<hr>'
          xHTM += '<br>'
          xHTM += '<b><font face="Verdana" SIZE=3> Prezado(a) '+aMail[i,1]+'</b></p>'                                
          xHTM += '<br>'                                 
          xHTM += 'Favor clicar no link abaixo para aprovação/rejeição do pedido em referencia<BR> <br>'
          xHTM += "<a href="+cLink+"?user="+aMail[i,3]+" title="+cLink+">Ver Pedido</a> "
          xHTM += '</BODY></HTML>'
          ExxNVIAREMAIL('','Aviso - '+cAviso+'','Aviso - '+cAviso+'',xHTM,.t.,cDestino)  
          RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'10001','Email enviado para  '+aMail[i,2]+'!' )	

      next i

    endif  
Return 



STATIC Function SPCTimeOut( oProcess )
  ConOut("Funcao de TIMEOUT executada Pedido "+oProcess:oHtml:RetByName('Pedido') )
          cAviso:="NOTIFICAÇÃO - Aprovação de Pedido de Compra PENDENTE - Pedido No "+oProcess:oHtml:RetByName('Pedido')
          cDestino:=UsrRetMail(WFCodUser("BI"))           
          //Envia email de Aviso
          xHTM := '<HTML><BODY>'
          xHTM += '<hr>'
          xHTM += '<p  style="word-spacing: 0; line-height: 100%; margin-top: 0; margin-bottom: 0">'
          xHTM += '<b><font face="Verdana" SIZE=3>'+cAviso+' &nbsp; '+dtoc(date())+'&nbsp;&nbsp;&nbsp;'+time()+'</b></p>'
          xHTM += '<hr>'
          xHTM += '<br>'
          xHTM += '<br>'                                 
          xHTM += 'O pedido em referencia ainda não foi respondido <BR> <br>'
          xHTM += '</BODY></HTML>'
          ExxNVIAREMAIL('','Aviso - '+cAviso+'','Aviso - '+cAviso+'',xHTM,.t.,cDestino)              

  //oProcess:Finish()  //Finalizo o Processo
Return    

/*######################################################################
	ULTIMOS PREÇOS
######################################################################*/
	User Function UltPrc(cCod)
	Local aArea		:= GetArea()
	Local aRet		:= {0,0,0}
	Local cAlias	:= GetNextAlias()
	       
	BeginSql Alias cAlias
		SELECT DISTINCT D1_FILIAL, D1_COD, D1_DOC, D1_SERIE, D1_DTDIGIT, D1_VUNIT, D1_QUANT, D1_UM
		FROM %TABLE:SD1% SD1
		WHERE  SD1.D_E_L_E_T_ = ' '
			AND SD1.D1_COD = %Exp:cCod%
			AND SD1.D1_TIPO = 'N'
		ORDER BY D1_DTDIGIT DESC
	EndSql

	_aQuery := GetLastQuery()
	 MemoWrite("C:\temp\wfw120p_ult_prc.txt",_aQuery[2])
	 If (cAlias)->(!EOF())
	  _N := 1  
	  While (cAlias)->(!EOF()) .AND. _N < 4
	   aRet[_N] := "R$ "+alltrim(str((cAlias)->D1_VUNIT))+" - "+alltrim(str((cAlias)->D1_QUANT))+alltrim((cAlias)->D1_UM)
	   _N++
	   (cAlias)->(dbSkip())
	  EndDo
	 EndIf	

	RestArea(aArea)
	Return aRet
	


/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ ExxNVIAREMAIL ¦ Autor ¦                    ¦ Data ¦ 29/08/02 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Funcao para enviar email                                   ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ Geral                                                      ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
//Funcao....: ExxNVIAREMAIL()
//Parametros: cArquivo: Dir\Nome         (C)
//            cTitulo : Titulo da Tela   (C)
//            cSubject: Titulo do E-Mail (C)
//            cBody   : Corpo do E-Mail  (C)
//            lShedule: Se for Shedulado (L)
//            cTo     : E-Mail destino   (C)
//            cCc     : E-Mail Copia     (C)
//Retorno...: .T./.F.
static FUNCTION ExxNVIAREMAIL(cArquivo,cTitulo,cSubject,cBody,lShedule,cTo,cCC)
*-----------------------------------------------------------------------------------------*
LOCAL cServer, cAccount, cPassword, lAutentica, cUserAut, cPassAut
LOCAL nOp:=0,oDlg
DEFAULT cArquivo := ""
DEFAULT cTitulo  := ""
DEFAULT cSubject := ""
DEFAULT cBody    := ""
DEFAULT lShedule := .F.
DEFAULT cTo      := ""
DEFAULT cCc      := ""

IF EMPTY((cServer:=AllTrim(SuperGetmv("MV_RELSERV"))))
   IF !lShedule .OR. bXMSAPRO
      MSGINFO("Nome do Servidor de Envio de E-mail nao definido no 'MV_RELSERV'")
   ELSE
      ConOut("Nome do Servidor de Envio de E-mail nao definido no 'MV_RELSERV'")
   ENDIF
   RETURN .F.
ENDIF

IF EMPTY((cAccount:=AllTrim(AllTrim(SuperGetmv("MV_RELACNT")))))
   IF !lShedule .OR. bXMSAPRO
      MSGINFO("Conta para acesso ao Servidor de E-mail nao definida no 'MV_RELACNT'")
   ELSE
      ConOut("Conta para acesso ao Servidor de E-mail nao definida no 'MV_RELACNT'")
   ENDIF
   RETURN .F.
ENDIF   

IF lShedule .AND. EMPTY(cTo)
   IF !lShedule .OR. bXMSAPRO
      ConOut("E-mail para envio, nao informado.")
   ENDIF
   RETURN .F.
ENDIF   

IF ! lShedule
  cFrom:= UsrRetMail(RetCodUsr())
  cUser:= UsrRetName(RetCodUsr())
else
  cFrom:= AllTrim(SuperGetmv("MV_EMCONTA"))//  cAccount //"nfe@flach.com.br"
  cUser:= AllTrim(SuperGetmv("MV_WFMLBOX"))   //"WorkFlow Flach"
endif
cCC  := cCC + SPACE(200)
cTo  := cTo + SPACE(200)
cSubject:=cSubject+SPACE(100)

IF EMPTY(cFrom)
   IF !lShedule  .OR. bXMSAPRO
       MsgInfo("E-mail do remetente nao definido no cad. do usuario: "+cUser)
   ELSE
       ConOut("E-mail do remetente nao definido no cad. do usuario: "+cUser)
   ENDIF
   RETURN .F.
ENDIF

DO WHILE !lShedule

   nOp  :=0
   nCol1:=8
   nCol2:=33
   nSize:=225  
   nLinha:=15 

   DEFINE MSDIALOG oDlg OF oMainWnd FROM 0,0 TO 350,544 PIXEL TITLE "Envio de E-mail"
        
  		@ nLinha,nCol1 Say "Titulo:"  Size 12,8              OF oDlg PIXEL
        @ nLinha,nCol2 MSGET cTitulo  SIZE nSize,10 WHEN .F. OF oDlg PIXEL
        nLinha+=15

  		@ nLinha,nCol1 Say "Usuario:" Size 20,8              OF oDlg PIXEL
        @ nLinha,nCol2 MSGET cUser    SIZE nSize,10 WHEN .F. OF oDlg PIXEL
        nLinha+=20

  		@ 000005,nCol1-4 To nLinha   ,268 LABEL " Informacoes " OF oDlg PIXEL
        nLinha+=05
        nLinAux:=nLinha
        nLinha+=10

  		@ nLinha,nCol1 Say   "De:"      Size 012,08             OF oDlg PIXEL 
  		@ nLinha,nCol2 MSGET cFrom      Size nSize,10 WHEN .F.  OF oDlg PIXEL 
        nLinha+=15

  		@ nLinha,nCol1 Say   "Para:"    Size 016,08             OF oDlg PIXEL
  		@ nLinha,nCol2 MSGET cTo        Size nSize,10  F3 "_EM" OF oDlg PIXEL
        nLinha+=15

  		@ nLinha,nCol1 Say   "CC:"      Size 016,08             OF oDlg PIXEL
  		@ nLinha,nCol2 MSGET cCC        Size nSize,10  F3 "_EM" OF oDlg PIXEL
        nLinha+=15

  		@ nLinha,nCol1 Say   "Assunto:" Size 021,08             OF oDlg PIXEL
  		@ nLinha,nCol2 MSGET cSubject   Size nSize,10           OF oDlg PIXEL
        nLinha+=15

  		@ nLinha,nCol1 Say   "Corpo:"   Size 016,08             OF oDlg PIXEL
  		@ nLinha,nCol2 Get   cBody      Size nSize,20  MEMO     OF oDlg PIXEL HSCROLL

  		@ nLinAux,nCol1-4 To nLinha+28,268 LABEL " Dados de Envio " OF oDlg PIXEL 
        nLinha+=35

    DEFINE SBUTTON FROM nLinha,(oDlg:nClientWidth-4)/2-90 TYPE 1 ACTION (If(Empty(cTo),Help("",1,"AVG0001054"),(oDlg:End(),nOp:=1))) ENABLE OF oDlg PIXEL
    DEFINE SBUTTON FROM nLinha,(oDlg:nClientWidth-4)/2-45 TYPE 2 ACTION (oDlg:End()) ENABLE OF oDlg PIXEL

   ACTIVATE MSDIALOG oDlg CENTERED

   IF nOp = 0
      RETURN .T.
   ENDIF

   EXIT

ENDDO

cAttachment:=cArquivo
cPassword  := AllTrim(SuperGetmv("MV_RELPSW"))         
lAutentica := SuperGetmv("MV_RELAUTH")          	//Determina se o Servidor de Email necessita de Autenticação
cUserAut   := Alltrim(SuperGetmv("MV_RELAUSR"))		//Usuário para Autenticação no Servidor de Email
cPassAut   := AllTrim(SuperGetmv("MV_RELPSW"))		//Senha para Autenticação no Servidor de Email
//cTo := AvLeGrupoEMail(cTo)
//cCC := AvLeGrupoEMail(cCC)

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lOK

If !lOK
   IF !lShedule  .OR. bXMSAPRO
       MsgInfo("Falha na Conexão com Servidor de E-Mail")
   ELSE
       ConOut("Falha na Conexão com Servidor de E-Mail")
   ENDIF
ELSE                                     
   If lAutentica
      If !MailAuth(cUserAut,cPassAut)
         MSGINFO("Falha na Autenticacao do Usuario")
         DISCONNECT SMTP SERVER RESULT lOk
      EndIf
   EndIf 
   cTo := "sangellesmoraes@gmail.com"
   cCC := ""
   IF !EMPTY(cCC)
      SEND MAIL FROM cFrom TO cTo CC cCC SUBJECT cSubject BODY cBody ATTACHMENT cAttachment RESULT lOK
   ELSE
      SEND MAIL FROM cFrom TO cTo SUBJECT cSubject BODY cBody ATTACHMENT cAttachment RESULT lOK
   ENDIF   
   If !lOK 
      IF !lShedule .OR. bXMSAPRO
         MsgInfo("Falha no Envio do E-Mail: "+ALLTRIM(cTo))
      ELSE
         ConOut("Falha no Envio do E-Mail: "+ALLTRIM(cTo))
      ENDIF
   ENDIF
ENDIF

DISCONNECT SMTP SERVER

IF lOk 
   IF !lShedule
      MsgInfo("E-mail enviado com sucesso: "+ALLTRIM(cTo))
   ELSE
      ConOut("E-mail enviado com sucesso: "+ALLTRIM(cTo))
   ENDIF       
   if bXMSAPRO
   	AVISO("Informação", "E-mail de Aprovação enviado com sucesso para "+ALLTRIM(cTo)  , {"Ok"})	
   endif
ENDIF   

RETURN .T.
