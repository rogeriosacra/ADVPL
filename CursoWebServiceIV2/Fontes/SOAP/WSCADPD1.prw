#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"

/*---------------------------------------------------------------------------------------
{Protheus.doc} WSCADPD1
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
--------------------------------------------------------------------------------------*/
//Definicao da estruturas utilizadas
WSSTRUCT StructProduto // ESTRUTURA DE RETORNO
	WSDATA cRetorno	As String
	WSDATA cStatus	As String
	WSDATA cCodigo	As String
	WSDATA cArmazem	As String
	WSDATA cDesc	As String Optional

ENDWSSTRUCT

WSSTRUCT StrSendProduto //ESTRUTURA DE ENVIO, ENVIADA PELO CLIENTE: EMPRESA, FILIAL E CÓDIGO
	WSDATA _cEmpresa 	As String
	WSDATA _cFilial		As String
	WSDATA cCod 		As String
ENDWSSTRUCT

//Definicao do Web Service de Envio de MSG 
WSSERVICE WSCADPD1 DESCRIPTION "Produtos" //WSCADPD1: NOTE QUE O WEBSERICE RECEBEU O MESMO NOME DO CÓDIGO FONTE, E FOI DESCRITO COMO "PRODUTOS"
	WSDATA StrProduto	As StructProduto // ESTRUtuRA DE retorno StructProduto DECLARADA NA LINHA 24, TEM SUA ESTRUTURA JOGADA PARA STRPRODUTO 
	WSDATA StrSendProd	As StrSendProduto//// ESTRUtuRA DE ENVIO StrSendtProdo DECLARADA NA LINHA 33, TEM SUA ESTRUTURA JOGADA PARA StrSendtProdo
	WSMETHOD CAD1_PRODUTO DESCRIPTION "Método de Cadastro e Atualização de Produtos" //Declaração do método CAD1_PRODUTO e sua descrição
ENDWSSERVICE

//Metodo CAD1_PRODUTO RECEBE SrtSendProd ENVIA/RETORNA StrProduto no web service WSCADPD1
WSMETHOD CAD1_PRODUTO WSRECEIVE  StrSendProd  WSSEND StrProduto WSSERVICE WSCADPD1
Local cCodProd

// RpcSetEnv Prepara ambiente a ser processado
RpcSetEnv(::StrSendProd:_cEmpresa,::StrSendProd:_cFilial,,,"FAT",)
//Validar código de produto o mesmo é obrigatório
cCodProd := ::StrSendProd:cCod//::StrSendProd:cCod, captura o código do produto do objeto StrSendoProd, poderia ser Self:StrSendProd:_cFilial
If Empty(cCodProd) .or. AllTrim(cCodProd) == "?"
	::StrProduto:cRetorno := "Por favor informar o cógido do produto ! "
	::StrProduto:cStatus  := "0"
	::StrProduto:cCodigo  := cCodProd
Else
	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))  //FILIAL + COD
	//Pesquisa se o produto existe
	If SB1->(DbSeek(xFilial("SB1")+cCodProd))
		::StrProduto:cRetorno := "Produto Localizado com sucesso!"
		::StrProduto:cStatus  := "1"
		::StrProduto:cCodigo  := SB1->B1_COD
		::StrProduto:cDesc    := SB1->B1_DESC
		::StrProduto:cArmazem := SB1->B1_LOCPAD

	Else
		::StrProduto:cRetorno := "Produto não localizado" 
		::StrProduto:cStatus  := "0"
		::StrProduto:cCodigo  := "NAO LOCALIZADO"
	Endif
Endif
Return .T. 
