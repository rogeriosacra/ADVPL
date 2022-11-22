//#include 'parmtype.ch'
#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"

	
/*/{Protheus.doc} FOR3REST
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
			http://localhost:8081\REST\FOR3REST

/*/

WSRESTFUL FOR3REST DESCRIPTION "Serviço para integração Fornecedor" FORMAT APPLICATION_JSON
  WSDATA ccNpJcpf As String
 	WSMETHOD GET; 
	DESCRIPTION "Realiza a consulta Fornecedor";
	WSSYNTAX "/FOR3REST"
END WSRESTFUL
 
WSMETHOD GET WSRECEIVE ccNpJcpf WSSERVICE FOR3REST
Local oJson
Local cJson
Local _cCnpjCpf
Begin Sequence
    DbSelectArea("SA2")
    SA2->(DbSetOrder(03))  //A2_FILIAL+A2_CGC                                                                                                                                                                                                                                   
    ::SetContentType('application/json')
    oJson := JsonObject():new()
    oJson:fromJson(DecodeUTF8(Self:GetContent(,.T.)))  //Correto
    cJson := Self:GetContent(,.T.)
    _cCnpjCpf := AllTrim(oJson["principal"]:GetJsonText("_cCnpjCpf"))
    If !SA2->(DbSeek(XFilial("SA2")+_cCnpjCpf))
     	  Return SetMsgErro(Self,"Não localizado Fornecedor")
    Endif
    FreeObj(oJson)

    oJson := JsonObject():new()
    oJson['principal'] := JSonObject():New()
    oJson['principal']['cCnpjCpf'] := SA2->A2_CGC
    oJson['principal']['dadosfornecedor'] := JSonObject():New()
    oJson['principal']['dadosfornecedor']['codigo'] 		    := SA2->A2_COD
    oJson['principal']['dadosfornecedor']['loja'] 			    := SA2->A2_LOJA
    oJson['principal']['dadosfornecedor']['nome'] 			    := AllTrim(SA2->A2_NOME)
    oJson['principal']['dadosfornecedor']['nome_reduzido'] 	:= AllTrim(SA2->A2_NREDUZ)
    oJson['principal']['dadosfornecedor']['endereco'] 		  := AllTrim(SA2->A2_END)
    oJson['principal']['dadosfornecedor']['end_numero'] 		:= SA2->A2_NR_END
    oJson['principal']['dadosfornecedor']['bairro'] 		    := AllTrim(SA2->A2_BAIRRO)
    oJson['principal']['dadosfornecedor']['municipio'] 		  := AllTrim(SA2->A2_MUN)
    oJson['principal']['dadosfornecedor']['estado'] 		    := SA2->A2_EST
    oJson['principal']['dadosfornecedor']['cepfornec'] 		  := SA2->A2_CEP
    oJson['principal']['dadosfornecedor']['tipo_fornecedor']:= SA2->A2_TIPO
    
    cJson := oJson:toJSON()
    cJson := EncodeUTF8(cJson)
    ::SetResponse(cJson)
    conout(cJson)
    FreeObj(oJson)
End Sequence  
RETURN .T.


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



/*
{  
   "principal":{  
      "_cCnpjCpf":"61366936000125"
      					
  				}
}

{
  "principal": {
    "cCnpjCpf": "61366936000125",
    "dadosfornecedor": {
      "codigo": "000001",
      "loja": "01",
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
        "dadoscomprador": {
    }      
  }
}



*/
