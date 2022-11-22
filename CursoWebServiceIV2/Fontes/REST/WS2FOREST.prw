//#include 'parmtype.ch'
#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"


	
/*/{Protheus.doc} FOR2REST
Serviço de integração  para integração fornecedores com execauto
@author 	DAC - Denilso
@since 		20/09/2020
@version 	P12
@param		Não utilizado
@type class
@client    	IV2
@project 	Treinamento WS
			https://tdn.totvs.com/display/tec/DecodeUTF8
			https://jsonformatter.curiousconcept.com/  VERIFICAR SE JSON ESTA CORRETO
			https://jsonlint.com/?code=   //VALIDAR JSON
			http://localhost:8081\REST\FOR2REST

/*/

WSRESTFUL FOR2REST DESCRIPTION "Serviço para integração Fornecedor" FORMAT APPLICATION_JSON
	WSMETHOD POST; 
	DESCRIPTION "Realiza a inclusão Fornecedor";
	WSSYNTAX "/FOR2REST"
	WSMETHOD PUT; 
	DESCRIPTION "Realiza a alteração Fornecedor";
	WSSYNTAX "/FOR2REST"
	WSMETHOD DELETE; 
	DESCRIPTION "Realiza a exclusão Fornecedor";
	WSSYNTAX "/FOR2REST"
	WSMETHOD GET; 
	DESCRIPTION "Realiza a consulta Fornecedor";
	WSSYNTAX "/FOR2REST"
END WSRESTFUL
 
 
/*/{Protheus.doc} POST
Realiza a inclusão de configuração de folha
@author DAC - Denilso
@since 
@version undefined
@type function
/*/
WSMETHOD POST WSSERVICE FOR2REST
Local cErro
//abre a tabela posicionada no indice
DbSelectArea("SA2")
SA2->(DbSetOrder(03))  //A2_FILIAL+A2_CGC                                                                                                                                                                                                                                   
::SetContentType('application/json')
oJson := JsonObject():new()
oJson:fromJson(DecodeUTF8(Self:GetContent(,.T.)))      //Correto
cJson := Self:GetContent(,.T.)
// Valida os dados do oJson
cErro := ValoJson(oJson,"I")
Conout(cErro)
If !Empty(cErro)
	Return SetMsgErro(Self,cErro)
Endif
// Realiza a gravação na tabela ZCA
cErro := GravaSA2(oJson,"I")
If !Empty(cErro)
	Return SetMsgErro(Self,cErro)
Else
	Return SetMsgOk(self,"Integracao realizada com sucesso")
Endif

/*/{Protheus.doc} PUT
Realiza a atualizacao de Faturamento de nota
@author DAC - Denilso
@since 
@version undefined
@type function
/*/
WSMETHOD PUT WSSERVICE FOR2REST
Local cErro
//abre a tabela posicionada no indice
DbSelectArea("SA2")
SA2->(DbSetOrder(03))  //A2_FILIAL+A2_CGC                                                                                                                                                                                                                                   
::SetContentType('application/json')
oJson := JsonObject():new()
oJson:fromJson(DecodeUTF8(Self:GetContent(,.T.)))  //Correto
cJson := Self:GetContent(,.T.)
// Valida os dados do oJson
cErro := ValoJson(oJson,"A")
If !Empty(cErro)
	Return SetMsgErro(Self,cErro)
endif
cErro := GravaSA2(oJson,"A")
If !Empty(cErro)
	Return SetMsgErro(Self,cErro)
Else
	Return SetMsgOk(self,"Atualização realizada com sucesso")
Endif

/*/{Protheus.doc} DELETE
Realiza a exclusão de Faturamento de nota
@author DAC - Denilso
@since 
@version undefined
@type function
/*/
WSMETHOD DELETE WSSERVICE FOR2REST
Local cErro
//Abre tabela posicionada no indice
DbSelectArea("SA2")
SA2->(DbSetOrder(03))  //A2_FILIAL+A2_CGC                                                                                                                                                                                                                                   

::SetContentType('application/json')
oJson := JsonObject():new()
oJson:fromJson(DecodeUTF8(Self:GetContent(,.T.)))  //Correto
cJson := Self:GetContent(,.T.)
// Valida os dados do oJson
cErro := ValoJson(oJson,"E")
If !Empty(cErro)
	Return SetMsgErro(Self,cErro)
Endif
//Ja possicionado no registro pela função ValoJson
Begin Transaction
	If RecLock("SA2",.F.)
		SA2->(DbDelete())
		SA2->(MsUnLock())
	Endif	
End Transaction
Return SetMsgOk(self,"Exclusao realizada com sucesso")

/*/{Protheus.doc} GET
Realiza a consulta de Faturamento de nota
@author 
@since 
@/version undefined
@type function
/*/
WSMETHOD GET WSSERVICE FOR2REST
Local cErro
//Abre tabela posicionada no indice
DbSelectArea("SA2")
SA2->(DbSetOrder(03))  //A2_FILIAL+A2_CGC                                                                                                                                                                                                                                   

::SetContentType('application/json')
oJson := JsonObject():new()
//oJson:fromJson(DecodeUTF8(::Self:GetContent(,.T.)))
oJson:fromJson(DecodeUTF8(Self:GetContent(,.T.)))  //Correto
cJson := Self:GetContent(,.T.)

// Valida os dados do oJson
cErro := ValoJson(oJson,"C")
If !Empty(cErro)
	Return SetMsgErro(Self,cErro)
endif

//Ja possicionado no registro pela função ValoJson
cJson := '{	'
cJson += '	"principal": {'
cJson += '					"_cCnpjCpf": "' 				+ EncodeUTF8(AllTrim(SA2->A2_CGC)	 , "cp1252") + '",'
cJson += '					"dadosfornecedor": {'
cJson += '										"codigo": "' 			+ EncodeUTF8(AllTrim(SA2->A2_COD)	, "cp1252") + '",'
cJson += '										"nome": "' 				+ EncodeUTF8(AllTrim(SA2->A2_NOME)	, "cp1252") + '",'
cJson += '										"nome_reduzido": "' 	+ EncodeUTF8(AllTrim(SA2->A2_NREDUZ), "cp1252") + '",'
cJson += '										"endereco": "' 			+ EncodeUTF8(AllTrim(SA2->A2_END)	, "cp1252") + '",'
cJson += '										"end_numero": "' 		+ EncodeUTF8(AllTrim(SA2->A2_NR_END), "cp1252") + '",'
cJson += '										"bairro": "' 			+ EncodeUTF8(AllTrim(SA2->A2_BAIRRO), "cp1252") + '",'
cJson += '										"municipio": "' 		+ EncodeUTF8(AllTrim(SA2->A2_MUN) 	, "cp1252") + '",'
cJson += '										"estado": "' 			+ EncodeUTF8(AllTrim(SA2->A2_EST)	, "cp1252") + '",'
cJson += '										"cepfornec": "' 		+ EncodeUTF8(AllTrim(SA2->A2_CEP)	, "cp1252") + '",'
cJson += '										"tipo_fornecedor": "' 	+ EncodeUTF8(AllTrim(SA2->A2_TIPO)	, "cp1252") + '"'
cJson += '								      }'
cJson += '					}'
cJson += '}'
::SetResponse(cJson)
Return .T.

/*/{Protheus.doc} SetMsgErro
Seta mensagem de erro do rest
@author carlos.henrique
@since 01/03/2019
@version undefined
@param nCode, numeric, descricao
@param cMsg, characters, descricao
@type function
/*/
Static function SetMsgErro(Self,cMsg) 
SetRestFault(404,EncodeUtf8(cMsg))
Return .F.


/*/{Protheus.doc} SetMsgOk
Seta mensagem de sucesso do rest
@author DAC-Denilso
@since 
@version undefined
@param nCode, numeric, descricao
@param cMsg, characters, descricao
@type function
/*/ 
Static function SetMsgOk(self,cMsg)
Local oRet:= JsonObject():new()
oRet['message']	:= EncodeUtf8(cMsg)
self:SetResponse( oRet:toJSON() )
Return .T.

/*/{Protheus.doc} ValoJson
Valida os dados do oJson
@author DAC - Denilso
@since 
@version undefined
@param nCode, numeric, descricao
@param cMsg, characters, descricao
@type function
/*/
Static Function ValoJson(oJson,cTipo)
Local _cCnpjCpf 	:= Space(014)
Local _cMsg			:= Space(001)
Local _cChave		:= Space(001)
Local _cRazsoc		:= Space(040)
Local _cTipo 		:= Space(001) 
Local _lAchou 

Begin Sequence
	// Verifica se enviou o id Configuração
	_cCnpjCpf := AllTrim(oJson["principal"]:GetJsonText("_cCnpjCpf"))
	Conout(_cCnpjCpf)
	If Empty(_cCnpjCpf)
		_cMsg := "Não informado CNPJ/CPF obrigatório !"
		Break
	Endif
	_cChave := XFilial("SA2")
	_cChave += Padr(_cCnpjCpf,TamSX3("A2_CGC")[1]	  ," ") 

	SA2->(DbSetOrder(03))  //A2_FILIAL+A2_CGC 	//para consulta e exclusão não será exigido o ID Contrato
	_lAchou := SA2->(DbSeek(_cChave))
	If _lAchou .and. cTipo == "I" 
		_cMsg := "Fornecedor com CNPJ/CPF "+_cCnpjCpf+" já cadastrado, não poderá ser incluído !" 
		Break
	ElseIf !_lAchou .and. cTipo <> "I"
		_cMsg := "Fornecedor com CNPJ/CPF "+_cCnpjCpf+" não cadastrado, não poderá ser "+If(cTipo == "C","Consultada !","Excluida !") 
		Break  //Ja posso sair pois na consulta somente será validado o id da configuração
	Endif	
	//neste momento posso sair pois estou consultando ou excluindo não sera necessário outra validações
	If (cTipo == "C" .or. cTipo == "E")
		Break
	Endif
	//fazer validações
	_cRazsoc := AllTrim(oJson["principal"]["dadosfornecedor"]:GetJsonText("nome"))
	If Empty(_cRazsoc)
		_cMsg := "Nome do Fronecedor não informado, é obrigátorio !"
		Break
	Endif
	//Validando Tipo de Fornecedor
	_cTipo 	:= AllTrim(oJson["principal"]["dadosfornecedor"]:GetJsonText("tipo_fornecedor"))
	If Len(AllTrim(_cCnpjCpf)) == 14 .and. _cTipo <> "J"
		_cMsg := "Fornecedor com CNPJ/CPF "+_cCnpjCpf+" esta informado o tipo "+_cTipo+" errado !" 
		Break
	Endif

End Sequence
Return(_cMsg)
//=======================================================================================================================================


/*/{Protheus.doc} GravaSA2
Realiza a gravação na tabela SA2
@author Denilso Almeida Carvalho
@since 18/10/2019
@version undefined
@param nCode, numeric, descricao
@param cMsg, characters, descricao
@type function
/*/
Static Function GravaSA2(oJson, cTipo )
//Local _lInclui := If(cTipo == "I",.T.,.F.)  //nao faco a vialidação de inclusão e ou exclusão pois é mandado itens e na validação ja trata esta questão
Local _cErro 		:= ""
Local _cCnpjCpf 	:= Space(014)		
Local _cRazsoc	  	:= Space(040)
Local _cNomeReduz	:= Space(050)  	 
Local _cEndereco	:= Space(040)  	
Local _cEndNum	    := Space(006)
Local _cBairro 		:= Space(020)
Local _cMunicipio	:= Space(060)  	
Local _cEstado      := Space(002)	
Local _cCepForn	  	:= Space(008)
Local _cTipo   		:= Space(001)
Local _cCod			:= Space(Len(SA2->A2_COD))
Local _cLoja		:= Space(Len(SA2->A2_LOJA))
Local _aCab			:= {}
Local _aErro		:= {}
Local _nOpc			:= If(cTipo=="I",3,4)
Local _nPos

Private lMsHelpAuto     := .T. // Se .T. direciona as mensagens de help para o arq. de log
Private lMsErroAuto     := .F.
Private lAutoErrNoFile  := .T. // Precisa estar como .T. para GetAutoGRLog() retornar o array com erros

Begin Transaction
	//Preparar código e loja são chaves para o fornecedor
	If cTipo == "I"
		_cCod			:= LocCod()  //precisa do ultimo código do fornecedor + 1
		_cLoja			:= "01"
	Else
		_cCod			:= SA2->A2_COD //precisa do código do fornecedor
		_cLoja			:= SA2->A2_LOJA
	Endif
	Conout("codigo "+_cCod)
	_cCnpjCpf 		:= AllTrim(oJson["principal"]:GetJsonText("_cCnpjCpf"))
	_cRazsoc	  	:= AllTrim(oJson["principal"]["dadosfornecedor"]:GetJsonText("nome"))
	_cNomeReduz	  	:= AllTrim(oJson["principal"]["dadosfornecedor"]:GetJsonText("nome_reduzido")) 
	_cEndereco	  	:= AllTrim(oJson["principal"]["dadosfornecedor"]:GetJsonText("endereco"))
	_cEndNum	    := AllTrim(oJson["principal"]["dadosfornecedor"]:GetJsonText("end_numero"))
	_cBairro 		:= AllTrim(oJson["principal"]["dadosfornecedor"]:GetJsonText("bairro"))
	_cMunicipio	  	:= AllTrim(oJson["principal"]["dadosfornecedor"]:GetJsonText("municipio"))
	_cEstado      	:= AllTrim(oJson["principal"]["dadosfornecedor"]:GetJsonText("estado"))
	_cCepForn	  	:= AllTrim(oJson["principal"]["dadosfornecedor"]:GetJsonText("cepfornec"))
	_cTipo   		:= AllTrim(oJson["principal"]["dadosfornecedor"]:GetJsonText("tipo_fornecedor"))

	//montar procura
	_cChave := XFilial("SA2")
	_cChave += Padr(_cCnpjCpf,TamSX3("A2_CGC")[1]	  ," ") 

    aAdd(_aCab,{'A2_COD'    ,  _cCod        ,   NIL})
    aAdd(_aCab,{'A2_LOJA'   ,  _cLoja       ,   NIL})
    aAdd(_aCab,{'A2_NOME'   ,  _cRazsoc  	,   NIL})
    aAdd(_aCab,{'A2_NREDUZ' ,  _cNomeReduz	,   NIL})
    aAdd(_aCab,{'A2_END'    ,  _cEndereco 	,   NIL})
    aAdd(_aCab,{'A2_NR_END' ,  _cEndNum  	,   NIL})
    aAdd(_aCab,{'A2_BAIRRO' ,  _cBairro  	,   NIL})
    aAdd(_aCab,{'A2_EST'    ,  _cEstado  	,   NIL})
    aAdd(_aCab,{'A2_MUN'    ,  _cMunicipio	,   NIL})
    aAdd(_aCab,{'A2_CEP'    ,  _cCepForn  	,   NIL})
    aAdd(_aCab,{'A2_TIPO'    , _cTipo    	,   NIL})
    aAdd(_aCab,{'A2_CGC'    ,  _cCnpjCpf	,   NIL})


	MSExecAuto ({| x, y | Mata020 (x, y)}, _aCab, _nOpc)
	IF lMsErroAuto
		_aErro := GetAutoGRLog() // Retorna erro em array
		_cErro := ""
		For _nPos := 1 to len(_aErro)
			_cErro += _aErro[ _nPos ] + CRLF
		Next _nPos
	Endif
End Transaction
Return _cErro

//Localiza o ultimo numero utilizado para o código do Fornecedor
Static Function LocCod()
Local _cAlias 	:= GetNextAlias()
Local _cNumRet	:= StrZero(0,Len(SA2->A2_COD))
Begin Sequence
	BeginSql Alias _cAlias
		SELECT MAX(SA2.A2_COD) CCOD
       	FROM %table:SA2% SA2
       	WHERE SA2.A2_FILIAL        =  %XFilial:SA2%
		  AND SA2.%notDel%		  
	EndSql      
	If (_cAlias)->(!Eof())	
		_cNumRet := (_cAlias)->CCOD	
	Endif                                
	//Somar mais um no codigo fornecedor
	_cNumRet := StrZero(Val(_cNumRet)+1, Len(SA2->A2_COD))
End Sequence
If Select(_cAlias) <> 0
	(_cAlias)->(DbCloseArea())
	Ferase(_cAlias+GetDBExtension())
Endif  
Return _cNumRet		

/*
GET/DELETE
{  
   "principal":{  
      "_cCnpjCpf":"61366936000125"
      					
  				}
}


{
  "principal": {
    "_cCnpjCpf": "61366936000125",
    "dadosfornecedor": {
      "codigo": "000001",
      "nome": "FORNCEDOR PADRÃO NACIONAL 1",
      "nome_reduzido": "PADRÃO 1",
      "endereco": "RUA",
      "end_numero": "",
      "bairro": "",
      "municipio": "SAO PAULO",
      "estado": "SP",
      "cepfornec": "01000000",
      "tipo_fornecedor": "J"
    }
  }
}
