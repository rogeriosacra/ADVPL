#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"

/*---------------------------------------------------------------------------------------
{Protheus.doc} WSCADPD3
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
			Melhorar a funcionalidade construída no WSCADPD2 montar um ExecAuto  
			B1_TIPO 	= PA   	PRODUTO ACABADO
			B1_UM"		= PC	PECAS
			B1_LOCPAD 	= 01	ARMAZEM PADRAO
			B1_GRUPO	= 0004 	ELETRONICOS

--------------------------------------------------------------------------------------*/
//Definicao da estruturas utilizadas 
WSSTRUCT StructProd3
	WSDATA cRetorno	As String
	WSDATA cStatus	As String
	WSDATA cCodigo	As String
ENDWSSTRUCT

WSSTRUCT StrSendProd3
	WSDATA _cEmpresa 	As String
	WSDATA _cFilial		As String
	WSDATA cCod 		As String
	WSDATA cDesc 		As String
	WSDATA cTipo 		As String
	WSDATA cUm 			As String
	WSDATA cLocpad 		As String
	WSDATA cGrupo 		As String
ENDWSSTRUCT

// Definicao do Web Service de Envio de MSG // Definicao do Web Service de Envio de MSG 
WSSERVICE WSCADPD3 DESCRIPTION "Produtos"
	WSDATA StrProduto	As StructProd3
	WSDATA StrSendProd	As StrSendProd3
	WSMETHOD CAD3_PRODUTO DESCRIPTION "Método de Cadastro e Atualização de Produtos"
ENDWSSERVICE

//Metodo
WSMETHOD CAD3_PRODUTO WSRECEIVE  StrSendProd  WSSEND StrProduto WSSERVICE WSCADPD3
Local aVetor   	:= {}
Local nPos 		:= 0
Local lAchou
Local nOpc
Local aErro 
Local cErro 

Private lMsHelpAuto     := .T. // Se .T. direciona as mensagens de help para o arq. de log
Private lMsErroAuto     := .F.
Private lAutoErrNoFile  := .T. // Precisa estar como .T. para GetAutoGRLog() retornar o array com erros

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
	lAchou	:= SB1->(DbSeek(xFilial("SB1")+AllTrim(cCodProd)))

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
			::StrProduto:cRetorno := "Dados referente ao campo "+AllTrim(SX3->X3_DESCRIC)+" não informado obrigatório ! (" + aVetor[nPos,1]+")"
			::StrProduto:cStatus  := "0"
			::StrProduto:cCodigo  := aVetor[nPos,2]
			Break
		EndIf
	Next
	nOpc := If(lAchou,4,3)
	MSExecAuto({|x,y| Mata010(x,y)},aVetor,nOpc) //3- Inclusão, 4- Alteração, 5- Exclusão
	IF lMsErroAuto
		aErro := GetAutoGRLog() // Retorna erro em array
		cErro := ""
		For nPos := 1 to len(aErro)
			cErro += aErro[ nPos ] + CRLF
		Next nPos
 		::StrProduto:cRetorno := cErro
		::StrProduto:cStatus  := "0"
		::StrProduto:cCodigo  := "ERROEXECAUTO "+If(nOpc==3,"Incluindo","Alterando")
		Break
	Endif
	::StrProduto:cRetorno := "Produto "+If(nOpc==3,"Incluindo","Alterado")+" com sucesso!"
	::StrProduto:cStatus  := "1"
	::StrProduto:cCodigo  := SB1->B1_COD
End Begin
Return .T. 
