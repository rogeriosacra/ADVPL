#Include "Protheus.Ch"

/*/{Protheus.doc} U_MarkLeg
    @type		Function
    @author		Milton J.dos Santos
    @since		01/03/2020
    @version	1.0.0
    @param		Nenhum
    @return		Vazio (nil)
    @example    Exemplo da utilizacao de MarkBrowse + Legenda
    @see		https://tdn.totvs.com/display/public/framework/MarkBrow
/*/

User Function MarkLeg()
Local aSay		:= {}
Local aButton	:= {}
Local nOpcao	:= 0

Private cCadastro   := "Exemplo de MarkBrowse + Legenda"
	
MrkBrwDados()

Return

Static Function MrkBrwDados()
Local nI		:= 0
Local aCpos		:= {}
Local aCampos	:= {}
Local aIndex	:= {}
	
Private aRotina	:= {}
Private bFiltraBrw := {|| }
		
//+--------------------------------------------------------+
//| Parametros utilizado no programa                       |
//+--------------------------------------------------------+
//| mv_par01 - Emissao de? 						99/99/99   |
//| mv_par02 - Emissao ate? 					99/99/99   |
//| mv_par03 - Forncedor de? 					999999     |
//| mv_par04 - Fornecedor ate? 					999999     |
//| mv_par05 - Mostrar todos os registros? 	    Sim/Não    |
//| mv_par06 - Trazer marcados? 				Sim/Não    |
//+--------------------------------------------------------+
	
mv_par01 := StoD('19000101')
mv_par02 := StoD('20501231')
mv_par03 := '000000'
mv_par04 := '999999'
mv_par05 := 1
mv_par06 := 1

//+----------------------------------------
//| Atribui as variaveis de funcionalidades
//+----------------------------------------
aAdd( aRotina ,{"Pesquisar" ,"u_MrkBrwPesq()",0,1})
aAdd( aRotina ,{"Processar" ,"u_MrkBrwProc()",0,3})
aAdd( aRotina ,{"Legenda"   ,"u_MrkBrwLeg()" ,0,4})
	             
//+----------------------------------------------------
//| Somente deverão aparecer estes campos na MarkBrowse
//+----------------------------------------------------
aCpos := {"F1_OK","F1_DOC","F1_SERIE","F1_FORNECE","F1_LOJA","F1_EMISSAO","F1_VALBRUT","F1_TIPO"}
	
/*
* Estrutura do vetor aCampos
* --------------------------
* [1] - Nome do campo
* [2] - Obsoleto
* [3] - Título do campo
* [4] - Picure do campo
*/

SX3->(dbSetOrder(2))

For nI := 1 To Len(aCpos)
   SX3->(dbSeek(aCpos[nI]))
   aAdd(aCampos,{	RTrim(SX3->X3_CAMPO),"",;
   					Iif(nI==1," ",X3Titulo()),;
   					RTrim(SX3->X3_PICTURE)})
Next
	
	//+------------------------------------------------------------------------
	//| Monta as variáveis com o filtro especifico para o resultado na MarkBrow
	//+------------------------------------------------------------------------
	
	// Filtro DBF
	cFiltro := "Dtos(F1_EMISSAO) >= '"+Dtos(mv_par01)+"' .And. "
	cFiltro += "Dtos(F1_EMISSAO) <= '"+Dtos(mv_par02)+"' .And. "
	cFiltro += "F1_FORNECE >= '"+mv_par03+"' .And. "
	cFiltro += "F1_FORNECE <= '"+mv_par04+"' "
	If mv_par05 == 2
	   cFiltro += ".And. Empty(F1_REMITO)"
	Endif
	
	// Filtro SQL
	cQuery := "F1_EMISSAO >= '"+Dtos(mv_par01)+"' AND "
	cQuery += "F1_EMISSA0 <= '"+Dtos(mv_par02)+"' AND "
	cQuery += "F1_FORNECE >= '"+mv_par03+"' AND "
	cQuery += "F1_FORNECE <= '"+mv_par04+"' "
	If mv_par05 == 2
		cQuery += "AND F1_REMITO = ' ' "
	Endif	

	//+-------------------------------------------------------
	//| Processa o filtro conforme a base de dados do Protheus
	//+-------------------------------------------------------
	bFiltraBrw := {|x| Iif(x==NIL,FilBrowse("SF1",@aIndex,@cFiltro),{cFiltro,cQuery,"","",aIndex}) }
	Eval(bFiltraBrw)
	SF1->(MsSeek(xFilial()))

	//+------------------------------------------------------
	//| Apresenta o MarkBrowse para o usuario se houver dados
	//+------------------------------------------------------
	If !SF1->(EOF()) .And. !SF1->(BOF())
		MarkBrow("SF1","F1_OK","SF1->F1_REMITO",aCampos,(mv_par06==1),GetMark(,"SF1","F1_OK"))
	Else
		MsgInfo("Não há dados para apresentar nas tabela de documentos fiscais de entrada. Verifique os parâmetros.")
	Endif
	
	//+-------------------------
	//| Desfaz o indice e filtro
	//+-------------------------
	dbSelectArea("SX2")
	RetIndex("SX2")
	dbClearFilter()
	AEval(aIndex,{|x| Ferase(x[1]+OrdBagExt())})

Return

//+-------------------------------------------------------------+
//| Rotina | MrkBrwPesq | Autor | Robson Luiz | Data | 01.01.04 |
//+-------------------------------------------------------------+
//| Descr. | Rotina de pesquisa de registro no browse filtrado  |
//+-------------------------------------------------------------+
//| Uso    | Oficina de Programação                             |
//+-------------------------------------------------------------+
User Function MrkBrwPesq()
AxPesqui()
Eval(bFiltraBrw)
Return(.T.)

//+-------------------------------------------------------------+
//| Rotina | MrkBrwProc | Autor | Robson Luiz | Data | 01.01.04 |
//+-------------------------------------------------------------+
//| Descr. | Rotina de processamento dos registro seleiconados  |
//+-------------------------------------------------------------+
//| Uso    | Oficina de Programação                             |
//+-------------------------------------------------------------+
User Function MrkBrwProc()
	Local cReg := ""
	
	If !MsgYesNo("Confirma o processamento do registros marcados?")
		Return
	Endif
	
	SF1->(dbGoTop())
	While !SF1->(EOF())
		If IsMark("F1_OK",ThisMark(),ThisInv())
			cReg += SF1->( F1_SERIE+" "+F1_DOC+" "+F1_FORNECE+" "+F1_LOJA )+Chr(13)+Chr(10)
			SF1->(RecLock("SF1",.F.))
			SF1->F1_REMITO := "S"
			SF1->(MsUnLock())
		Endif
		SF1->(dbSkip())
	End
	
	MsgInfo("Os registros processados foram: "+Chr(13)+Chr(10)+cReg)
	
Return

User Function MrkBrwLeg()
Local aCor := {}
	
aAdd(aCor,{"BR_VERDE"   ,"Não Processado"})
aAdd(aCor,{"BR_VERMELHO","Processado"    })

BrwLegenda(cCadastro,"Status dos documentos",aCor)	

Return
