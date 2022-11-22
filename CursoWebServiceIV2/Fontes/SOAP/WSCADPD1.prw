#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"

/*---------------------------------------------------------------------------------------
{Protheus.doc} WSCADPD1
Rdmake 	Web Service SOAP para verificar se produto existe ou n�o	
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
WSSTRUCT StructProduto
	WSDATA cRetorno	As String
	WSDATA cStatus	As String
	WSDATA cCodigo	As String
	WSDATA cDesc	As String Optional

ENDWSSTRUCT

WSSTRUCT StrSendProduto
	WSDATA _cEmpresa 	As String
	WSDATA _cFilial		As String
	WSDATA cCod 		As String
ENDWSSTRUCT

//Definicao do Web Service de Envio de MSG 
WSSERVICE WSCADPD1 DESCRIPTION "Produtos"
	WSDATA StrProduto	As StructProduto
	WSDATA StrSendProd	As StrSendProduto
	WSMETHOD CAD1_PRODUTO DESCRIPTION "M�todo de Cadastro e Atualiza��o de Produtos"
ENDWSSERVICE

//Metodo
WSMETHOD CAD1_PRODUTO WSRECEIVE  StrSendProd  WSSEND StrProduto WSSERVICE WSCADPD1
Local cCodProd

// Prepara ambiente a ser processado
RpcSetEnv(::StrSendProd:_cEmpresa,::StrSendProd:_cFilial,,,"FAT",)
//Validar c�digo de produto o mesmo � obrigat�rio
cCodProd := ::StrSendProd:cCod
If Empty(cCodProd) .or. AllTrim(cCodProd) == "?"
	::StrProduto:cRetorno := "Codigo de Produto n�o informado obrigat�rio ! "
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
	Else
		::StrProduto:cRetorno := "Produto n�o localizado" 
		::StrProduto:cStatus  := "0"
		::StrProduto:cCodigo  := "NAO LOCALIZADO"
	Endif
Endif
Return .T. 
