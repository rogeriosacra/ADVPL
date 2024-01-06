#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#Include 'FWMVCDEF.CH'
#INCLUDE "RESTFUL.CH"

#DEFINE AFIELDS_JSON	4

//dummy function
//User Function amats030()
//Return

/*/{Protheus.doc} NcustomerVendor

API de integra��o de Cadastro de Cliente/Fornecedor

@author		Squad Faturamento/SRM
@since		02/08/2018
/*/
WSRESTFUL NcustomerVendor DESCRIPTION "Cadastro de Cliente/Fornecedor" //"Cadastro de Cliente/Fornecedor" CRIA��O DA CLASSE NCUSTOMERVENDOR
	WSDATA Fields			AS STRING	OPTIONAL //FIELDS, ORDER, PAGE, PAGESIZE, ETC, S�O PROPRIEDADES DA CLASSE E SEUS TIPOS
	WSDATA Order			AS STRING	OPTIONAL
	WSDATA Page				AS INTEGER	OPTIONAL
	WSDATA PageSize			AS INTEGER	OPTIONAL
	WSDATA Type				AS STRING	OPTIONAL
	WSDATA NcustomerVendorId AS STRING	OPTIONAL
	
    WSMETHOD GET Main ; // CRIA��O DOS M�TODOS GET, POST, DELETE, PUT. NOTE QUE DEPOIS DO VERBO, H� UM NOME, MAIS, TYPE, ETC,QUE SERVE COMO IDENTIFICADOR
    DESCRIPTION "Retorna todos Clientes/Fornecedores" ;//DESCRI��O QUE SER� APRESENTADA NO SERVIDOR REST 
    WSSYNTAX "/api/crm/v1/NcustomerVendor/{Order, Page, PageSize, Fields}" ;//SINTAX HTTP, E DENTRO DAS CHAVES OS PAR�METROS DA SYNTAX
    PATH "/api/crm/v1/NcustomerVendor"	// CAMINHO ONDE O ENDPOINT ACIONA O M�TODO

    WSMETHOD POST Main ;
    DESCRIPTION "Cadastra um Clientes/Fornecedores" ;
    WSSYNTAX "/api/crm/v1/NcustomerVendor/{Fields}" ;
    PATH "/api/crm/v1/NcustomerVendor"	

    WSMETHOD GET Type ;
    DESCRIPTION "Retorna todos Clientes ou Fornecedores" ;
    WSSYNTAX "/api/crm/v1/NcustomerVendor/{Type}{Order, Page, PageSize, Fields}" ;
    PATH "/api/crm/v1/NcustomerVendor/{Type}"	

    WSMETHOD GET EspecID ;
    DESCRIPTION "Retorna um cliente/fornecedor espec�fico" ;
    WSSYNTAX "/api/crm/v1/NcustomerVendor/{Type}/{NcustomerVendorId}{Order, Page, PageSize, Fields}" ;
    PATH "/api/crm/v1/NcustomerVendor/{Type}/{NcustomerVendorId}"		

    WSMETHOD PUT EspecID ;
    DESCRIPTION "Altera um cliente/fornecedor espec�fico" ;
    WSSYNTAX "/api/crm/v1/NcustomerVendor/{Type}/{NcustomerVendorId}{Order, Page, PageSize, Fields}" ;
    PATH "/api/crm/v1/NcustomerVendor/{Type}/{NcustomerVendorId}"			

    WSMETHOD DELETE EspecID ;
    DESCRIPTION "Deleta um cliente/fornecedor espec�fico" ;
    WSSYNTAX "/api/crm/v1/NcustomerVendor/{Type}/{NcustomerVendorId}{Order, Page, PageSize, Fields}" ;
    PATH "/api/crm/v1/NcustomerVendor/{Type}/{NcustomerVendorId}"				

 
ENDWSRESTFUL //FINLIZA��O DA DECLARA��O DA CLASSE

/*/{Protheus.doc} GET / NcustomerVendor/NcustomerVendor
Retorna todos Clientes/Fornecedores

@param	Order		, caracter, Ordena��o da tabela principal
@param	Page		, num�rico, N�mero da p�gina inicial da consulta
@param	PageSize	, num�rico, N�mero de registro por p�ginas
@param	Fields		, caracter, Campos que ser�o retornados no GET.

@return lRet	, L�gico, Informa se o processo foi executado com sucesso.

@author		Squad Faturamento/CRM
@since		06/08/2018
@version	12.1.20
/*/

WSMETHOD GET Main WSRECEIVE Order, Page, PageSize, Fields WSSERVICE NcustomerVendor//METODO GET MAIN (MAIN � ID, IDENTIFICADOR)RECEBE PARAMETROS ORDER, PAGE, E RELACIONA COM CLASSE NCUSTMER VENDOR

	Local lRet				:= .T.
	Local lRetCli			:= .T.
	Local lRetForn			:= .T.
	Local oApiManager		:= Nil
	Local cJson				:= ""
	Local cError			:= ""
	Local lHasNext			:= .F.
	Local nX				:= 0
	Local nPageSize			:= 0
	Local nPageCli			:= 0
	Local nPageFor			:= 0
	Local nPosPagesize		:= (aScan(Self:aQueryString ,{|x| Upper(AllTrim(x[1])) == "PAGESIZE"}))
	Local oJson				:= Nil

    Self:SetContentType("application/json")

	oApiManager := FWAPIManager():New("MATS030","2.006") 

	If nPosPagesize > 0
		nPageSize := Self:aQueryString[nPosPagesize][2]
	Else
		nPageSize := oApiManager:GetApiPgSize()
	EndIf'

	If Mod(nPageSize,2) > 0
		nPageCli := Int(nPageSize/2) + 1
	Else
		nPageCli := Int(nPageSize/2)
	EndIf

	nPageFor := Int(nPageSize/2)

	If nPosPagesize > 0
		Self:aQueryString[nPosPagesize][2] := nPageCli
	Else
		aAdd(Self:aQueryString,{"PAGESIZE", nPageCli})
	EndIf

	lRetCli := AGetCli(@oApiManager, Self)

	If lRetCli
		oJson := oApiManager:GetJsonObject()
		If !lHasNext
			lHasNext := oJson['hasNext']
		EndIf 
		For nX := 1 To Len(oJson['items'])
			cJson += EncodeUtf8(FwJsonSerialize(oJson['items'][nX],.T.,.T.))
			If nX != Len(oJson['items'])
				cJson += ','
			EndIf
		Next
	EndIf
				
	oApiManager:Destroy()

	If nPageFor > 0
		oApiManager := FWAPIManager():New("MATS030","2.006") 

		If nPosPagesize > 0
			Self:aQueryString[nPosPagesize][2] := nPageFor
		Else
			aAdd(Self:aQueryString,{"PAGESIZE", nPageFor})
		EndIf

		lRetForn := U_ATS020G(oApiManager, Self)
		
		If lRetForn
			If !Empty(cJson)
				cJson += ","
			EndIf

			oJson := oApiManager:GetJsonObject()
			
			If !lHasNext
				lHasNext := oJson['hasNext']
			EndIf 

			For nX := 1 To Len(oJson['items'])
				cJson += EncodeUtf8(FwJsonSerialize(oJson['items'][nX],.T.,.T.))
				If nX != Len(oJson['items'])
					cJson += ','
				EndIf
			Next
		EndIf

		oApiManager:Destroy()
	EndIf

	If lRet
		cJson := '{"items": [' + cJson + ' ], "hasNext": '+ IIF(lHasNext, 'true', 'false') +'}'
		Self:SetResponse( cJson )
	Else
		cError := oApiManager:GetJsonError()	
		SetRestFault( Val(oApiManager:oJsonError['code']), EncodeUtf8(cError) )
	EndIf
	
Return lRet

/*/{Protheus.doc} POST / NcustomerVendor/NcustomerVendor
Cadastra um Clientes/Fornecedores

@param	Fields		, caracter, Campos que ser�o retornados no GET.

@return lRet	, L�gico, Informa se o processo foi executado com sucesso.

@author		Squad Faturamento/CRM
@since		06/08/2018
@version	12.1.20
/*/
WSMETHOD POST Main WSRECEIVE Order, Page, PageSize, Fields WSSERVICE NcustomerVendor

	Local aFilter		:= {}
	Local aJson			:= {}
    Local lRet			:= .T.
    Local oJsonPositions:= JsonObject():New()
	Local oApiManager 	:= FWAPIManager():New("MATS030","2.006")
	Local oJson			:= THashMap():New()
	Local cBody 	  	:= DecodeUtf8(Self:GetContent())
	Local cError		:= ""
	Self:SetContentType("application/json")
    

	oApiManager:SetApiAlias({"SA1","items", "items"})
	oApiManager:SetApiMap(AAPIMapSA1())
	oApiManager:Activate()

	lRet = FWJsonDeserialize(cBody,@oJson)

	If lRet
		If AttIsMemberOf(oJson,"type")
			If oJson:type == 1
				lRet := AManutCliente(oApiManager, Self:aQueryString, 3, aJson,, oJson, cBody)
				If lRet
					Aadd(aFilter, {"SA1", "items",{"A1_COD = '" + SA1->A1_COD + "'"}})
					Aadd(aFilter, {"SA1", "items",{"A1_LOJA = '" + SA1->A1_LOJA + "'"}})
					oApiManager:SetApiFilter(aFilter) 	
					lRet := AGetCli(@oApiManager, Self)
				EndIf
			Elseif oJson:type == 2				
				lRet := U_AMATS020(oApiManager, Self:aQueryString, 3, Self:NcustomerVendorId, oJson, cBody)
				If lRet
					Aadd(aFilter, {"SA2", "items",{"A2_COD = '" + SA2->A2_COD + "'"}})
					Aadd(aFilter, {"SA2", "items",{"A2_LOJA = '" + SA2->A2_LOJA + "'"}})
					oApiManager:SetApiFilter(aFilter) 	
					lRet := U_ATS020G(@oApiManager, Self, aFilter)
				EndIf
			ElseIF oJson:type == 3
				lRet := .F.
				oApiManager:SetJsonError("400","Opera��o n�o dispon�vel no Protheus!", "Especifique se o tipo � cliente ou fornecedor. O Protheus n�o trabalha com a op��o ambos.",/*cHelpUrl*/,/*aDetails*/)
			Else
				lRet := .F.
				oApiManager:SetJsonError("400","Erro ao incluir o cliente/fornecedor!", "Tipo informado n�o encontrado.",/*cHelpUrl*/,/*aDetails*/)
			Endif
		Else
			lRet := .F.
			oApiManager:SetJsonError("400","Erro ao incluir o cliente/fornecedor!", "Informe um tipo v�lido.",/*cHelpUrl*/,/*aDetails*/)
		EndIf
	Else
		lRet := .F.
		oApiManager:SetJsonError("400","Erro ao alterar o cliente/fornecedor!", "N�o foi poss�vel tratar o Json recebido.",/*cHelpUrl*/,/*aDetails*/)
	EndIf

	If lRet
		Self:SetResponse( oApiManager:ToObjectJson() )
	Else
		cError := oApiManager:GetJsonError()
		SetRestFault( Val(oApiManager:oJsonError['code']), EncodeUtf8(cError) )
	EndIf

	oApiManager:Destroy()
	aSize(aJson,0)
    FreeObj( oJsonPositions )

Return lRet

/*/{Protheus.doc} GET / NcustomerVendor/{Type}
Retorna todos Clientes ou Fornecedores

@param	Type				, caracter, Entidade a ser alterada (Cliente ou fornecedor)
@param	Order		, caracter, Ordena��o da tabela principal
@param	Page		, num�rico, Numero da p�gina inicial da consulta
@param	PageSize	, num�rico, Numero de registro por p�ginas
@param	Fields		, caracter, Campos que ser�o retornados no GET.

@return lRet	, L�gico, Informa se o processo foi executado com sucesso.

@author		Squad Faturamento/CRM
@since		06/08/2018
@version	12.1.20
/*/

WSMETHOD GET Type PATHPARAM Type WSRECEIVE Order, Page, PageSize, Fields WSSERVICE NcustomerVendor

	Local lRet				:= .T.
	Local oApiManager		:= Nil
	Local cError			:= ""

    Self:SetContentType("application/json")

	oApiManager := FWAPIManager():New("MATS030","2.006") 

	If Self:Type == "1"
		lRet := AGetCli(@oApiManager, Self)
	ElseIf Self:Type == "2"
		lRet := U_ATS020G(oApiManager, Self)
	Else
		lRet := .F.
		oApiManager:SetJsonError("400","Erro ao consultar o cliente/fornecedor!", "Tipo informado n�o encontrado.",/*cHelpUrl*/,/*aDetails*/)
	EndIf

	If lRet
		Self:SetResponse( oApiManager:GetJsonSerealize() )
	Else
		cError := oApiManager:GetJsonError()	
		SetRestFault( Val(oApiManager:oJsonError['code']), EncodeUtf8(cError) )
	EndIf
	
	FreeObj(oApiManager)

Return lRet

/*/{Protheus.doc} GET / NcustomerVendor/{Type}/{NcustomerVendorId}
Retorna um cliente/fornecedor espec�fico

@param	Type				, caracter, Entidade a ser alterada (Cliente ou fornecedor)
@param	NcustomerVendorId	, caracter, C�digo do cliente/vendedor alterado
@param	Order		, caracter, Ordena��o da tabela principal
@param	Page		, num�rico, Numero da p�gina inicial da consulta
@param	PageSize	, num�rico, Numero de registro por p�ginas
@param	Fields		, caracter, Campos que ser�o retornados no GET.

@return lRet	, L�gico, Informa se o processo foi executado com sucesso.

@author		Squad Faturamento/CRM
@since		06/08/2018
@version	12.1.20
/*/

WSMETHOD GET EspecID PATHPARAM Type, NcustomerVendorId WSRECEIVE Order, Page, PageSize, Fields WSSERVICE NcustomerVendor

	Local aFilter			:= {}
	Local cError			:= ""
	Local lRet				:= .T.
	Local oApiManager		:= Nil
	Local nLenFields		:= TamSX3("A1_COD")[1] + TamSX3("A1_LOJA")[1]

    Self:SetContentType("application/json")

	oApiManager := FWAPIManager():New("MATS030","2.006") 

	If Len(Self:NcustomerVendorId) >= nLenFields
		If Self:Type == "1"
			Aadd(aFilter, {"SA1", "items",{"A1_COD  = '" + SubStr(Self:NcustomerVendorId,1,TamSX3("A1_COD")[1]) 							  + "'"}})
			Aadd(aFilter, {"SA1", "items",{"A1_LOJA = '" + SubStr(Self:NcustomerVendorId,TamSX3("A1_COD")[1] + 1, Len(self:NcustomerVendorId)) + "'"}})
			oApiManager:SetApiFilter(aFilter) 	
			lRet := AGetCli(@oApiManager, Self)
		ElseIf Self:Type == "2"
			Aadd(aFilter, {"SA2", "items",{"A2_COD  = '" + SubStr(Self:NcustomerVendorId,1,TamSX3("A2_COD")[1]) 							  + "'"}})
			Aadd(aFilter, {"SA2", "items",{"A2_LOJA = '" + SubStr(Self:NcustomerVendorId,TamSX3("A2_COD")[1] + 1, Len(self:NcustomerVendorId)) + "'"}})
			lRet := U_ATS020G(oApiManager, Self, aFilter)
		Else
			lRet := .F.
			oApiManager:SetJsonError("400","Erro ao consultar o cliente/fornecedor!", "Tipo informado n�o encontrado.",/*cHelpUrl*/,/*aDetails*/)		
		EndIf
	Else
		lRet := .F.
		oApiManager:SetJsonError("400","Erro ao alterar o cliente!", "O NcustomerVendor ID deve possuir pelo menos "+ cValToChar(nLenFields) +" caracteres.",/*cHelpUrl*/,/*aDetails*/)
	EndIf

	If lRet
		Self:SetResponse( oApiManager:ToObjectJson() )
	Else
		cError := oApiManager:GetJsonError()	
		SetRestFault( Val(oApiManager:oJsonError['code']), EncodeUtf8(cError) )
	EndIf
	
	FreeObj(oApiManager)

Return lRet

/*/{Protheus.doc} PUT / NcustomerVendor/{Type}/{NcustomerVendorId}
Altera um cliente/fornecedor espec�fico

@param	Type				, caracter, Entidade a ser alterada (Cliente ou fornecedor)
@param	NcustomerVendorId	, caracter, C�digo do cliente/vendedor alterado
@param	Order				, caracter, Ordena��o da tabela principal
@param	Page				, num�rico, Numero da p�gina inicial da consulta
@param	PageSize			, num�rico, Numero de registro por p�ginas
@param	Fields				, caracter, Campos que ser�o retornados no GET.

@return lRet	, L�gico, Informa se o processo foi executado com sucesso.

@author		Squad Faturamento/CRM
@since		06/08/2018
@version	12.1.20
/*/

WSMETHOD PUT EspecID PATHPARAM Type, NcustomerVendorId WSRECEIVE Order, Page, PageSize, Fields WSSERVICE NcustomerVendor

	Local aFilter		:= {}
	Local aJson			:= {}
	Local cError		:= ""
    Local lRet			:= .T.
    Local oJsonPositions:= JsonObject():New()
	Local oApiManager 	:= FWAPIManager():New("MATS030","2.006")
	Local oJson			:= THashMap():New()
	Local cBody 	   	:= DecodeUtf8(Self:GetContent())
	Local nLenFields	:= TamSX3("A1_COD")[1] + TamSX3("A1_LOJA")[1]

	Self:SetContentType("application/json")

	oApiManager:SetApiAlias({"SA1","items", "items"})
	oApiManager:SetApiMap(AAPIMapSA1())
	oApiManager:Activate()

	lRet = FWJsonDeserialize(cBody,@oJson)

	If lRet
		If Self:Type == "1"
			If Len(Self:NcustomerVendorId) >= nLenFields
				DBSelectArea("SA1")
				DBSetOrder(1)
				If Dbseek(xFilial("SA1") + Self:NcustomerVendorId)
					lRet := AManutCliente(oApiManager, Self:aQueryString, 4, aJson, Self:NcustomerVendorId, oJson, cBody)
				Else
					oApiManager:SetJsonError("404","Erro ao alterar o cliente!", "Cliente " + AllTrim(Self:NcustomerVendorId) + " n�o encontrado.",/*cHelpUrl*/,/*aDetails*/)
				EndIf
			Else
				lRet := .F.
				oApiManager:SetJsonError("400","Erro ao alterar o cliente!", "O NcustomerVendor ID deve possuir pelo menos "+ cValToChar(nLenFields) +" caracteres.",/*cHelpUrl*/,/*aDetails*/)
			EndIf
		ElseIf Self:Type == "2"
			If Len(Self:NcustomerVendorId) >= nLenFields
				DBSelectArea("SA2")
				DBSetOrder(1)
				If Dbseek(xFilial("SA2") + Self:NcustomerVendorId)
					lRet := U_AMATS020(oApiManager, Self:aQueryString, 4, Self:NcustomerVendorId, oJson, cBody)
				Else
					oApiManager:SetJsonError("404","Erro ao alterar o Fornecedor!", "Fornecedor " + AllTrim(Self:NcustomerVendorId) + " n�o encontrado.",/*cHelpUrl*/,/*aDetails*/)
				EndIf
			Else
				lRet := .F.
				oApiManager:SetJsonError("400","Erro ao alterar o Fornecedor!", "O NcustomerVendor ID deve possuir pelo menos "+ cValToChar(nLenFields) +" caracteres.",/*cHelpUrl*/,/*aDetails*/)
			EndIf
		ElseIf Self:Type == "3"
			lRet := .F.
			oApiManager:SetJsonError("400","Opera��o n�o dispon�vel no Protheus!", "Especifique se o tipo � cliente ou fornecedor. O Protheus n�o trabalha com a op��o ambos.",/*cHelpUrl*/,/*aDetails*/)
		Else
			lRet := .F.
			oApiManager:SetJsonError("400","Erro ao alterar o cliente/fornecedor!", "Tipo informado n�o encontrado.",/*cHelpUrl*/,/*aDetails*/)
		Endif
	Else
		oApiManager:SetJsonError("400","Erro ao alterar o cliente/fornecedor!", "N�o foi poss�vel tratar o Json recebido.",/*cHelpUrl*/,/*aDetails*/)
	EndIf

	If lRet
		If Self:Type == "1"
			Aadd(aFilter, {"SA1", "items",{"A1_COD  = '" + SA1->A1_COD +  "'"}})
			Aadd(aFilter, {"SA1", "items",{"A1_LOJA = '" + SA1->A1_LOJA + "'"}})
			oApiManager:SetApiFilter(aFilter) 	
			lRet := AGetCli(@oApiManager, Self)
		Elseif Self:Type == "2"
			Aadd(aFilter, {"SA2", "items",{"A2_COD = '" + SA2->A2_COD + "'"}})
			Aadd(aFilter, {"SA2", "items",{"A2_LOJA = '" + SA2->A2_LOJA + "'"}})
			oApiManager:SetApiFilter(aFilter) 	
			lRet := U_ATS020G(@oApiManager, Self, aFilter)
		EndIf
	EndIf

	If lRet
		Self:SetResponse( oApiManager:ToObjectJson() )
	Else
		cError := oApiManager:GetJsonError()
		SetRestFault( Val(oApiManager:oJsonError['code']), EncodeUtf8(cError) )
	EndIf

	oApiManager:Destroy()
	aSize(aJson,0)
    FreeObj( oJsonPositions )

Return lRet

/*/{Protheus.doc} DELETE / NcustomerVendor/{type}/{NcustomerVendorId}
Deleta um cliente/fornecedor espec�fico

@param	Type				, caracter, Entidade a ser alterada (Cliente ou fornecedor)
@param	NcustomerVendorId	, caracter, C�digo do cliente/vendedor alterado
@param	Order				, caracter, Ordena��o da tabela principal
@param	Page				, num�rico, Numero da p�gina inicial da consulta
@param	PageSize			, num�rico, Numero de registro por p�ginas
@param	Fields				, caracter, Campos que ser�o retornados no GET.

@return lRet	, L�gico, Informa se o processo foi executado com sucesso.

@author		Squad Faturamento/CRM
@since		06/08/2018
@version	12.1.20
/*/

WSMETHOD DELETE EspecID PATHPARAM Type, NcustomerVendorId WSRECEIVE Order, Page, PageSize, Fields WSSERVICE NcustomerVendor

	Local aJson			:= {}
	Local cResp			:= "Registro Deletado com Sucesso"
	Local cError		:= ""
    Local lRet			:= .T.
    Local oJsonPositions:= JsonObject():New()
	Local oApiManager 	:= FWAPIManager():New("MATS030","2.006")
	Local cBody			:= Self:GetContent()
	Local nLenFields	:= TamSX3("A1_COD")[1] + TamSX3("A1_LOJA")[1]
	
	Self:SetContentType("application/json")

	oApiManager:SetApiAlias({"SA1","items", "items"})
	oApiManager:SetApiMap(AAPIMapSA1())
	oApiManager:Activate()

	If Self:Type == "1"
		If Len(Self:NcustomerVendorId) >= nLenFields
			DBSelectArea("SA1")
			DBSetOrder(1)
			If Dbseek(xFilial("SA1") + Self:NcustomerVendorId)
				lRet := AManutCliente(oApiManager, Self:aQueryString, 5, aJson, Self:NcustomerVendorId, , cBody)
			Else
				lRet := .F.
				oApiManager:SetJsonError("404","Erro ao excluir o cliente!", "Cliente "+ AllTrim( Self:NcustomerVendorId )+ "n�o encontrado.",/*cHelpUrl*/,/*aDetails*/)
			EndIf
		Else
			lRet := .F.
			oApiManager:SetJsonError("400","Erro ao excluir o cliente!", "O NcustomerVendor ID deve possuir pelo menos "+ cValToChar(nLenFields) +" caracteres.",/*cHelpUrl*/,/*aDetails*/)
		EndIf
	ElseIf Self:Type == "2"
		If Len(Self:NcustomerVendorId) >= nLenFields
			DBSelectArea("SA2")
			DBSetOrder(1)
			If Dbseek(xFilial("SA2") + Self:NcustomerVendorId)
				lRet := U_AMATS020(oApiManager, Self:aQueryString, 5, Self:NcustomerVendorId)						
			Else
				lRet := .F.
				oApiManager:SetJsonError("404","Erro ao excluir o Fornecedor!", "Fornecedor " + AllTrim(Self:NcustomerVendorId) + " n�o encontrado.",/*cHelpUrl*/,/*aDetails*/)
			EndIf
		Else
			lRet := .F.
			oApiManager:SetJsonError("400","Erro ao excluir o Fornecedor!", "O NcustomerVendor ID deve possuir pelo menos "+ cValToChar(nLenFields) +" caracteres.",/*cHelpUrl*/,/*aDetails*/)
		EndIf
	ElseIf Self:Type == "3"
		lRet := .F.
		oApiManager:SetJsonError("400","Opera��o n�o dispon�vel no Protheus!", "Especifique se o tipo � cliente ou fornecedor. O Protheus n�o trabalha com a op��o ambos.",/*cHelpUrl*/,/*aDetails*/)
	Else
		lRet := .F.
		oApiManager:SetJsonError("400","Erro ao excluir o cliente/fornecedor!", "Tipo informado n�o encontrado.",/*cHelpUrl*/,/*aDetails*/)
	Endif

	If lRet
		oJsonPositions['response'] := cResp
		cResp := EncodeUtf8(FwJsonSerialize( oJsonPositions, .T. ))
		Self:SetResponse( cResp )
	Else
		cError := oApiManager:GetJsonError()
		SetRestFault( Val(oApiManager:oJsonError['code']), EncodeUtf8(cError) )
	EndIf

	oApiManager:Destroy()
	aSize(aJson,0)
    FreeObj( oJsonPositions )

Return lRet

/*/{Protheus.doc} MontaCab
Monta o array do cabe�alho que ser� utilizado no execauto

@param	oJson				, objeto  , Objeto com o array parseado
@param	aCab				, array   , Array que ser� populado com os dados do Json parciado

@author		Squad Faturamento/CRM
@since		06/08/2018
@version	12.1.20
/*/

Static Function AMontaCab(oJson, aCab)

	If AttIsMemberOf(oJson, "name") .And. AttIsMemberOf(oJson, "id") .And. !Empty(oJson:id) .And. !Empty(oJson:name)
		If AllTrim(oJson:name) $ "INSCRICAO ESTADUAL"
			aAdd( aCab, {'A1_INSCR'		,Upper(oJson:id), Nil}) 
		ElseIf AllTrim(oJson:name) $ "INSCRICAO MUNICIPAL"
			aAdd( aCab, {'A1_INSCRM' 	,Upper(oJson:id), Nil}) 
		ElseIf AllTrim(oJson:name) $ "CNPJ|CPF" 
			aAdd( aCab, {'A1_CGC' 		,oJson:id, Nil}) 
		ElseIf AllTrim(oJson:name) $ "SUFRAMA"
			aAdd( aCab, {'A1_SUFRAMA' 	,oJson:id, Nil}) 
		ElseIf AllTrim(oJson:name) $ "PASSAPORTE"
			aAdd( aCab, {'A1_PFISICA' 	,oJson:id, Nil}) 
		ElseIf AllTrim(oJson:name) $ "RG"
			aAdd( aCab, {'A1_RG' 		,oJson:id, Nil}) 
		EndIf
	EndIf

Return

/*/{Protheus.doc} ManutCliente
Realiza a manuten��o (inclus�o/altera��o/exclus�o) de clientes

@param oApiManager	, Objeto	, Objeto ApiManager inicializado no m�todo 
@param aQueryString	, Array		, Array com os filtros a serem utilizados no Get
@param nOpc			, Num�rico	, Opera��o a ser realizada
@param aJson		, Array		, Array tratado de acordo com os dados do json recebido
@param cChave		, Caracter	, Chave com C�digo + Loja do cliente
@param oJson		, Objeto	, Objeto com Json parceado

@return lRet	, L�gico	, Retorna se realizou ou n�o o processo

@author		Squad Faturamento/CRM
@since		06/08/2018
@version	12.1.20
/*/
Static Function AManutCliente(oApiManager, aQueryString, nOpc, aJson, cChave, oJson, cBody)
	Local aCab				:= {}
	Local cCliente			:= ""
	Local cLoja				:= ""
	Local cResp				:= ""
    Local lRet				:= .T.
	Local nX				:= 0
	Local nPosCod			:= 0
	Local nPosLoja			:= 0
    //Local oJsonPositions	:= JsonObject():New()

	Default cChave 			:= ""
	Default oJson			:= Nil
	Default cBody			:= ""
	Default aJson				:= {}


	Private lMsErroAuto 	:= .F.
	Private lAutoErrNoFile	:= .T.

	ADefRelation(@oApiManager)

	If nOpc != 5
		aJson := oApiManager:ToArray(cBody)

		If Len(aJson[1][1]) > 0
			oApiManager:ToExecAuto(1, aJson[1][1][1][2], aCab)
		EndIf

		If Len(aJson[1][2]) > 0
			For nX := 1 To Len(aJson[1][2][1])
				oApiManager:ToExecAuto(1, aJson[1][2][1][nX][2], aCab)
			Next
		EndIf

		iF Len(aCab) > 0
			ASORT(aCab, , , { | x,y | x[1] > y[1] } )
		Endif

		If Len(aJson[1][3]) > 0
			For nX := 1 To Len(aJson[1][3][1])
				AMontaCab(aJson[1][3][1][nX], aCab)
			Next
		EndIf
	EndIf

	If !Empty(cChave)
		cCliente := SubStr(cChave, 1                       , TamSX3("A1_COD")[1] )
		cLoja	 := SubStr(cChave, TamSX3("A1_COD")[1] + 1 , Len(cChave)         )
	EndIf

	nPosCod	:= (aScan(aCab ,{|x| AllTrim(x[1]) == "A1_COD"}))
	nPosLoja:= (aScan(aCab ,{|x| AllTrim(x[1]) == "A1_LOJA"}))

	If nOpc == 3
		If nPosCod == 0 .And. nPosLoja == 0
			aAdd( aCab, {'A1_COD',AMATI30PNum(), Nil})
			aAdd( aCab, {'A1_LOJA','01', Nil})
		ElseIf nPosCod == 0 .And. nPosLoja != 0
			aAdd( aCab, {'A1_COD',AMATI30PNum(), Nil})
		ElseIf nPosCod != 0 .And. nPosLoja == 0
			aAdd( aCab, {'A1_LOJA','01', Nil})
		EndIf
	Else 
		If nPosCod == 0 .And. nPosLoja == 0
			aAdd( aCab, {'A1_COD' ,cCliente, Nil})
			aAdd( aCab, {'A1_LOJA',cLoja, Nil})
		ElseIf nPosCod == 0 .And. nPosLoja != 0
			aAdd( aCab, {'A1_COD' ,cCliente, Nil})
			aCab[nPosLoja][2] := cLoja
		ElseIf nPosCod != 0 .And. nPosLoja == 0
			aCab[nPosCod][2]  := cCliente
			aAdd( aCab, {'A1_LOJA','01', Nil})
		Else
			aCab[nPosCod][2]  := cCliente
			aCab[nPosLoja][2] := cLoja		
		EndIf
	EndIf

	If lRet

		MsExecAuto({|x,y|Mata030(x,y)},aCab,nOpc)

		If lMsErroAuto
			aMsgErro := GetAutoGRLog()
			cResp	 := ""
			For nX := 1 To Len(aMsgErro)
				cResp += StrTran( StrTran( aMsgErro[nX], "<", "" ), "-", "" ) + (" ") 
			Next nX	
			lRet := .F.
			oApiManager:SetJsonError("400","Erro durante Inclus�o/Altera��o/Exclus�o do cliente!.", cResp,/*cHelpUrl*/,/*aDetails*/)
		EndIf
	EndIf

Return lRet

/*/{Protheus.doc} GetCli
Realiza o Get dos clientes

@param oApiManager	, Objeto	, Objeto ApiManager inicializado no m�todo 
@param Self			, Objeto	, Objeto Restful

@return lRet	, L�gico	, Retorna se conseguiu ou n�o processar o Get.

@author		Squad Faturamento/CRM
@since		06/08/2018
@version	12.1.20
/*/
Static Function AGetCli(oApiManager, Self)
	Local aFatherAlias		:=	{"SA1","items"							, "items"}
	Local cIndexKey			:= "A1_FILIAL, A1_COD"

	If Len(oApiManager:GetApiRelation()) == 0
		ADefRelation(@oApiManager)
	Endif

	lRet := AGetMain(@oApiManager, Self:aQueryString, aFatherAlias, , cIndexKey)

Return lRet

/*/{Protheus.doc} DefRelation
Realiza o Get dos clientes

@param oApiManager	, Objeto	, Objeto ApiManager inicializado no m�todo 

@return Nil	

@author		Squad Faturamento/CRM
@since		06/08/2018
@version	12.1.20
/*/
Static Function ADefRelation(oApiManager)
	Local aRelation			:= {{"A1_FILIAL","A1_FILIAL"},{"A1_COD","A1_COD"}, {"A1_LOJA","A1_LOJA"}}
	Local aFatherAlias		:=	{"SA1","items"							, "items"}
	Local aChiMktSeg		:=	{"SA1","marketsegment"					, "marketsegment"}
	Local aChiGovInfo		:=	{"SA1","GovernmentalInformation"		, "GovernmentalInformation"}
	Local aChiInfoIE		:=	{"SA1",""		, "GovInfoIE"}
	Local aChiInfoIM		:=	{"SA1",""		, "GovInfoIM"}
	Local aChiInfoC			:=	{"SA1",""		, "GovInfoC"}
	Local aChiInfoSF		:=	{"SA1",""		, "GovInfoSF"}
	Local aChiInfoPS		:=	{"SA1",""		, "GovInfoPS"}
	Local aChiInfoRG		:=	{"SA1",""		, "GovInfoRG"}
	Local aChiEndM   		:= 	{"SA1","address"						, "addressM"}
	Local aChiCidM   		:= 	{"SA1","city"							, "cityM"}
	Local aChiEstM   		:= 	{"SA1","state"							, "stateM"}
	Local aChiConM   		:= 	{"SA1","country"						, "countryM"}
	Local aChiEndS 			:= 	{"SA1","shippingAddress"				, "shippingAddress"}
	Local aChiCidS   		:= 	{"SA1","city"							, "cityS"}
	Local aChiEstS   		:= 	{"SA1","state"							, "stateS"}
	Local aChiConS   		:= 	{"SA1","country"						, "countryS"}
	Local aChiComInfo		:=	{"SA1","listOfCommunicationInformation"	, "listOfCommunicationInformation"}
	Local aChiContacts		:=	{"SA1","listOfContacts"					, "listOfContacts"}
	Local aChiBankInf		:=	{"SA1","listOfBankingInformation"		, "listOfBankingInformation"}
	Local aChiFiscal		:=	{"SA1","fiscalInformation"				, "fiscalInformation"}
	Local aChiCredInf		:=	{"SA1","creditInformation"				, "creditInformation"}
	Local aChiVendType		:=	{"SA1","vendorInformation"				, "vendorInformation"}
	Local aChiTaxPayer		:=	{"SA1","taxPayer"						, "taxPayer"}
	Local aChiBillInfo		:=	{"SA1","billingInformation"				, "billingInformation"}
	Local aChiEndC			:=	{"SA1","address"						, "addressB"}
	Local aChiCidC			:=	{"SA1","city"							, "cityB"}
	Local aChiEstC			:=	{"SA1","state" 							, "stateB"}
	Local aChiConC			:=	{"SA1","country"						, "countryB"}
	Local aChiCntCom		:= 	{"SA1","CommunicationInformation"		, "CommunicationInformationCt"}
	Local aChiEndCnt		:=  {"SA1","ContactInformationAddress"		, "addressCnt"}
	Local aChiCidCnt		:=  {"SA1","city"							, "cityCt"}
	Local aChiEstCnt		:=	{"SA1","state"							, "stateCt"}
	Local aChiConCnt		:=	{"SA1","country"						, "countryCt"}

	Local cIndexKey			:= "A1_FILIAL, A1_COD"

	oApiManager:SetApiRelation(aChiMktSeg	,aFatherAlias	, aRelation, cIndexKey)

	oApiManager:SetApiRelation(aChiGovInfo	,aFatherAlias	, aRelation, cIndexKey)
	oApiManager:SetApiRelation(aChiInfoIE	,aChiGovInfo	, aRelation, cIndexKey)
	oApiManager:SetApiRelation(aChiInfoIM	,aChiGovInfo	, aRelation, cIndexKey)
	
	oApiManager:SetApiRelation(aChiInfoC	,aChiGovInfo	, aRelation, cIndexKey)
	oApiManager:SetApiRelation(aChiInfoSF	,aChiGovInfo	, aRelation, cIndexKey)
	oApiManager:SetApiRelation(aChiInfoPS	,aChiGovInfo	, aRelation, cIndexKey)
	oApiManager:SetApiRelation(aChiInfoRG	,aChiGovInfo	, aRelation, cIndexKey)

	oApiManager:SetApiRelation(aChiEndM		,aFatherAlias	, aRelation, cIndexKey)
	oApiManager:SetApiRelation(aChiCidM		,aChiEndM		, aRelation, cIndexKey)
	oApiManager:SetApiRelation(aChiEstM		,aChiEndM		, aRelation, cIndexKey)
	oApiManager:SetApiRelation(aChiConM		,aChiEndM		, aRelation, cIndexKey)	


	oApiManager:SetApiRelation(aChiEndS		,aFatherAlias	, aRelation, cIndexKey)
	oApiManager:SetApiRelation(aChiCidS		,aChiEndS		, aRelation, cIndexKey)
	oApiManager:SetApiRelation(aChiEstS		,aChiEndS		, aRelation, cIndexKey)
	oApiManager:SetApiRelation(aChiConS		,aChiEndS		, aRelation, cIndexKey)	

	oApiManager:SetApiRelation(aChiComInfo	,aFatherAlias	, aRelation, cIndexKey)

	oApiManager:SetApiRelation(aChiContacts	,aFatherAlias	, aRelation, cIndexKey)
	oApiManager:SetApiRelation(aChiCntCom	,aChiContacts	, aRelation, cIndexKey)
	oApiManager:SetApiRelation(aChiEndCnt	,aChiContacts	, aRelation, cIndexKey)
	oApiManager:SetApiRelation(aChiCidCnt	,aChiEndCnt		, aRelation, cIndexKey)
	oApiManager:SetApiRelation(aChiEstCnt	,aChiEndCnt		, aRelation, cIndexKey)
	oApiManager:SetApiRelation(aChiConCnt	,aChiEndCnt		, aRelation, cIndexKey)

	oApiManager:SetApiRelation(aChiBankInf	,aFatherAlias	, aRelation, cIndexKey)	
	oApiManager:SetApiRelation(aChiCredInf	,aFatherAlias	, aRelation, cIndexKey)
	oApiManager:SetApiRelation(aChiVendType	,aFatherAlias	, aRelation, cIndexKey)
	
	oApiManager:SetApiRelation(aChiFiscal	,aFatherAlias	, aRelation, cIndexKey)
	oApiManager:SetApiRelation(aChiTaxPayer	,aChiFiscal		, aRelation, cIndexKey)

	oApiManager:SetApiRelation(aChiBillInfo	,aFatherAlias	, aRelation, cIndexKey)
	oApiManager:SetApiRelation(aChiEndC		,aChiBillInfo	, aRelation, cIndexKey)
	oApiManager:SetApiRelation(aChiCidC		,aChiEndC		, aRelation, cIndexKey)
	oApiManager:SetApiRelation(aChiEstC		,aChiEndC		, aRelation, cIndexKey)
	oApiManager:SetApiRelation(aChiConC		,aChiEndC		, aRelation, cIndexKey)			
	
	oApiManager:SetApiMap(AAPIMapSA1())

Return

/*/{Protheus.doc} GetMain
Realiza o Get dos clientes / Fornecedores

@param oApiManager	, Objeto	, Objeto ApiManager inicializado no m�todo 
@param aQueryString	, Array		, Array com os filtros a serem utilizados no Get
@param aFatherAlias	, Array		, Dados da tabela pai
@param lHasNext		, Logico	, Informa se informa��o se existem ou n�o mais paginas a serem exibidas
@param cIndexKey	, String	, �ndice da tabela pai

@return lRet	, L�gico	, Retorna se conseguiu ou n�o processar o Get.

@author		Squad Faturamento/CRM
@since		06/08/2018
@version	12.1.20
/*/

Static Function AGetMain(oApiManager, aQueryString, aFatherAlias, lHasNext, cIndexKey)
	Local aRelation 		:= {}
	Local aChildrenAlias	:= {}
	Local lRet 				:= .T.

	Default cIndexKey		:= ""
	Default aQueryString	:={,}
	Default oApiManager		:= Nil
	Default lHasNext		:= .T.

	lRet := ApiMainGet(@oApiManager, aQueryString, aRelation , aChildrenAlias, aFatherAlias, cIndexKey, oApiManager:GetApiAdapter(), oApiManager:GetApiVersion(), lHasNext)

	FreeObj( aRelation )
	FreeObj( aChildrenAlias )
	FreeObj( aFatherAlias )

Return lRet

/*/{Protheus.doc} MATI30PNum
Pega o pr�ximo c�digo de cliente v�lido

@return cProxNum	, String	, C�digo do cliente a ser utilizado.

@author		Squad Faturamento/CRM
@since		06/08/2018
@version	12.1.20
/*/
Static Function AMATI30PNum()
	Local cProxNum := ""

	cProxNum := GETSX8NUM("SA1","A1_COD")
	While .T.
		If SA1->( DbSeek( xFilial("SA1")+cProxNum ) )
			ConfirmSX8()
			cProxNum:=GetSXeNum("SA1","A1_COD")
		Else
			Exit
		Endif
	Enddo

Return(cProxNum)

/*/{Protheus.doc} ApiMap
Estrutura a ser utilizada na classe ServicesApiManager

@return cRet	, caracter	, Mensagem de retorno de sucesso/erro.

@author		Squad Faturamento/CRM
@since		06/08/2018
@version	12.1.20
/*/

Static Function AApiMapSA1()

	Local aApiMap		:= {}
	Local aStrSA1		:= {}

	Local aStrMktSeg	:= {}
	Local aStrGovInfo	:= {}
	Local aStrInfoIE	:= {}
	Local aStrInfoIM	:= {}
	Local aStrInfoC		:= {}
	Local aStrInfoSF	:= {}
	Local aStrInfoPS	:= {}
	Local aStrInfoRG	:= {}
	Local aStrEndM		:= {}
	Local aStrCidM		:= {}
	Local aStrEstM		:= {}
	Local aStrConM		:= {}
	Local aStrEndS		:= {}
	Local aStrCidS		:= {}
	Local aStrConS		:= {}
	Local aStrComInfo	:= {}
	Local aStrContacts	:= {}
	Local aStrContCom	:= {}
	Local aStrContEnd	:= {}
	Local aStrCidCt		:= {}
	Local aStrEstCt		:= {}
	Local aStrConCt		:= {}
	Local aStrBankInf	:= {}
	Local aStrFiscal	:= {}
	Local aStrTaxPayer	:= {}
	Local aStrCredInf	:= {}
	Local aStrVendType	:= {}
	Local aStrBillInfo	:= {}
	Local aStrEndC		:= {}
	Local aStrCidC		:= {}
	Local aStrEstC		:= {}
	Local aStrConC		:= {}
	
	aStrSA1			:=	{"SA1","Field","items","items",;
							{;
								{"companyId"					, ""											},;
								{"branchId"						, "A1_FILIAL"									},;
								{"companyInternalId"			, "Exp:cEmpAnt, A1_FILIAL, A1_COD, A1_LOJA"		},;								
								{"code"							, "A1_COD"										},;
								{"storeId"						, "A1_LOJA"										},;
								{"internalId"					, ""											},;
								{"shortName"					, "A1_NREDUZ"									},;
								{"name"							, "A1_NOME"										},;
								{"type"							, "Exp:1"										},;								
								{"entityType"					, "A1_PESSOA"									},;
								{"registerdate"					, ""											},;
								{"registerSituation"			, "A1_MSBLQL"									},;
								{"comments"						, ""											},;
								{"paymentConditionCode"			, "A1_COND"										},;
								{"paymentConditionInternalId"	, ""											},;
								{"priceListHeaderItemCode"		, "A1_TABELA"									},;
								{"carrierCode"					, "A1_TRANSP"									},;
								{"strategicCustomerType"		, "A1_TIPO"										},;
								{"rateDiscount"					, ""											},;
								{"sellerCode"					, ""											},;
								{"sellerInternalId"				, ""											};
							},;
						}

	aStrMktSeg		:=	{"SA1","Field","marketsegment","marketsegment",;
							{;
								{"marketSegmentCode"							, "A1_CODSEG"					},;
								{"marketSegmentInternalId"						, ""							},;
								{"marketSegmentDescription"						, ""							};
							},;
						}

	aStrGovInfo		:=	{"SA1","ITEM","GovernmentalInformation","GovernmentalInformation",;
							{;
							},;
						}
	
	aStrInfoIE		:=	{"SA1","Object","","GovInfoIE",;
							{;
								{"id"							, "A1_INSCR"									},;
								{"name"							, "Exp:'INSCRICAO ESTADUAL'"					},;
								{"scope"						, ""											},;
								{"expireOn"						, ""											},;
								{"issueOn"						, ""											};
							},;
						}

	aStrInfoIM		:=	{"SA1","Object","","GovInfoIM",;
							{;
								{"id"							, "A1_INSCRM"									},;
								{"name"							, "Exp:'INSCRICAO MUNICIPAL'"					},;
								{"scope"						, ""											},;
								{"expireOn"						, ""											},;
								{"issueOn"						, ""											};
							},;
						}

	aStrInfoC		:=	{"SA1","Object","","GovInfoC",;
							{;
								{"id"							, "A1_CGC"										},;
								{"name"							, "Exp:'CPF|CNPJ'"								},;
								{"scope"						, ""											},;
								{"expireOn"						, ""											},;
								{"issueOn"						, ""											};
							},;
						}

	aStrInfoSF		:=	{"SA1","Object","","GovInfoSF",;
							{;
								{"id"							, "A1_SUFRAMA"									},;
								{"name"							, "Exp:'SUFRAMA'"								},;
								{"scope"						, ""											},;
								{"expireOn"						, ""											},;
								{"issueOn"						, ""											};
							},;
						}

	aStrInfoPS		:=	{"SA1","Object","","GovInfoPS",;
							{;
								{"id"							, "A1_PFISICA"									},;
								{"name"							, "Exp:'PASSAPORTE'"							},;
								{"scope"						, ""											},;
								{"expireOn"						, ""											},;
								{"issueOn"						, ""											};
							},;
						}

	aStrInfoRG		:=	{"SA1","Object","","GovInfoRG",;
							{;
								{"id"							, "A1_RG"										},;
								{"name"							, "Exp:'RG'"									},;
								{"scope"						, ""											},;
								{"expireOn"						, ""											},;
								{"issueOn"						, ""											};
							},;
						}

	aStrEndM   		:= 	{"SA1","field","address","addressM",;
							{;
								{"address"						, "A1_END"										},;
								{"number"						, ""											},;
								{"complement"					, "A1_COMPLEM"											},;
								{"district"						, "A1_BAIRRO"									},;
								{"zipCode"						, "A1_CEP"  									},;
								{"region"						, ""											},;
								{"poBox"						, ""											},;
								{"mainAddress"					, "Exp:.T."										},;
								{"shippingAddress"				, "Exp:.F."										},;
								{"billingAddress"				, "Exp:.F."										};
							},;
					}	

	aStrCidM   		:= 	{"SA1","Field","city","cityM",;
							{;
								{"cityCode"						, "A1_COD_MUN"									},;
								{"cityInternalId"				, "A1_COD_MUN"									},;
								{"cityDescription"				, "A1_MUN"										};
							},;
					}

	aStrEstM   		:= 	{"SA1","Field","state","stateM",;
							{;
								{"stateId"						, "A1_EST"										},;
								{"stateInternalId"				, "A1_EST"										},;
								{"stateDescription"				, ""											};
							},;
					}

	aStrConM   		:= 	{"SA1","Field","country","countryM",;
							{;
								{"countryCode"					, "A1_PAIS"										},;
								{"countryInternalId"			, "A1_PAIS"										},;
								{"countryDescription"			, ""											};
							},;
					}																											

	aStrEndS 		:= 	{"SA1","Field","shippingAddress","shippingAddress",;
							{;
								{"address"						, "A1_ENDENT"										},;
								{"number"						, ""											},;
								{"complement"					, ""											},;
								{"district"						, "A1_BAIRROE"									},;
								{"zipCode"						, "A1_CEPE"  									},;
								{"region"						, ""											},;
								{"poBox"						, ""											},;
								{"mainAddress"					, "Exp:.F."										},;
								{"shippingAddress"				, "Exp:.T."										},;
								{"billingAddress"				, "Exp:.F."										};
							},;
					}		

	aStrCidS   		:= 	{"SA1","Field","city","cityS",;
							{;
								{"cityCode"						, "A1_CODEMUNE"									},;
								{"cityInternalId"				, "A1_CODEMUNE"									},;
								{"cityDescription"				, "A1_MUNE"										};
							},;
					}

	aStrEstS   		:= 	{"SA1","Field","state","stateS",;
							{;
								{"stateId"						, "A1_ESTE   "									},;
								{"stateInternalId"				, "A1_ESTE   "									},;
								{"stateDescription"				, ""											};
							},;
					} 

	aStrConS   		:= 	{"SA1","Field","country", "countryS",;
							{;
								{"countryCode"					, ""											},;
								{"countryInternalId"			, ""											},;
								{"countryDescription"			, ""											};
							},;
					}	

	aStrComInfo		:=	{"SA1","ITEM","listOfCommunicationInformation", "listOfCommunicationInformation",;
							{;
								{"type"							, ""											},;
								{"phoneNumber"					, "A1_TEL"										},;
								{"phoneExtension"				, ""											},;
								{"faxNumber"					, "A1_FAX"										},;
								{"faxNumberExtension"			, ""											},;
								{"homePage"						, "A1_HPAGE"									},;								
								{"email"						, "A1_EMAIL"									},;
								{"diallingCode"					, "A1_DDD"										},;
								{"internationalDiallingCode"	, "A1_DDI"										};
							},;
						}		
	aStrContacts	:=	{"SA1","ITEM","listOfContacts", "listOfContacts",;
							{;
								{"ContactInformationCode"		, ""											},;
								{"ContactInformationInternalId"	, ""											},;
								{"ContactInformationTitle"		, ""											},;
								{"ContactInformationName"		, "A1_CONTATO"									},;
								{"ContactInformationDepartment" , ""											};
							},;
						}			
	aStrContCom 	:= 	{"SA1","Field","CommunicationInformation","CommunicationInformationCt",;
							{;
								{"type"							,""												},;
								{"phoneNumber"					,""												},;
								{"phoneExtension"				,""												},;
								{"faxNumber"					,""												},;
								{"faxNumberExtension"			,""												},;
								{"homePage"						,""												},;
								{"email"						,""												},;
								{"diallingCode"					,""												},;
								{"internationalDiallingCode"	,""												};								
							},;
						} 
	aStrContEnd		:= 	{"SA1","Field","ContactInformationAddress","addressCnt",;
							{;
								{"address"						, ""											},;
								{"number"						, ""											},;
								{"complement"					, ""											},;
								{"district"						, ""											},;
								{"zipCode"						, ""  											},;
								{"region"						, ""											},;
								{"poBox"						, ""											},;
								{"mainAddress"					, "Exp:.F."										},;
								{"shippingAddress"				, "Exp:.F."										},;
								{"billingAddress"				, "Exp:.F."										};
							},;
						}
	aStrCidCt 		:= 	{"SA1","Field","city","cityCt",;
							{;
								{"cityCode"						, ""											},;
								{"cityInternalId"				, ""											},;
								{"cityDescription"				, ""											};
							},;
					}
	aStrEstCt   	:= 	{"SA1","Field","state","stateCt",;
							{;
								{"stateId"						, ""											},;
								{"stateInternalId"				, ""											},;
								{"stateDescription"				, ""											};
							},;
					}
	aStrConCt   	:= 	{"SA1","Field","country","countryCt",;
							{;
								{"countryCode"					, ""											},;
								{"countryInternalId"			, ""											},;
								{"countryDescription"			, ""											};
							},;
						}			
	aStrBankInf		:=	{"SA1","ITEM","listOfBankingInformation", "listOfBankingInformation",;
							{;
								{"bankCode"						, ""											},;
								{"bankInternalId"				, ""											},;
								{"bankName"						, ""											},;
								{"branchCode"					, ""											},;
								{"branchKey"					, ""											},;
								{"checkingAccountNumber"		, ""											},;
								{"checkingAccountNumberKey"		, ""											},;								
								{"checkingAccountType"			, ""											},;
								{"mainAccount"					, ""											},;
								{"currencyAccount"				, ""											};
							},;
						}			

	aStrFiscal		:=	{"SA1","Field","fiscalInformation"		, "fiscalInformation",;
							{;
								{"Category"						, ""											},;
								{"IsRetentionAgent"				, ""											};
							},;
						}	
	aStrTaxPayer	:=	{"SA1","Field","taxPayer"				, "taxPayer",;
							{;
								{"taxName"						, ""											},;
								{"isPayer"						, ""											},;								
								{"mode"							, ""											};
							},;
						}	
	aStrCredInf		:=	{"SA1","Field","creditInformation", "creditInformation",;
							{;
								{"creditIndicator"				, ""											},;
								{"creditEvaluation"				, ""											},;								
								{"shipmentCreditEvaluation"		, ""											},;
								{"creditLimit"					, "A1_LC"										},;								
								{"creditLimitCurrency"			, "A1_MOEDALC"									},;
								{"creditLimitDate"				, "A1_VENCLC"									},;																								
								{"additionalCreditLimit"		, "A1_LCFIN"									},;																								
								{"additionalCreditLimitCurrency", ""											},;																								
								{"additionalCreditLimitDate"	, ""											},;
								{"latePeriods"					, ""											},;
								{"balanceOfCredit"				, ""											};
							},;
						}		

	aStrVendType	:=	{"SA1","Field","vendorInformation", "vendorInformation",;
							{;
								{"vendorClassification"			, ""											},;
								{"vendorTypeCode"				, "A1_VEND"										},;								
								{"vendorTypeInternalId"			, "Exp:cEmpAnt, A1_FILIAL,A1_VEND"				},;																
								{"vendorTypeDescription"		, ""											};
							},;
						}							
	aStrBillInfo	:=	{"SA1","Field","billingInformation", "billingInformation",;
							{;
								{"billingCustomerCode"			, ""											},;
								{"billingCustomerInternalId"	, ""											};								
							},;
						}			

	aStrEndC 		:= 	{"SA1","Field","address", "addressB",;
							{;
								{"address"						, "A1_ENDCOB"									},;
								{"number"						, ""											},;
								{"complement"					, ""											},;
								{"district"						, "A1_BAIRROC"									},;
								{"zipCode"						, "A1_CEPC"  									},;
								{"region"						, ""											},;
								{"poBox"						, ""											},;
								{"mainAddress"					, "Exp:.F."										},;
								{"shippingAddress"				, "Exp:.F."										},;
								{"billingAddress"				, "Exp:.T."										};
							},;
					}		

	aStrCidC   		:= 	{"SA1","Field","city", "cityB",;
							{;
								{"cityCode"						, "A1_MUNC   "									},;
								{"cityInternalId"				, "A1_MUNC   "									},;
								{"cityDescription"				, ""											};
							},;
					}

	aStrEstC   		:= 	{"SA1","Field","state", "stateB",;
							{;
								{"stateId"						, "A1_ESTC   "									},;
								{"stateInternalId"				, "A1_ESTC   "									},;
								{"stateDescription"				, ""											};
							},;
					}

	aStrConC   		:= 	{"SA1","Field","country", "countryB",;
							{;
								{"countryCode"					, ""											},;
								{"countryInternalId"			, ""											},;
								{"countryDescription"			, ""											};
							},;
					}


	aStructAlias  := {aStrSA1, aStrMktSeg, aStrGovInfo, aStrInfoIE, aStrInfoIM, aStrInfoC, aStrInfoSF, aStrInfoPS, aStrInfoRG, aStrEndM,;
	 aStrCidM, aStrEstM, aStrConM, aStrEndS, aStrCidS, aStrEstS, aStrConS, aStrComInfo, aStrContacts, aStrBankInf, aStrFiscal, aStrCredInf,;
	 aStrVendType, aStrTaxPayer, aStrBillInfo, aStrEndC, aStrCidC, aStrEstC, aStrConC,aStrContCom,aStrContEnd,aStrCidCt,aStrEstCt,aStrConCT}

	aApiMap := {"MATS030","items","2.006","MATS030",aStructAlias, "items"}

Return aApiMap
