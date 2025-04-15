#include 'Protheus.ch'
#Include 'parmtype.ch'

User Function MBROZZ9()

	Local cAlias := "ZZ9"
	Private cTitulo := "Acessos X Usuários X Rotina"
	Private aRotina := {}

	AADD(aRotina,{"Pesquisei",  "AxPesquisa", 0,1})
	AADD(aRotina,{"Visualizar", "AxVisual"  , 0,2})
	AADD(aRotina,{"Incluir",    "AxInclui"  , 0,3})
	AADD(aRotina,{"Troquei",    "AxAltera"  , 0,4})
	AADD(aRotina,{"Excluir",    "AxDeleta"  , 0,5})
	AADD(aRotina,{"Auditoria",  "U_Modelo1" , 0,5})

	DbSelectArea(cAlias)
	DbSetOrder(1)
	Mbrowse(,,,,cAlias)
//Mbrowse(6,1,22,75,cAlias)



Return
