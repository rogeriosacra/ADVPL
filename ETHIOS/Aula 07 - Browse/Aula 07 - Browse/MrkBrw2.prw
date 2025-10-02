#Include 'TOTVS.CH'

/*/{Protheus.doc} U_MrkBrw2
    @type		Function
    @author		Milton J.dos Santos
    @since		01/03/2020
    @version	1.0.0
    @param		Nenhum
    @return		Vazio (nil)
    @example    Exemplo da utilizacao de MBrowse 
    @see		https://tdn.totvs.com/display/public/framework/MarkBrow
/*/

User Function MrkBrw2
Local aCampos := {	{"CB_OK"		,,''		},;
					{"CB_USERLIB"	,,"Usuario"	},;
					{"CB_TABHORA"	,,"Hora"	},;
					{"CB_DTTAB"		,,"Data"	}}

Private cMarca		:= GetMark()
Private cCadastro	:= "Cadastro de Contrato"
Private aRotina		:= { { "Pesquisar" , "AxPesqui" , 0, 1 }}

MarkBrow( "SCB", "CB_OK","!CB_USERLIB",aCampos,, cMarca,"MarkAll()",,,,"Mark()" )

Return

// Grava marca no campo

Static Function Mark()

RecLock( "SCB", .F. )
If IsMark( "CB_OK", cMarca )
	Replace CB_OK With Space(2)
Else
	Replace CB_OK With cMarca
EndIf
MsUnLock()

Return

// Grava marca em todos os registros válidos

Static Function MarkAll()
Local nRecno := Recno()

dbSelectArea("SCB")
dbGotop()
Do While !Eof()
	Mark()
	dbSkip()
Enddo
dbGoto( nRecno )

Return
