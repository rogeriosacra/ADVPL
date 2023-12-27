#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"

/*---------------------------------------------------------------------------------------
{Protheus.doc} WSCADPD2
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
			Melhorar a funcionalidade constru�da no WSCADPD1 melhorar as valida��es 
--------------------------------------------------------------------------------------*/
//Definicao da estruturas utilizadas
WSSTRUCT StructProd2
	WSDATA cRetorno	As String
	WSDATA cStatus	As String
	WSDATA cCodigo	As String
	WSDATA cDescri	As String
	WSDATA cTipor	As String
	WSDATA cLocpadr	As String
	

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

//Definicao do Web Service de Envio de MSG e relacionamento com as estruturas
WSSERVICE WSCADPD2 DESCRIPTION "Produtos"
	WSDATA StrProduto	As StructProd2
	WSDATA StrSendProd	As StrSendProd2
	WSMETHOD CAD2_PRODUTO DESCRIPTION "M�todo de Cadastro e Atualiza��o de Produtos"
ENDWSSERVICE

//Metodo
WSMETHOD CAD2_PRODUTO WSRECEIVE  StrSendProd  WSSEND StrProduto WSSERVICE WSCADPD2
Local aVetor   	:= {}
Local nPos 		:= 0
Local lAchou
Local cDescProd :=""
Local cCodProd  :="" 

Begin Sequence
	//����������������������������������Ŀ
	//� Prepara ambiente a ser processado�
	//������������������������������������
	RpcSetEnv(::StrSendProd:_cEmpresa,::StrSendProd:_cFilial,,,"FAT",)
	//Validar c�digo de produto o mesmo � obrigat�rio
	cCodProd := ::StrSendProd:cCod
	cDescProd := ::StrSendProd:cDesc
	If Empty(cCodProd) .and. AllTrim(cDescProd) == "?" .AND. Empty(cCodProd) .and. AllTrim(cDescProd) == "?"
		::StrProduto:cRetorno := "Codigo de Produto e descri��o n�o informados, obrigat�rio ! "
		::StrProduto:cStatus  := "0"
		::StrProduto:cCodigo  := cCodProd
		::StrProduto:cCodigo  := cDescProd
		Break
	EndIf

	If !Empty(cCodProd)
	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	//Pesquisa se o produto existe
	lAchou	:= SB1->(DbSeek(xFilial("SB1")+::StrSendProd:cCod))
	EndIf
    
	if !lAchou .AND. !Empty(cDescProd)
	    DbSelectArea("SB1")
		SB1->(DbSetOrder(3))
	 	lAchou := SB1->(DbSeek(xFilial("SB1")+::StrSendProd:cDesc))		
	endif

	if !lAchou
	    ::StrProduto:cRetorno := "PRODUTO N�O LOCALIZADO"
		::StrProduto:cStatus  := "0"
		Break
	endif
	//carrega dados resultantes do dbseek na SB1 em uma Matriz 
	aadd(aVetor,{"B1_COD"	,SB1->B1_COD     		,Nil})
	aadd(aVetor,{"B1_DESC"	,SB1->B1_DESC       	,Nil})
	aadd(aVetor,{"B1_TIPO"	,SB1->B1_TIPO       	,Nil})
	aadd(aVetor,{"B1_UM"	,SB1->B1_UM     		,Nil})
	aadd(aVetor,{"B1_LOCPAD",SB1->B1_LOCPAD	        ,Nil})
	aadd(aVetor,{"B1_GRUPO"	,SB1->B1_GRUPO	        ,Nil})
	
	//Fa�o uma valida��o para verificar se os dados est�o preenchidos
	For nPos := 1 To Len(aVetor)
		If Empty(aVetor[nPos,2]) .or. AllTrim(aVetor[nPos,2]) == "?"
			//posiciona dicionario para localizar o titulo do campo
			SX3->(DbSetOrder(2))
			SX3->(DbSeek(aVetor[nPos,1]))
			::StrProduto:cRetorno := "Dados referente ao campo "+AllTrim(SX3->X3_TITULO)+" n�o informado obrigat�rio ! (" + aVetor[nPos,1]+")"
			::StrProduto:cStatus  := "0"
			::StrProduto:cCodigo  := aVetor[nPos,2]
			Break
		EndIf
	Next
	::StrProduto:cRetorno := "Produto "+If(lAchou,"Localizado","N�o Localizado")+" com sucesso!"
	::StrProduto:cStatus  := If(lAchou,"1","0")
	::StrProduto:cCodigo  := If(lAchou,SB1->B1_COD,"NAO LOCALIZADO")
	::StrProduto:cDescri  := If(lAchou,SB1->B1_DESC,"NAO LOCALIZADO")
	::StrProduto:cTipor   := If(lAchou,SB1->B1_TIPO,"NAO LOCALIZADO")
	::StrProduto:cLocpadr := If(lAchou,SB1->B1_LOCPAD,"NAO LOCALIZADO")
End Sequence
Return .T. 
