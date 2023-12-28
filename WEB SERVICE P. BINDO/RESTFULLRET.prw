#INCLUDE "Totvs.CH"
#INCLUDE 'RestFul.CH'
#INCLUDE 'FWMVCDEF.CH'

User Function RestFullRet()

//Get
	RetornoAPI("GET")

//PUT
	RetornoAPI("PUT")

//POST
	RetornoAPI("POST")

//DELETE
	RetornoAPI("DEL")

Return


/*/{Protheus.doc} GETfornece
Busca um fornecedor
@author		
@since		
@version	12.1.20

DOCUMENTAÇÃO
https://tdn.totvs.com/display/public/framework/FWRest

/*/

Static Function RetornoAPI(cTipo)
	Local cEndPoint := ""
	Local oRest
	Local oJson:= JsonObject():New()
	Local Head_Api := {}
	Local cURI := "http://localhost:8084/rest" //ENDERECO SERVIDOR REST

	//CABECALHO 
	aAdd(Head_Api,"Accept: application/json"       )
	aAdd(Head_Api,"Content-Type: application/json" )
	aAdd(Head_Api,"User-Agent: Chrome/65.0 (compatible; Protheus " + GetBuild() + ")" )

	//API
	cUrl     := '/api/crm/v1/NcustomerVendor/'

	//Construtor
	oRest    := FwRest():New(cURI)

	//METODO GET
	If cTipo == "GET"
		cEndPoint:= "1/00000101"  //TIPO(1-CLIENTE -2-FORNECEDOR)/COD+LOJA
		//Informa o path aonde será feito a requisição
		oRest:SetPath(cUrl+cEndPoint)

		//VALIDA SE CARREGA A API
		If oRest:Get(Head_Api)
			lRet := .T.
		Else
			lRet := .F.
		EndIf

		//Retorna o ultimo conteúdo valido retornado pela uma chamada ao método Get ou Post
		cResponse := oRest:GetResult()

		If Valtype(cResponse)<>"C"
			cResponse := ""
		EndIf
		cRetApi := cResponse

		//Retorna o ultimo erro retornado pela uma chamada ao método Get ou Post
		If !lRet
			cRetApi += CRLF+CRLF+oRest:GetLastError()
		EndIf
		//TRANSFORMA EM OBJETO
		//https://tdn.totvs.com/display/tec/Classe+JsonObject
		//FWJsonDeserialize(cResponse,@oResponse)
		ret := oJson:FromJson(cResponse)

		//VALIDA SE DEU CERTO
		if ValType(ret) == "C"
			conout("Falha ao transformar texto em objeto json. Erro: " + ret)
			return
		endif
		//https://tdn.totvs.com.br/display/tec/AttlsMemberOf
		names := oJson:GetNames()
		u_PrintJson(oJson)


	ElseIf cTipo == "POST"

		cEndPoint:= ""  //TIPO(1-CLIENTE -2-FORNECEDOR)/COD+LOJA

		// INFORMA O RECURSO
		oRest:SetPath(cUrl+cEndPoint)

		// REALIZA O METODO POST, ENVIA O JSON NO CORPO (BODY) E VALIDA O RETORNO
		oRest:SetPostParams(POSTGetJson())

		If (oRest:Post(Head_Api))
			ConOut("POST: " + oRest:GetResult())
		Else
			ConOut("POST: " + oRest:GetLastError())
		EndIf

	ElseIf cTipo == "PUT"
		//REGISTO A SER ALTERADO
		cEndPoint:= "1/00000101"  //TIPO(1-CLIENTE -2-FORNECEDOR)/COD+LOJA
		// INFORMA O RECURSO
		oRest:SetPath(cUrl+cEndPoint)

		// REALIZA O MÉTODO PUT, ENVIA O JSON NO CORPO (BODY) E VALIDA O RETORNO
		If (oRest:Put(Head_Api, PUTGetJson()))
			ConOut("PUT: " + oRest:GetResult())
		Else
			ConOut("PUT: " + oRest:GetLastError())
		EndIf

	ElseIf cTipo == "DEL"
	cEndPoint:= "1/00001501"  //TIPO(1-CLIENTE -2-FORNECEDOR)/COD+LOJA

		// INFORMA O RECURSO
		oRest:SetPath(cUrl+cEndPoint)

		// REALIZA O MÉTODO PUT, ENVIA O JSON NO CORPO (BODY) E VALIDA O RETORNO
		oRest:SetPostParams(DELGetJson())

		If (oRest:Delete(Head_Api))
			ConOut("POST: " + oRest:GetResult())
		Else
			ConOut("POST: " + oRest:GetLastError())
		EndIf
	EndIf

	//Método que retorna o HTTPCode da requisição.
	nCodeRet := Val(oRest:GetHTTPCode())

	//VALIDA O CODIGO DE RETORNO
	FreeObj(oRest)
	If (nCodeRet >= 200 .And. nCodeRet <= 299)
		lRet := .T.
	Else
		lRet := .F.
	EndIf

	//EM CASO DE ERRO SAI DA ROTINA
	If !lRet
		conout("Erro: "+cValToChar(nCodeRet))
		Return
	EndIf

Return

//ESCREVE NO SERVER.LOG O CONTEUDO DO JSON
user function PrintJson(jsonObj)
	local i, j
	local names
	local lenJson
	local item

	lenJson := len(jsonObj)

	if lenJson > 0
		for i := 1 to lenJson
			u_PrintJson(jsonObj[i])
		next
	else
		names := jsonObj:GetNames()
		for i := 1 to len(names)
			conout("Label - " + names[i])
			item := jsonObj[names[i]]
			if ValType(item) == "C"
				conout( names[i] + " = " + cvaltochar(jsonObj[names[i]]))
			else
				if ValType(item) == "A"
					conout("Vetor[")
					for j := 1 to len(item)
						conout("Indice " + cValtochar(j))
						u_PrintJson(item[j])
					next j
					conout("]Vetor")
				endif
			endif
		next i
	endif
return


// CRIA O JSON QUE SERÁ ENVIADO NO CORPO (BODY) DA REQUISIÇÃO DA ALTERACAO
Static Function PUTGetJson()
	Local bObject := {|| JsonObject():New()}
	Local oJson   := Eval(bObject)


	oJson["name"]                               := "TESTE JSON1"
	oJson["shortName"]                          := "TJSON1"
	oJson["address"]                            := Eval(bObject)
	oJson["address"]["city"]                    := Eval(bObject)
	oJson["address"]["city"]["cityDescription"] := "ALTERADO"


	cBody   := EncodeUTF8( oJson:ToJson() )

Return(cBody)



// CRIA O JSON QUE SERÁ ENVIADO NO CORPO (BODY) DA REQUISIÇÃO DA INCLUSAO
Static Function POSTGetJson()
	Local bObject := {|| JsonObject():New()}
	Local oJson   := Eval(bObject)

	oJson["type"]                               := "1"
	oJson["name"]                               := "TESTE POST"
	oJson["shortName"]                          := "TPJSON"
	oJson["strategicCustomerType"]				:= "F"
	oJson["address"]                            := Eval(bObject)
	oJson["address"]["address"]					:= "RUA TESTE POST"
	oJson["address"]["city"]                    := Eval(bObject)
	oJson["address"]["city"]["cityDescription"] := "INCLUIDO"
	oJson["address"]["state"]					:= Eval(bObject)
	oJson["address"]["state"]["stateId"]		:= "SP"


	//cBody   := EncodeUTF8( oJson:ToJson() )

Return(oJson:ToJson())


// CRIA O JSON QUE SERÁ ENVIADO NO CORPO (BODY) DA REQUISIÇÃO DA ALTERACAO
Static Function DELGetJson()
	Local bObject := {|| JsonObject():New()}
	Local oJson   := Eval(bObject)


	oJson["code"]                               := "000015"
	oJson["storeId"]                          := "01"


	//cBody   := EncodeUTF8( oJson:ToJson() )

Return(oJson:ToJson())

