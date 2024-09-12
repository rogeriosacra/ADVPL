#include "totvs.ch"
#include "protheus.ch"




User Function SARRA01()
 
Local cLinha  := ""
Local lPrim   := .T.
Local aCampos := {}
Local aDados  := {}
//Local i,j
local cTabela :=''
Local ctab := Space(3)
Local aPergs     := {}

//Adiciona a pergunta e mostra a pergunta
aAdd(aPergs, {1, "Tabela" , ctab, "", ".T.", ""   , ".T.",10, .T.})
aAdd(aPergs ,{6,"Aponte o arquivo:",Space(200),"","","",70,.T.,"Arquivos .CSV |*.CSV"}) 
aAdd(aPergs ,{9,"Está rotina importa um arquivo .csv e gerar registros no sistema usando reclock.",200, 40,.T.})
aAdd(aPergs ,{9,"Campos do tipo data DD/MM/AAAA - NUMERICO 10000,99 OU 10000.99 .",200, 40,.T.})     

If !ParamBox(aPergs, "Informe os parâmetros")
    Return()  
EndIf


 
if empty(MV_PAR02) .or. empty(MV_PAR01)   
   Return()
endif

cTabela := Alltrim(Upper(MV_PAR01))
 
Private aErro := {}
  
FT_FUSE(MV_PAR02)
ProcRegua(FT_FLASTREC())
FT_FGOTOP()
While !FT_FEOF()
 
	IncProc("Lendo arquivo texto...")
 
	cLinha := FT_FREADLN()
 
	If lPrim
		aCampos := Separa(upper(cLinha),";",.T.)
		lPrim := .F.
	Else
		AADD(aDados,Separa(cLinha,";",.T.))
	EndIf
 
	FT_FSKIP()
EndDo
 

Processa({|| SARRA002(cTabela,aCampos,aDados)}, "Impotando...")

Return
Static Function SARRA002(cTabela,aCampos,aDados)
	
Local i,j

Begin Transaction
	ProcRegua(Len(aDados))
	For i:=1 to Len(aDados)
 
		IncProc("Importando...")
 
		dbSelectArea(cTabela)
		dbSetOrder(1)
		dbGoTop()
	//	If !dbSeek(xFilial(cTabela)+aDados[i,1])
			
			Reclock(cTabela,.T.)
			 //(cTabela)->A1_FILIAL := xFilial(cTabela)
			For j:=1 to Len(aCampos)
				
				IF GetSX3Cache(aCampos[j], "X3_CONTEXT") = "V"
					LOOP
					//SE O CAMPO FOR VIRTUAL NÃO FAZ NADA	 
				ELSEIF empty(aCampos[j])
					LOOP // Se o campo estiver vazio
				ELSEIF GetSX3Cache(aCampos[j], "X3_TIPO") = "D"
					cCampo  := (cTabela)+"->"+aCampos[j]
					&cCampo := CToD(aDados[i,j])
				ELSEIF GetSX3Cache(aCampos[j], "X3_TIPO") = "N"
					cCampo  := (cTabela)+"->"+aCampos[j]
					&cCampo := Val(StrTran(aDados[i,j],",","."))
				Else
					cCampo  := (cTabela)+"->"+aCampos[j]
					&cCampo := aDados[i,j]
				ENDIF
			Next j
			(cTabela)->(MsUnlock())
	//	EndIf
	Next i
End Transaction
 
FT_FUSE()
 
ApMsgInfo("Importação finalizada","SUCESSO")
 
Return
