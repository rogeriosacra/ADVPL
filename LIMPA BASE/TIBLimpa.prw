#include "rwmake.ch"
#include "Topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#include "fileio.ch"
#include "protheus.ch"


/*
{Protheus.doc} u_TIBLimpa
Limpa a base de dados por filiais.

@type  Function
@author  Antonio C Ferreira - TOTVS Ibirapuera
@version 1.0
@since   08/05/2023
@return  Nil  Sem retorno.
@sample
         u_TIBLimpa()
*/

Function u_TIBLimpa()

	If  (Type("oMainWnd") == "U")
		DEFINE WINDOW oMainWnd FROM 0,0 TO 01,30 TITLE "" 
		Activate Window oMainWnd on init (Dialogo(),__QUIT()) MAXIMIZED
	Else
		Dialogo()
	EndIf

Return .T.



STATIC Function Dialogo()

	Local nA                := 0
	Local oDlg              := Nil
	Local aEmps             := {}
	Local aEmpresas         := {}
	Local aTabelas          := {{.F.,"",""}}
	Local cDir              := "C:\Temp\LimpaBase\"
	Local cArq              := cDir + "LIMPABASE.TXT"
	Local oOk               := LoadBitmap( GetResources(), "LBOK" )
	Local oNo               := LoadBitmap( GetResources(), "LBNO" )
	Local lMarcar           := .T.
	Local lMarcar02         := .F. 
	Local lMarcar03         := .F. 
	Local lMarcar04         := .F. 
	Local cXEmpresa         := ""

	Private oText           := Nil  //MsAguarde()

	//Caso nao venha com o ambiente aberto
	If  (Select("SM0") <= 0)
		OpenSM0()
	EndIf

	aEmps := FWLoadSM0()

	If  (Len(aEmps) > 0) .And. (Select("SX6") <= 0)

		RpcSetEnv(aEmps[1][1], aEmps[1][2])

	EndIf

	__cInterNet := " "  //MsAguarde() retorna erro no MsProcTxt() se estiver como AUTOMATICO

	For nA := 1 to Len(aEmps)

		cXEmpresa := If(Empty(aEmps[nA][3]), aEmps[nA][1], aEmps[nA][3])

		If  (Ascan(aEmpresas, {|x| x[2]==cXEmpresa}) <= 0)

			AAdd(aEmpresas, {.T., cXEmpresa, Alltrim(aEmps[nA][7])})

		EndIf

	Next nA

	WFForceDir(cDir)  //Cria o diretorio caso não exista

	oMainWnd:CoorsUpdate()
	oMainWnd:ReadClientCoors()

	//DEFINE FONT oFont NAME "Arial" SIZE 0,-11 BOLD
	DEFINE MSDIALOG oDlg TITLE OemToAnsi("Limpar a base de dados") FROM 0,0 TO oMainWnd:nHeight-110, oMainWnd:nWidth OF oMainWnd PIXEL

		oDlg:lMaximized:= .T.

		Define Font oFont  Name "Tahoma" Size 0,-11 Bold

       	oTela1       := FWFormContainer():New( oDlg )
	    cIdLTopo     := oTela1:CreateHorizontalBox( 10 )
	    cIdLCorpo    := oTela1:CreateHorizontalBox( 90 )
	    oTela1:Activate( oDlg, .F. )
	    oPnlTopo     := oTela1:GeTPanel( cIdLTopo  )
        oPnlCorpo    := oTela1:GeTPanel( cIdLCorpo )

       	oTela2       := FWFormContainer():New( oPnlCorpo )
	    cIdVazio1    := oTela2:CreateVerticalBox( 03 )
	    cIdEmpresa   := oTela2:CreateVerticalBox( 27 )
	    cIdTabelas   := oTela2:CreateVerticalBox( 30 )
	    cIdVazio2    := oTela2:CreateVerticalBox( 40 )
	    oTela2:Activate( oPnlCorpo, .F. )
        oPnlVazio1   := oTela2:GeTPanel( cIdVazio1   )
	    oPnlEmpresa  := oTela2:GeTPanel( cIdEmpresa  )
        oPnlTabelas  := oTela2:GeTPanel( cIdTabelas  )
        oPnlVazio2   := oTela2:GeTPanel( cIdVazio2   )

       	oTela3       := FWFormContainer():New( oPnlEmpresa )
	    cIdLTopo2    := oTela3:CreateHorizontalBox( 04 )
	    cIdLCorpo2   := oTela3:CreateHorizontalBox( 96 )
	    oTela3:Activate( oPnlEmpresa, .F. )
	    oPnlTopo2    := oTela3:GeTPanel( cIdLTopo2  )
        oPnlCorpo2   := oTela3:GeTPanel( cIdLCorpo2 )

       	oTela4       := FWFormContainer():New( oPnlTabelas )
	    cIdLTopo3    := oTela4:CreateHorizontalBox( 06 )
	    cIdLCorpo3   := oTela4:CreateHorizontalBox( 88 )
	    cIdLRodape3  := oTela4:CreateHorizontalBox( 06 )
	    oTela4:Activate( oPnlTabelas, .F. )
	    oPnlTopo3    := oTela4:GeTPanel( cIdLTopo3  )
        oPnlCorpo3   := oTela4:GeTPanel( cIdLCorpo3 )
        oPnlRodape3  := oTela4:GeTPanel( cIdLRodape3 )

		@ 008, 005 SAY oSay Prompt OemToAnsi("ATENÇÃO: Esta rotina tem por objetivo excluir os registros das tabelas selecionadas das empresas selecionadas!") SIZE 300,08 OF oPnlTopo PIXEL

		@ 002, 002 SAY oSay Prompt OemToAnsi("Selecione as empresas:") SIZE 200,08 OF oPnlTopo2 PIXEL

		@ 000, 000 Listbox  oLbx1 Var  cVar Fields Header " ", "Empresa", "Nome" Size 178, 095 Of oPnlCorpo2 Pixel
		oLbx1:SetArray(  aEmpresas )
		oLbx1:bLine := {|| { If( aEmpresas[oLbx1:nAt, 1], oOk, oNo ), ;
							aEmpresas[oLbx1:nAt, 2], ;
							aEmpresas[oLbx1:nAt, 3]}}
		oLbx1:BlDblClick := { || aEmpresas[oLbx1:nAt, 1] := !aEmpresas[oLbx1:nAt, 1], oLbx1:Refresh()}

		@ 007, 002 SAY oSay Prompt OemToAnsi("Lendo o arquivo em "+ cArq +":") SIZE 200,08 OF oPnlTopo3 PIXEL

		@ 003, 160 Button oBtnOk  Prompt 'Ler Arquivo' Size 40 , 12 Of oPnlTopo3 Pixel Action ( LerArquivo(cArq, @oLbx2, @aTabelas) .And. (lMarcar:=.T.) )

		@ 000, 000 Listbox  oLbx2 Var  cVar Fields Header " ", "Alias", "Descrição" Size 178, 095 Of oPnlCorpo3 Pixel
		oLbx2:SetArray(  aTabelas )
		oLbx2:bLine := {|| { If( aTabelas[oLbx2:nAt, 1], oOk, oNo ), ;
							aTabelas[oLbx2:nAt, 2], ;
							aTabelas[oLbx2:nAt, 3]}}
		oLbx2:BlDblClick := { || aTabelas[oLbx2:nAt, 1] := If(Empty(aTabelas[oLbx2:nAt, 3]), .F., !aTabelas[oLbx2:nAt, 1]), oLbx2:Refresh()}
		oLbx2:Align := CONTROL_ALIGN_ALLCLIENT

		@ 002 ,010 CHECKBOX oMarcar01 VAR lMarcar PROMPT "Marcar / Desmarcar todos" 	   SIZE 100,7 	PIXEL OF oPnlRodape3 ON CLICK( aEval( aTabelas, {|x| x[1] := If(Empty(x[3]), .F., lMarcar) } ), oLbx2:Refresh() )

		@ 030 ,020 CHECKBOX oMarcar02 VAR lMarcar02 PROMPT "Zerar Saldo de CLIENTES" 	   SIZE 100,7 	PIXEL OF oPnlVazio2 

		@ 050 ,020 CHECKBOX oMarcar03 VAR lMarcar03 PROMPT "Zerar Saldo de FORNECEDORES" SIZE 100,7 	PIXEL OF oPnlVazio2 

		@ 070 ,020 CHECKBOX oMarcar04 VAR lMarcar04 PROMPT "Zerar Saldo de BANCOS" 	   SIZE 100,7 	PIXEL OF oPnlVazio2 

		@ 010, 300 Button oBtnOk  Prompt 'Limpar a Base' Size 40 , 12 Of oPnlTopo Pixel Action ( Processar(aEmpresas, aTabelas, lMarcar02, lMarcar03, lMarcar04) )

		@ 010, 360 Button oBtnOk  Prompt 'Fechar' Size 30 , 12 Of oPnlTopo Pixel Action ( oDlg:End() )

	ACTIVATE MSDIALOG oDlg CENTERED


Return .T.


STATIC Function LerArquivo(cArq, oLbx2, aTabelas)

	Local aFilesTxt := Directory(cArq)

	If  (Len(aFilesTxt) <= 0)
		
		MsgBox("Arquivo "+ cArq +" não encontrado !","A T E N C A O","ALERT")

		aTabelas := {{.F.,"",""}}

	Else
	
		nHdl2  := FT_FUSE(cArq)

		If  (nHdl2 == -1)

			MsgBox("Problema com leitura do arquivo " + cArq, "A T E N C A O", "ALERT")

			aTabelas := {{.F.,"",""}}

		Else

			aTabelas := {}

			MsAguarde({|lEnd| LendoArquivo(@aTabelas) }, "Lendo arquivo TXT", "Carregando a grid...", .T.)

		Endif
	Endif

	FwUpdBrow( @oLbx2, aTabelas )  //Atualiza a Matriz do ListBox

Return .T.


STATIC Function LendoArquivo(aTabelas)

	Local cAlias := ""
	Local cNome  := ""

	FT_FGOTOP()

	While !FT_FEOF() 

		cAlias := Left(Alltrim(FT_FREADLN()),3)

		MsProcTxt("Lendo o Arquivo Texto..." + Alltrim(cAlias))

		cNome := Posicione("SX2", 1, cAlias, "X2_NOME")

		AAdd(aTabelas, {!Empty(cNome), cAlias, cNome})

		FT_FSKIP()

	EndDo

	FT_FUSE()

Return


STATIC Function Processar(aEmpresas, aTabelas, lMarcar02, lMarcar03, lMarcar04)

	Local nA        := 0
	Local nTA       := Len(aEmpresas)
	Local nB        := 0
	Local nTB       := Len(aTabelas)
	Local lProcessa := .F.

	Private lCancelar := .F.

	Begin Sequence

		For nA := 1 to nTA  //Empresas

			If  !( aEmpresas[nA,1] )
				Loop
			EndIf

			For nB := 1 to nTB  //Tabelas

				If  !( aTabelas[nB,1] )
					Loop
				EndIf

				lProcessa := .T.
				Exit

			Next nB

			If  lProcessa
				Exit
			EndIf

		Next nA

		If  !( lProcessa )
			MsgBox("Selecione as empresas e tabelas para a exclusão dos registros!", "A T E N C A O", "ALERT")
			Break
		EndIf

		If  !( MsgYesNo("Confirme o Processamento da limpeza de Base de Dados?") )
			Break
		EndIf

		DEFINE MSDIALOG oDlg2 TITLE OemToAnsi("Processando a Limpeza de base de dados") FROM 0,0 TO 320, 460 OF oMainWnd PIXEL

			oWeb1Engine := TWebEngine():New(oDlg2, 010, 010, 240, 040,"", 0)
		
			oWeb2Engine := TWebEngine():New(oDlg2, 050, 010, 240, 040,"", 0)

			@ 110 ,090 CHECKBOX oChk VAR lCancelar PROMPT "Cancelar (Clique várias vezes)" 	SIZE 100,7 	PIXEL OF oDlg2 When(!lCancelar)

		ACTIVATE MSDIALOG oDlg2 CENTERED ON INIT (PExcluir(oDlg2, oWeb1Engine, oWeb2Engine, aEmpresas, aTabelas, lMarcar02, lMarcar03, lMarcar04))

	End Sequence

Return .T.


STATIC Function PExcluir(oDlg2, oWeb1Engine, oWeb2Engine, aEmpresas, aTabelas, lMarcar02, lMarcar03, lMarcar04)

	Local nA        := 0
	Local nTA       := Len(aEmpresas)
	Local nB        := 0
	Local nTB       := Len(aTabelas)
	Local lCancelou := .F.
	Local cXEmpresa := cEmpAnt

	Begin Sequence

		For nA := 1 to nTA  //Empresas

			If  !( aEmpresas[nA,1] )
				Loop
			EndIf

			cEmpAnt := aEmpresas[nA,2]

			oWeb1Engine:setHtml(VerHTML(nA, nTA, aEmpresas[nA,2] + " - " + aEmpresas[nA,3]), "")

			For nB := 1 to nTB  //Tabelas

				If  !( aTabelas[nB,1] )
					Loop
				EndIf

				cNomeTabela := RetSQLName(aTabelas[nB,2])

				If  Empty(cNomeTabela) .Or. !(cEmpAnt $ cNomeTabela)
					Loop
				EndIf

				oWeb2Engine:setHtml(VerHTML(nB, nTB, cNomeTabela + " - " + aTabelas[nB,3]), "")

				Inkey(0.1)
				ProcessMessage()

				If  lCancelar //Responde mais rapido quando a variavel é Private do que local passada por referencia.

					If  MsgYesNo("Deseja realmente cancelar o processo?")
						lCancelou := .T.
						Break
					EndIf

					lCancelar := .F.

				EndIf

				TCSqlExec("DELETE FROM " + cNomeTabela)

			Next nB

			If  !( lCancelou )

				If  lMarcar02  //Zerar o saldo do cliente

					cNomeTabela := RetSQLName("SA1")

					If  !( Empty(cNomeTabela) .Or. !(cEmpAnt $ cNomeTabela) )

						TCSqlExec("UPDATE " + cNomeTabela + " SET A1_NROCOM = 0, A1_MSALDO = 0, A1_PRICOM = ' ', A1_ULTCOM = ' ' ")

					EndIf
					
				EndIf

				If  lMarcar03  //Zerar o saldo do Fornecedor

					cNomeTabela := RetSQLName("SA2")

					If  !( Empty(cNomeTabela) .Or. !(cEmpAnt $ cNomeTabela) )

						TCSqlExec("UPDATE " + cNomeTabela + " SET A2_NROCOM = 0, A2_MSALDO = 0, A2_PRICOM = ' ', A2_ULTCOM = ' ', A2_MATR = 0, A2_SALDUP = 0 ")

					EndIf
					
				EndIf

				If  lMarcar04  //Zerar o saldo do Banco

					cNomeTabela := RetSQLName("SA6")

					If  !( Empty(cNomeTabela) .Or. !(cEmpAnt $ cNomeTabela) )

						TCSqlExec("UPDATE " + cNomeTabela + " SET A6_SALATU = 0 ")

					EndIf
					
				EndIf

			EndIf

		Next nA

	End Sequence

	cEmpAnt := cXEmpresa

	If  lCancelou
		@ 130, 030 SAY oSay VAR '<B><font color="red">PROCESSO CANCELADO PELO USUÁRIO!</font</B>' OF oDlg2 PIXEL SIZE 200,20 HTML
	Else
		@ 130, 030 SAY oSay VAR '<B><font color="blue">PROCESSO CONCLUÍDO!</font</B>' OF oDlg2 PIXEL SIZE 200,20 HTML
	EndIf

Return .T.


STATIC Function VerHTML(nPos, nTotal, cProgresso)

	Local cHtml := ""
	Local cBarra := CValToChar(400 * (nPos/nTotal))

	BeginContent Var cHtml
			<html>
				<body>

					<div>
						<div id="progress" style="width: 402px; border: 1px solid black; background: #eee; margin-top: 20px;">
							<div id="progressbar" style="width: %Exp:cBarra%px; height: 24px; background: #333; background-color: blue; border: 1px solid white">&nbsp;</div>
						</div>
						<div id="tp">(%Exp:cProgresso%)</div>
					</div>

				</body>
			</html>
	EndContent

Return cHTML
