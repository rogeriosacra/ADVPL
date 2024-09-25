#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

STATIC _aprovado  := .F.

#DEFINE MODEL_OPERATION_UPDATE 4


/*/{Protheus.doc} TUMIW005
description
@type function
@version  
@author consultor.francys
@since 20/03/2023
@param cNumSoli, character, param_description
@return variant, return_description
/*/
User Function TUMIW005(cNumSoli)
                                                                                                             
//Local aOrdBKP	:= SaveOrd({"SC7","SA2","SE4","SC1","SC8","SB1"})
Local aOrdBKP	:= SaveOrd({"SA2","SE4","SC1","SB1"})
//Local cFilSC1	:= xFilial("SC1")
Local cFilSCR	:= xFilial("SCR")
Local cFilSA2	:= xFilial("SA2")
Local cFilSE4	:= xFilial("SE4")
Local cFilSC1	:= xFilial("SC1")
Local cFilSC8	:= xFilial("SC8")
Local cFilSB1	:= xFilial("SB1")
Local cFilSAK	:= xFilial("SAK")

Local lFound	:= .F.
Local cCond		:= ""
Local nTotPed	:= 0           
Local nTotIPI	:= 0
Local nTotFrete	:= 0                                      
Local aCotac	:= {}                  
Local cNivelAt	:= ""
Local nRecSC1	:= 0     
Local _nx 		:= 1
Local cNomeFor	:= ""                                
Local nTotDesc	:= 0                                
Local aAprover	:= {}
Local clFilSC7	:= ""
Local clNumSc7 	:= ""                                  
Local clEmailAp	:= "" 
Local alEnd		:= {}  
Local llFornece	:=  __NewMV(	"MV_WFFORNE",;
								.T.,;
								"L",;
								"Indica se envia workflow para fornecedor após as análises de aprovação",;
								"Indica se envia workflow para fornecedor após as análises de aprovação",;
								"Indica se envia workflow para fornecedor após as análises de aprovação",;
								.F. )
Local llRecebi	:=  __NewMV(	"MV_WFRECEB",;
								.T.,;
								"L",;
								"Indica se envia workflow para recebimento após as análises de aprovação",;
								"Indica se envia workflow para recebimento após as análises de aprovação",;
								"Indica se envia workflow para recebimento após as análises de aprovação",;
								.F. )

Local llCompra	:=  __NewMV(	"MV_WFCOMPR",;
								.T.,;
								"L",;
								"Indica se envia workflow para o comprador após as análises de aprovação",;
								"Indica se envia workflow para o comprador após as análises de aprovação",;
								"Indica se envia workflow para o comprador após as análises de aprovação",;
								.F. )

Local llSolici	:=  __NewMV(	"MV_WFSOLIC",;
								.T.,;
								"L",;
								"Indica se envia workflow para o solicitante após as análises de aprovação",;
								"Indica se envia workflow para o solicitante após as análises de aprovação",;
								"Indica se envia workflow para o solicitante após as análises de aprovação",;
								.F. )

Local clRecbto	:=  __NewMV(	"MV_EMAILRE",;
								"",;
								"C",;
								"E-mail do recebimento para receber o workflow informativo do pedido de compra",;
								"E-mail do recebimento para receber o workflow informativo do pedido de compra",;
								"E-mail do recebimento para receber o workflow informativo do pedido de compra",;
								.F. )
Local nlBkpSC7	:= 0          

                                    
//Cristiano
//Local cSuperior := PswRet()[1][11]   
LOCAL cAprov //:= STRTRAN(cSuperior,"|","")
Local cMailSup //:= UsrRetMail(cAprov)
Local cEmp := cFilant
Local cUser := __cUserID
Local cEmpant 



Default cNumSoli := "" 
Default INCLUI := .F.
Default ALTERA := .F. 


	If !ExistDir("\wfweb\")
		MakeDir("\wfweb\")
	EndIf		
    
	If !ExistDir("\wfweb\sc\")
		MakeDir("\wfweb\sc\")
	EndIf	


	If !FwIsInCallStack("MATA110") .AND. !FwIsInCallStack("MATA120")
		INCLUI := .F.
		ALTERA := .F.
	Endif

DBSELECTAREA('SCR')
DBSETORDER(1)
SCR->(DBGOTOP())
If DBSEEK(xFilial('SCR')+"SC"+SC1->C1_NUM)   
	WHILE !SCR->(EOF()) .and.  AllTrim(SC1->(xFilial('SC1')+"SC"+SC1->C1_NUM)) == Alltrim(SCR->(CR_FILIAL+CR_TIPO+CR_NUM))
		dbSelectArea("SAK")
		dbSetOrder(2)
		MsSeek(xFilial("SAK")+SCR->CR_USER)

		IF INCLUI == NIL
			INCLUI := .T.
		ENDIF

		If SAK->AK_XMAIL == "1"	.OR. ((INCLUI) .AND. SAK->AK_XMAIL== "3") .OR. (ALTERA .AND. SAK->AK_XMAIL== "4") ///FS12
			lTemGrupo := .T.
			If !Empty(SAK->AK_XGRUPO)
				lTemGrupo := temGrupo(SAK->AK_XGRUPO, SC1->C1_NUM)
			EndIf					
					
			//Conout("[1]SAK->AK_XMAIL:" + SAK->AK_XMAIL)
					
			If lTemGrupo									
				if SCR->CR_STATUS == '01' .OR. SCR->CR_STATUS == '03' .OR. SCR->CR_STATUS == '06' .OR. SCR->CR_STATUS == '05' ///FS12
				else ///FS12
					cAprov := SCR->CR_APROV

					cAprov := POSICIONE('SAK',1, xFilial("SAK")+cAprov, "AK_USER")

					cMailSup := UsrRetMail(cAprov)

					If Empty(cMailSup)
						Aviso("FDI","E-mail do Aprovador não cadastrado! Workflow não será enviado. Entre em contato com o Departamento de Compras.",{"Ok"})
						Return .F.
					EndIF                    
		
		                                   
					oProcess := TWFProcess():New( "000000", "Processo de Compras" )
					oProcess :NewTask( "Fluxo de Compras", "\workflow\html\SolApr.html" )
					oHtml    := oProcess:oHTML		    		
					
					oHtml:ValByName( "C1_NUM"     		, SC1->C1_NUM     							)
					oHtml:ValByName( "C1_FILIAL"   		, FWFilialName(cEmpant,cFilAnt)		)
					oHtml:ValByName( "C1_EMISSAO"  		, SC1->C1_EMISSAO  							)
					oHtml:ValByName( "lb_aprov"  		, SCR->CR_APROV +  UsrFullName(cAprov)		)
					oHtml:ValByName( "NOMEAPROVADOR"    , UsrFullName(cAprov)  						)

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Preenche os dados do Fornecedor³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                                                             
					oHtml:ValByName( "C1_SOLICIT"    , SC1->C1_SOLICIT     )
				
					nRecSC1 := SC1->(Recno())      
					
					SC1->(DbSetOrder(1))
					SC1->(DbSeek(cFilSC1 + SC1->C1_NUM))                           
		
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Monta os itens do Pedido no WorkFlow.³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					While SC1->(!EOF()) .AND. SC1->C1_FILIAL + SC1->C1_NUM == cFilSC1 + cNumSoli
						SC1->(DbSetOrder(1))
						SC1->(DbSeek(cFilSC1 + SC1->C1_NUM + SC1->C1_ITEM))
						
						SB1->(DbSetOrder(1))
						SB1->(DbSeek(cFilSB1 + SC1->C1_PRODUTO))
                                                     
						
						aAdd( (oHtml:ValByName( "it.item"    )), SC1->C1_ITEM       )
						aAdd( (oHtml:ValByName( "it.produto" )), SC1->C1_PRODUTO    )	
						aAdd( (oHtml:ValByName( "it.descri"  )), SC1->C1_DESCRI     )	
						aAdd( (oHtml:ValByName( "it.quant"   )), TRANSFORM( SC1->C1_QUANT,'@E 999999999.99' ) )
						aAdd( (oHtml:ValByName( "it.um"      )), SC1->C1_UM     )	                      
						aAdd( (oHtml:ValByName( "it.unit")), TRANSFORM( SC1->C1_PRECO,'@E 999999999.99' ) )
						aAdd( (oHtml:ValByName( "it.total")), TRANSFORM( SC1->C1_TOTAL,'@E 999999999.99' ) )
						aAdd( (oHtml:ValByName( "it.op")), SC1->C1_ITEMCTA    )
						aAdd( (oHtml:ValByName( "it.centro"  )), Posicione("CTT",1,xFilial("CTT") + SC1->C1_CC,"CTT_DESC01") ) 
						aAdd( (oHtml:ValByName( "it.datprf"  )), SC1->C1_DATPRF      )
						aAdd( (oHtml:ValByName( "it.observacao")), SC1->C1_OBS    )		                      
									
						SC1->(DbSkip())
					EndDo                                           
				
					oProcess:cSubject := "Solicitacao de Compra - " + cNumSoli + " - Pendente de Aprovacao: " + AllTrim(SM0->M0_NOME)
					oProcess:cTo      := cMailSup
					oProcess:bReturn  := "U_W0001RET(1)"                                                //Define a Função de Retorno    

					_cProcesso := "Aprovação de Solicitacao de Compras"
					
					cOldTo  := oProcess:cTo
					cOldCC  := oProcess:cCC
					cOldBCC := oProcess:cBCC
					
					//Uso um endereco invalido, apenas para criar o processo de workflow, mas sem envia-lo
					oProcess:cTo  := SC1->C1_USER
					oProcess:cCC  := NIL
					oProcess:cBCC := NIL
					
					cMailId    := oProcess:Start("\workflow\http\messenger\confirmacao\") // Crio o processo e gravo o ID do processo de Workflow
					
					DbSelectArea("SC1")
					DbSetOrder(1)
					DbSeek(xFilial("SC1")+cNumSoli)		
					U_EnvLK(cMailID  ,cOldTo,cOldCC,cOldBCC,oProcess:cSubject, _cProcesso, UsrFullName(cAprov), oProcess,SC1->C1_USER )
					
				ENDIF
			ENDIF
		ENDIF	
		SCR->(DBSKIP())	
	END	
EndIf


//Finaliza processo - nao tem mais aprovador
dbSelectArea("SCR")
dbSetOrder(1)
SCR->(dbGoTop()) //FS12 APROVACAO
If MsSeek(xFilial("SCR")+"SC"+cNumSoli)
	//Conout("POSICIONA")
	//cONOUT(email)
	//FS12 LOOP GRUPO APROVAÇÃO - DEPOIS
	While !SCR->(Eof()) .And. AllTrim(SCR->(CR_FILIAL+CR_TIPO+CR_NUM)) == AllTrim(SC1->(xFilial("SC1")+"SC"+cNumSoli))
		//Conout("entrou")
		If SCR->CR_STATUS == "01" .OR. SCR->CR_STATUS == "02" .OR.  SCR->CR_STATUS == "06"
			_aprovado := .F.
			//Conout("false")
		ElseIf SCR->CR_STATUS == "03"
			_aprovado := .T.
			//Conout("true")
		ElseIf SCR->CR_STATUS == "04"
			_aprovado := .T.
			//Conout("04")
			Exit
		Endif
		SCR->(dbSkip())
	EndDo
Endif
 



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura a Ordem Original dos arquivos, preservando a integridade do sistema³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RestOrd(aOrdBKP)

Return .T.        

                     

/*/{Protheus.doc} W0001RET
description
@type function
@version  
@author consultor.francys
@since 20/03/2023
@param AOpcao, array, param_description
@param oProcRet, object, param_description
@return variant, return_description
/*/
User Function W0001RET(AOpcao, oProcRet)
                              
Local cCodProc	:= Alltrim(GetNewPar("CL_0000018","000002")) 								//Codigo do Processo do Workflow para Compras             
Local cStatTim	:= Alltrim(GetNewPar("CL_0000035","100007"))								//Status de Timeout de Pedido para Aprovação
Local cStatRet	:= Alltrim(GetNewPar("CL_0000036","100006"))								//Status de Retorno de Pedido para Aprovação 
Local cFilSC1 	:= xFilial("SC1")
Local cFilSAK 	:= xFilial("SAK")
Local lFound  	:= .F.                                                                                        
Local lLiberou	:= .F.
Local cNumSoli 	:= alltrim(oProcRet:oHtml:RetByName("C1_NUM"    	))
Local cAprov	:= Substr(alltrim(oProcRet:oHtml:RetByName("lb_aprov"     	)),0,6)
Local cGrupo	:= ""
Local nOpcAlc 	:= 0
Local aRetSaldo := {}
Local nSaldo	:= 0
Local nTotal	:= 0
Local nSalDif	:= 0                       
Local llCompra	:=  __NewMV(	"MV_WFCOMPR",;
								.T.,;
								"L",;
								"Indica se envia workflow para o comprador após as análises de aprovação",;
								"Indica se envia workflow para o comprador após as análises de aprovação",;
								"Indica se envia workflow para o comprador após as análises de aprovação",;
								.F. )

Local llSolici	:=  __NewMV(	"MV_WFSOLIC",;
								.T.,;
								"L",;
								"Indica se envia workflow para o solicitante após as análises de aprovação",;
								"Indica se envia workflow para o solicitante após as análises de aprovação",;
								"Indica se envia workflow para o solicitante após as análises de aprovação",;
								.F. )
Local clEmailApro	:= ""
Local clTitulo		:= ""
Local clMensagem	:= ""    
Local llSaldook		:= .T.   
LOCAL clEmailCom	:= 'julyane.vale@valedossantos.com.br'
LOCAL clEmailSol
Local oFieldsSCR := NIL
Local oModel094 := Nil
Local lUltimo := .t.
lOCAL cNivel := ""


Private nOpc := 1
Private cObs		:= alltrim(oProcRet:oHtml:RetByName("lbmotivo"     	))
Private cUsrComp     := ""	
Private cCodUsr := ""

                                    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Trata a Variavel passada pelo workflow(aOpcao)³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if ValType(aOpcao) = "A" 
	aOpcao := aOpcao[1]
endif   
        
if aOpcao == NIL
	aOpcao := 0          
endIf

aItens := oProcRet:oHtml:RetByName('it.item')
aProds := oProcRet:oHtml:RetByName('it.produto')
aDesc  := oProcRet:oHtml:RetByName('it.descri')
aQuant := oProcRet:oHtml:RetByName('it.quant')
aUM		:= oProcRet:oHtml:RetByName('it.um')
aDatprf := oProcRet:oHtml:RetByName('it.datprf')
                                          
DbSelectArea("SC1") 
cFilSC1 := xFilial("SC1")
SC1->(DbSetOrder(1))

If !SC1->(DbSeek(cFilSC1 + Padr(cNumSoli,6) ))  
	MSGALERT("NUM 1")
	Return
Endif

DbSelectArea("SY1")
DbSetOrder(1)
If DbSeek(xFilial("SY1")+SC1->C1_CODCOMP)
	cUsrComp := SY1->Y1_USER
EndIf                                                         
               
                       
                                                   
If oProcRet:oHtml:RetByName("Aprovacao") == "S"   
	dbSelectArea("SCR")
	dbSetOrder(1)
	SCR->(dbGoTop()) //FS12 APROVACAO
		If MsSeek(xFilial("SCR")+"SC"+SC1->C1_NUM)
			
			//FS12 LOOP GRUPO APROVAÇÃO - ANTES
			MyExec094(SC1->C1_NUM,cAprov,"001")
				
			While !SCR->(Eof()) .And. AllTrim(SCR->(CR_FILIAL+CR_TIPO+CR_NUM)) == AllTrim(SC1->(xFilial("SC1")+"SC"+SC1->C1_NUM))
				If SCR->CR_STATUS == "01" .OR. SCR->CR_STATUS == "02" .OR. SCR->CR_STATUS == "04" .OR. SCR->CR_STATUS == "05" .OR. SCR->CR_STATUS == "06" 
						aprovado := .F.
					else
						aprovado := .T.
						cAprov := SCR->CR_USER
					endif

				SCR->(dbSkip())
			EndDo

			SC1->(dbGoTop())
			SC1->(dbSetOrder(1))
			SC1->(dbseek(xFilial("SC1")+Alltrim(cNumSoli)))
						
			While !SC1->(EOF()) .and. xFilial("SC1")+SC1->C1_NUM == xFilial("SC1")+Alltrim(cNumSoli)

				//Conout("Retorna")
				//u_MT110GRV()
				nOpcAlc := 4
	
				SC1->(DBSkip())
			ENDDO	
	   	endif
	MSGALERT("NUM 6")
	
ElseIf oProcRet:oHtml:RetByName("Aprovacao") == "N"  

	dbSelectArea("SCR")
	dbSetOrder(1)
	SCR->(dbGoTop())
		If MsSeek(xFilial("SCR")+"SC"+cNumSoli)
				
			While !SCR->(Eof()) .And. AllTrim(SCR->(CR_FILIAL+CR_TIPO+CR_NUM)) == AllTrim(SC1->(xFilial("SC1")+"SC"+cNumSoli))
			
				if SCR->CR_APROV == cAprov
				
	          		//A097ProcLib(SCR->(Recno()),3,,,,,dDataBase)
				        /*-- Seleciona a operação de rejeição de documentos
       					 A094SetOp('005')
 
						//-- Carrega o modelo de dados e seleciona a operação de aprovação (UPDATE)
						oModel094 := FWLoadModel('MATA094')
						oModel094:SetOperation( MODEL_OPERATION_UPDATE )
						oFieldsSCR := oModel094:GetModel('FieldSC')
						oModel094:Activate()
				
						//-- Preenche justificativa
						//oFieldsSCR:SetValue('CR_OBS', cObs)
				
						//-- Valida o formulário
						lOk := oModel094:VldData()
				
						If lOk
							//-- Se validou, grava o formulário
							lOk := oModel094:CommitData()
						EndIf

						oModel094:DeActivate()*/

						RECLOCK("SCR",.F.)
						SCR->CR_DATALIB := dDataBase
						SCR->CR_STATUS  := "04"  // Bloqueado
						SCR->CR_OBS     := cObs
						SCR->CR_LIBAPRO := cAprov
						SCR->(MSUNLOCK())


				endif
	   
								
			SCR->(dbSkip())
					
			EndDo
	   
	   	endif		
	nOpcAlc := 6
Endif   

/**     VALIDACAO EM NIVEIS     
If nOpcAlc == 4
SCR->(dbGoTop()) //FS12 APROVACAO
	If MsSeek(xFilial("SCR")+"SC"+SC1->C1_NUM)

	conout("NIVEL - "+cNivel)		
		//FS12 LOOP GRUPO APROVAÇÃO - ANTES			
		While !SCR->(Eof()) .And. AllTrim(SCR->(CR_FILIAL+CR_TIPO+CR_NUM)) == AllTrim(SC1->(xFilial("SC1")+"SC"+SC1->C1_NUM))
			If SCR->CR_APROV == cAprov
				SCR->(dbSkip())
			ElseIF 	SCR->CR_NIVEL == cNivel
				RECLOCK("SCR",.F.)
				SCR->CR_DATALIB := dDataBase
				SCR->CR_STATUS  := "05"  // Bloqueado
				SCR->CR_OBS     := " "
				SCR->CR_LIBAPRO := " "
				SCR->(MSUNLOCK())
				Conout("NIVEL IGUAL")
			ElseIF 	SCR->CR_NIVEL != cNivel
				lUltimo := .F.
				Conout("NIVEL DIFERENTE")
			ENDIF
		
			SCR->(dbSkip())
		ENDDO
	ENDIF

EndIf**/	



If nOpcAlc == 4//Aprovado

	If SC1->(DbSeek(cFilSC1 + cNumSoli))
	    
	    cCodUsr := SC1->C1_USER
		
		ConOut("SOLICITACAO " + cNumSoli+ " APROVADA COM SUCESSO PELO WORKFLOW! ")
		//SSCAprov(cNumSoli,.T.,cCodUsr,cObs,cUsrComp)
		U_TUMIW005(cNumSoli)
		if  _aprovado .AND. lUltimo

			RecLock("SC1",.F.)
			SC1->C1_APROV := "L"
			SC1->(MsUnlock())

			SSCAprov(cNumSoli,.T.,cCodUsr,cObs,cUsrComp)
		Endif	 
	endif                      
	
	//AQUI TALVEZ SEJA O MOMENTO DE ENVIAR O E-MAIL PARA COMPRAS, INFORMANDO QUE EXISTE SOLICITACAO ABERTA
	//E TAMBEM PARA O SOLICITANTE, INFORMANDO QUE LIBEROU A SUA SOLICITACAO

ElseIf nOpcAlc == 6     //Reprovado         

	If SC1->(DbSeek(cFilSC1 + cNumSoli))
	
		cCodUsr := SC1->C1_USER

		RecLock("SC1",.F.)
		SC1->C1_APROV := "R"
		SC1->(MsUnlock())

		TCSQLExec( "UPDATE "+RetSqlName("SC1")+" SET C1_APROV = 'R' WHERE C1_FILIAL = '"+cFilSC1+"' AND C1_NUM ='"+cNumSoli+"' " )	               

		ConOut("SOLICITACAO " + cNumSoli+ " REJEITADA PELO WORKFLOW! ")
		SSCAprov(cNumSoli,.F.,cCodUsr,cObs," ")

	endif
Endif
                              

Return .T.

Static Function SSCAprov(cNum,lAprovado,cSC1User,cObserv,cUserComp)
Local nx       := 0
Local cEmailCC := ""

If !Empty(cUserComp)
	cEmailCC := UsrRetMail(cUserComp) //SuperGetMv("MV_XMAILWF",.F.,"")
EndIf	

CONOUT("LOGWF: Envia email de aprovacao: "+cNum)

oProcAprov := TWFProcess():New("000001","Pedido de Compras - Aprovacao")
If lAprovado 
	oProcAprov:NewTask("Solicitacao","\workflow\html\tumiw005p2.html")
	oProcAprov:cSubject := "Solicitação de Compra Nº "+cNum+" aprovada."
	CONOUT("LOGWF: Aprovada. Solicitação: "+cNum)
Else
	oProcAprov:NewTask("Solicitacao","\workflow\html\tumiw005p3.html")
	oProcAprov:cSubject := "Solicitação de Compra Nº "+cNum+" reprovada."
	CONOUT("LOGWF: Reprovada. Solicitação: "+cNum)
EndIf	
oProcAprov:cTo		:= UsrRetMail(cSC1User)
oProcAprov:cCC		:= cEmailCC 
oProcAprov:ohtml:valbyname("Num",cNum)
oProcAprov:ohtml:valbyname("Emissao",DtoC(Posicione("SC1",1,xFilial("SC1")+cNum,"C1_EMISSAO")))
oProcAprov:ohtml:valbyname("Req",UsrRetName(cSC1User))

For nx := 1 to Len(aItens)
	AAdd((oProcAprov:oHTML:ValByName("it.item")),aItens[nx])
	AAdd((oProcAprov:oHTML:ValByName("it.produto")),aProds[nx])
	AAdd((oProcAprov:oHTML:ValByName("it.descri")),aDesc[nx])
	AAdd((oProcAprov:oHTML:ValByName("it.um")),aUM[nx])
	AAdd((oProcAprov:oHTML:ValByName("it.quant")),aQuant[nx])
	AAdd((oProcAprov:oHTML:ValByName("it.datprf")),aDatprf[nx])
Next

oProcAprov:ohtml:valbyname("Motivo",cObserv)

oProcAprov:start()	
oProcAprov:Free()

Return    

Static Function MyExec094(cSolic,cAprov,cStatus)
 
    Local oModel094 := Nil      //-- Objeto que receberá o modelo da MATA094
    Local cNum      := cSolic //-- Recebe o número do documento a ser avaliado
    Local cTipo     := "SC"     //-- Recebe o tipo do documento a ser avaliado
    Local cAprov    := cAprov //-- Recebe o código do aprovador do documento
    Local nLenSCR   := 0        //-- Controle de tamanho de campo do documento
    Local lOk       := .T.      //-- Controle de validação e commit
    Local aErro     := {}       //-- Recebe msg de erro de processamento
	Local oProcess := NIL
	Local	nOpcao   := 0
	Private cStatu

	DbSelectArea("SAK")
    SAK->(dbSetOrder(1))
    IF SAK->(dbSeek(xFilial("SAK")+cAprov))
        //__cUserId Variavel publica
        __cUserId          := SAK->AK_USER
    EndIF 

    
    nLenSCR := TamSX3("CR_NUM")[1] //-- Obtem tamanho do campo CR_NUM
    DbSelectArea("SCR")
    SCR->(DbSetOrder(3)) //-- CR_FILIAL+CR_TIPO+CR_NUM+CR_APROV
 
    If SCR->(DbSeek(xFilial("SCR") + cTipo + Padr(cNum, nLenSCR) + cAprov))
 
	    A094SetOp(cStatus)
 
        //-- Carrega o modelo de dados e seleciona a operação de aprovação (UPDATE)
        oModel094 := FWLoadModel('MATA094')
        oModel094:SetOperation( MODEL_OPERATION_UPDATE )
        oModel094:Activate()

		 
        //-- Valida o formulário
        lOk := oModel094:VldData()
 
        If lOk
				            //-- Se validou, grava o formulário
            lOk := oModel094:CommitData()

			dbSelectArea('SC1')
			cNum := SC1->C1_NUM
	
			dbSetOrder(1)
			dbSeek(xFilial('SC1')+cNum)
			While !Eof() .and. C1_NUM = cNum
			
				//qout("==>>PROCESSO DE REPROVADO 02")


				Conout(FWCodEmp())
				Conout(FWFilial())
						
				If 	SC1->C1_APROV == 'L'
				else
						
					oProcess == NIL
					nOpcao   == 0
					
					Conout("Retorna")
					U_TUMIW005(cNum)
					
					Conout("Depois do Retorna")
					exit
				endif 
						
				SC1->(dbSkip())
			EndDo 		
    	EndIf
 
		//-- Avalia erros
		If !lOk
			//-- Busca o Erro do Modelo de Dados
			aErro := oModel094:GetErrorMessage()
					
			//-- Monta o Texto que será mostrado na tela
			AutoGrLog("Id do formulário de origem:" + ' [' + AllToChar(aErro[01]) + ']')
			AutoGrLog("Id do campo de origem: "     + ' [' + AllToChar(aErro[02]) + ']')
			AutoGrLog("Id do formulário de erro: "  + ' [' + AllToChar(aErro[03]) + ']')
			AutoGrLog("Id do campo de erro: "       + ' [' + AllToChar(aErro[04]) + ']')
			AutoGrLog("Id do erro: "                + ' [' + AllToChar(aErro[05]) + ']')
			AutoGrLog("Mensagem do erro: "          + ' [' + AllToChar(aErro[06]) + ']')
			AutoGrLog("Mensagem da solução:"        + ' [' + AllToChar(aErro[07]) + ']')
			AutoGrLog("Valor atribuído: "           + ' [' + AllToChar(aErro[08]) + ']')
			AutoGrLog("Valor anterior: "            + ' [' + AllToChar(aErro[09]) + ']')
	
			//-- Mostra a mensagem de Erro
			// MostraErro()
		EndIf
	
		//-- Desativa o modelo de dados
		oModel094:DeActivate()
	
    Else
        // Conout("Documento não encontrado!")
    EndIf
     
    //-- Finaliza o ambiente
     
Return



Static Function __NewMV( cMvPar, xValor, cTipo, cDescP, cDescS, cDescE, lAlter )

Local aAreaAtu	:= GetArea()
Local lRecLock	:= .F. 
Local xlReturn	

Default lAlter := .F.

If ( ValType( xValor ) == "D" )
	If "" $ xValor
		xValor := Dtoc( xValor, "ddmmyy" )
	Else
		xValor	:= Dtos( xValor )
	Endif
ElseIf ( ValType( xValor ) == "N" )
	xValor	:= AllTrim( Str( xValor ) )
ElseIf ( ValType( xValor ) == "L" )
	xValor	:= If ( xValor , ".T.", ".F." )
EndIf

xlReturn := GetNewPar(cMvPar)

RestArea( aAreaAtu )

Return(xlReturn)

/*/{Protheus.doc} EnvLK
Monta link do email
@type function
@version  
@author consultor.francys
@since 20/03/2023
@param cHtmlFile, character, param_description
@param cOldTo, character, param_description
@param cOldCC, character, param_description
@param cOldBCC, character, param_description
@param cSubject, character, param_description
@param pcDescProc, variant, param_description
@param pcNomAprov, variant, param_description
@param oP, object, param_description
@param cUserWF, character, param_description
@return variant, return_description
/*/
User Function EnvLK(cHtmlFile,cOldTo,cOldCC,cOldBCC,cSubject, pcDescProc, pcNomAprov, oP, cUserWF )
Local clEndHtml 		:= "\workflow\html\wflink.html"
Local clSrvWfInt		:=  __NewMV(	"MV_LINKINT",;
								"187.122.106.151:8088/confirmacao ",;
								"C",;
								"Server HTTP Interno: utilizado para WORKFLOW  ",;
								"Server HTTP Interno: utilizado para WORKFLOW  ",;
								"Server HTTP Interno: utilizado para WORKFLOW  ",;
								.F. )                                          
Local clSrvWFExt 		:=  __NewMV(	"MV_LINKEXT",;
								"187.122.106.151:8088",;
								"C",;
								"Server HTTP Externo: utilizado para WORKFLOW  ",;
								"Server HTTP Externo: utilizado para WORKFLOW  ",;
								"Server HTTP Externo: utilizado para WORKFLOW  ",;
								.F. )

Local clLinkInt 	:= "http://" 	+ 	clSrvWfInt + "/" + cHtmlFile + ".htm"                          
Local clLinkExt		:= "http://"	+	clSrvWFExt + "/wf/messenger/emp" + cEmpAnt + "/" + cUserWF + "/" + cHtmlFile + ".htm"
								                                          


oP:NewTask("Link de Processos Workflow", clEndHtml)  // Html com link para envio

oP:ohtml:ValByName("usuario",pcNomaprov)
oP:ohtml:ValByName("proc_link",clLinkInt)
oP:ohtml:ValByName("referente",pcDescProc)
oP:ohtml:ValByName("proc_link2",clLinkExt)						

oP:ohtml:ValByName("EMPRESA",SM0->(AllTrim(M0_NOME) ) )
			
oP:cTo  := cOldTo
oP:cCC  := cOldCC
oP:cBCC := cOldBCC  
               
cSubject	:= StrTran(cSubject,"ã","a")
cSubject	:= StrTran(cSubject,"ç","c")
cSubject	:= StrTran(cSubject,"é","e")

oP:csubject := cSubject

_cId := oP:start() 


Return()

