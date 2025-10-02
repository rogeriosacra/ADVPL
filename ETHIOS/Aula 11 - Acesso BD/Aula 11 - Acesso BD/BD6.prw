#include 'protheus.ch'
#include 'parmtype.ch'

/*/ {Protheus.doc} User Function BD6
    (Exemplos de funcoes de Banco de Dados)
    @type		Function
    @author		Milton J.dos Santos
    @since		01/03/2020
    @version	1.0.0
    @param		Nenhum
    @return		Vazio (nil)
    @example    (examples)
    @see		(https://tdn.totvs.com/display/tec/Banco+de+Dados)
/*/

User Function BD6()
Local cAlias := "SB1"

Private cTitulo := "Cadastro Produtos MBROWSE"
Private aRotina := {}
	
aAdd(aRotina,{"Pesquisar"	,"AxPesqui"		,0,1})
aAdd(aRotina,{"Visualizar"	,"AxVisual"		,0,2})
aAdd(aRotina,{"Incluir" 	,"AxInclui"		,0,3})
aAdd(aRotina,{"Trocar" 		,"AxAltera"		,0,4})
aAdd(aRotina,{"Excluir" 	,"AxDeleta"		,0,5})
aAdd(aRotina,{"OlaMundo"	,"U_OLAMUNDO"	,0,6})
	
dbSelectArea(cAlias)
dbSetOrder(1)
mBrowse(,,,,cAlias)

Return

User Function OlaMundo
MsgAlert("Ola Mundo !")
Return

