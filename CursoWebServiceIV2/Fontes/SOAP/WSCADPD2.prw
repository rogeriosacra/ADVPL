#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"

/*---------------------------------------------------------------------------------------
{Protheus.doc} WSCADPD2
Rdmake 	Web Service SOAP para verificar se produto existe ou não	
@class    	Nao Informado
@from       Nao Informado
@param      Nao Informado
@attrib    	Nao Informado
@protected  Nao Informado
@author     DAC Denilso 
@single		30/09/2020
@version    Nao Informado
@since      Nao Informado  
@return    	Logico
@sample     Nao Informado
@obs        Nao Informado
@project    Curso WS Iv2
@menu       Nao Informado
@history    ex prod cadastrado TINTA PRETA  
			Melhorar a funcionalidade construída no WSCADPD1 melhorar as validações 
--------------------------------------------------------------------------------------*/
//Definicao da estruturas utilizadas
WSSTRUCT StructProd2
	WSDATA cRetorno	As String
	WSDATA cStatus	As String
	WSDATA cCodigo	As String
ENDWSSTRUCT

WSSTRUCT StrSendProd2
	WSDATA _cEmpresa 	As String
	WSDATA _cFilial		As String
	WSDATA cCod 		As String
	WSDATA cDesc 		As String
	WSDATA cTipo 		As String 
	WSDATA cUm 			As String
	WSDATA cLocpad 		As String
	WSDATA cGrupo 		As String
ENDWSSTRUCT

//Definicao do Web Service de Envio de MSG 
WSSERVICE WSCADPD2 DESCRIPTION "Produtos"
	WSDATA StrProduto	As StructProd2
	WSDATA StrSendProd	As StrSendProd2
	WSMETHOD CAD2_PRODUTO DESCRIPTION "Método de Cadastro e Atualização de Produtos"
ENDWSSERVICE

//Metodo
WSMETHOD CAD2_PRODUTO WSRECEIVE  StrSendProd  WSSEND StrProduto WSSERVICE WSCADPD2
Local aVetor   	:= {}
Local nPos 		:= 0
Local lAchou

Begin Sequence
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Prepara ambiente a ser processado³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RpcSetEnv(::StrSendProd:_cEmpresa,::StrSendProd:_cFilial,,,"FAT",)
	//Validar código de produto o mesmo é obrigatório
	cCodProd := ::StrSendProd:cCod
	If Empty(cCodProd) .or. AllTrim(cCodProd) == "?"
		::StrProduto:cRetorno := "Codigo de Produto não informado obrigatório ! "
		::StrProduto:cStatus  := "0"
		::StrProduto:cCodigo  := cCodProd
		Break
	EndIf
	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	//Pesquisa se o produto existe
	lAchou	:= SB1->(DbSeek(xFilial("SB1")+::StrSendProd:cCod))

	//carrega dados  em uma Matriz
	aadd(aVetor,{"B1_COD"	,cCodProd				,Nil})
	aadd(aVetor,{"B1_DESC"	,::StrSendProd:cDesc	,Nil})
	aadd(aVetor,{"B1_TIPO"	,::StrSendProd:cTipo	,Nil})
	aadd(aVetor,{"B1_UM"	,::StrSendProd:cUm		,Nil})
	aadd(aVetor,{"B1_LOCPAD",::StrSendProd:cLocpad	,Nil})
	aadd(aVetor,{"B1_GRUPO"	,::StrSendProd:cGrupo	,Nil})
	
	//Faço uma validação para verificar se os dados estão preenchidos
	For nPos := 1 To Len(aVetor)
		If Empty(aVetor[nPos,2]) .or. AllTrim(aVetor[nPos,2]) == "?"
			//posiciona dicionario para localizar o titulo do campo
			SX3->(DbSetOrder(2))
			SX3->(DbSeek(aVetor[nPos,1]))
			::StrProduto:cRetorno := "Dados referente ao campo "+AllTrim(SX3->X3_TITULO)+" não informado obrigatório ! (" + aVetor[nPos,1]+")"
			::StrProduto:cStatus  := "0"
			::StrProduto:cCodigo  := aVetor[nPos,2]
			Break
		EndIf
	Next
	::StrProduto:cRetorno := "Produto "+If(lAchou,"Localizado","Não Localizado")+" com sucesso!"
	::StrProduto:cStatus  := If(lAchou,"1","0")
	::StrProduto:cCodigo  := If(lAchou,SB1->B1_COD,"NAO LOCALIZADO")
End Sequence
Return .T. 
