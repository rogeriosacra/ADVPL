//#include 'parmtype.ch'
#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"
#INCLUDE 'Protheus.ch'


	
/*/{Protheus.doc} FOR1REST
Serviço de integração  para integração cadastro de fornecedores
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
			http://localhost:8081\REST\FOR1REST
/*/

WSRESTFUL FOR1REST DESCRIPTION "Serviço para integração Fornecedor" FORMAT APPLICATION_JSON // Format: indica formato do arquivo
	WSMETHOD POST; 
	DESCRIPTION "Realiza a inclusão Fornecedor";
	WSSYNTAX "/FOR1REST"// NESTA NOTAR QUE O MÉTODO POST  É APONTADO PARA O WSRESTFUL "FOR1REST"
	WSMETHOD PUT; 
	DESCRIPTION "Realiza a alteração Fornecedor";
	WSSYNTAX "/FOR1REST"
	WSMETHOD DELETE; 
	DESCRIPTION "Realiza a exclusão Fornecedor";
	WSSYNTAX "/FOR1REST"
	WSMETHOD GET; 
	DESCRIPTION "Realiza a consulta Fornecedor";
	WSSYNTAX "/FOR1REST"
END WSRESTFUL
 
 
/*/{Protheus.doc} POST
Realiza a inclusão de configuração de folha
@author DAC - Denilso
@since 
@version undefined
@type function
/*/
WSMETHOD POST WSSERVICE FOR1REST// AQUI O DESENV DO MÉTODO POST
Local cErro
DbSelectArea("SA2") // SELECIONA A ÁREA DA SA2
SA2->(DbSetOrder(03))  //A2_FILIAL+A2_CGC                                                                                                                                                                                                                                   
::SetContentType('application/json')// SETA O TYPO CONTEÚDO COMO JASON
oJson := JsonObject():new() // CRIA UM OBJETO
oJson:fromJson(DecodeUTF8(Self:GetContent(,.T.)))      //Correto: GET CONTEÚDO DO httP, DEPOIS USA DECODIFICAÇÃO utf8
cJson := Self:GetContent(,.T.) // TANTO FAZ USAR O COMANDO SELF OU :: 
// Valida os dados do oJson
cErro := ValoJson(oJson,"I")
If !Empty(cErro)
	Return SetMsgErro(Self,cErro)
Endif
// Realiza a gravação na tabela ZCA
GravaSA2(oJson,"I")
Return SetMsgOk(self,"Integracao realizada com sucesso")


/*/{Protheus.doc} PUT
Realiza a atualizacao de Faturamento de nota
@author DAC - Denilso
@since 
@version undefined
@type function
/*/
WSMETHOD PUT WSSERVICE FOR1REST
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
GravaSA2(oJson,"A")
Return SetMsgOk(self,"Atualização realizada com sucesso")


/*/{Protheus.doc} DELETE
Realiza a exclusão de Faturamento de nota
@author DAC - Denilso
@since 
@version undefined
@type function
/*/
WSMETHOD DELETE WSSERVICE FOR1REST
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
WSMETHOD GET WSSERVICE FOR1REST
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
cJson += '										"codigo": "'			+ EncodeUTF8(AllTrim(SA2->A2_COD)	, "cp1252") + '",'
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
Local _lAchou 

Begin Sequence
	// Verifica se enviou o id Configuração
	_cCnpjCpf := AllTrim(oJson["principal"]:GetJsonText("_cCnpjCpf"))// OBTEM DA ESTRUTURA DO JASON (COR LARANJA) O CNPJ
	If Empty(_cCnpjCpf)
		_cMsg := "Não informado CNPJ/CPF obrigatório !"
		Break
	Endif
	_cChave := XFilial("SA2")
	_cChave += Padr(_cCnpjCpf,TamSX3("A2_CGC")[1]	  ," ") // adaptação de tamanho entre o o campo do cCnpj e A2_CGC

	SA2->(DbSetOrder(03))  //A2_FILIAL+A2_CGC 	//para consulta e exclusão não será exigido o ID Contrato
	_lAchou := SA2->(DbSeek(_cChave))
	If _lAchou .and. cTipo == "I" // Tipo I = inclusão
		_cMsg := "Fornecedor com CNPJ/CPF "+_cCnpjCpf+" já cadastrado, não poderá ser incluído !" 
		Break
	ElseIf !_lAchou .and. (cTipo == "C" .or. cTipo == "E")// Consulta ou Exclusão
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
Static Function GravaSA2(oJson,cTipo)
//Local _lInclui := If(cTipo == "I",.T.,.F.)  //nao faco a vialidação de inclusão e ou exclusão pois é mandado itens e na validação ja trata esta questão
Local _lGrava

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
Local _cCodigo		:= Space(006)
Begin Transaction
	_cCnpjCpf 		:= AllTrim(oJson["principal"]:GetJsonText("_cCnpjCpf"))
	_cCodigo	  	:= AllTrim(oJson["principal"]["dadosfornecedor"]:GetJsonText("codigo"))
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
	_lGrava := !SA2->(DbSeek( _cChave ))

	If RecLock("SA2",_lGrava)
		SA2->A2_FILIAL	:= XFilial("SA2")
		SA2->A2_COD		:= _cCodigo 		
		SA2->A2_CGC		:= _cCnpjCpf 		
		SA2->A2_NOME	:= _cRazsoc	  	
		SA2->A2_NREDUZ	:= _cNomeReduz	  	 
		SA2->A2_END		:= _cEndereco	  	
		SA2->A2_NR_END	:= _cEndNum	    
		SA2->A2_BAIRRO	:= _cBairro 		
		SA2->A2_MUN		:= _cMunicipio	  	
		SA2->A2_EST		:=	_cEstado      	
		SA2->A2_CEP		:= _cCepForn	  	
		SA2->A2_TIPO	:= _cTipo   		
		SA2->(MsUnlock())
	Endif	
End Transaction
Return Nil
//=======================================================================================================================================

/*

	_cCnpjCpf 		:= AllTrim(oJson["principal"]:GetJsonText("_cnpj_cpf"))
	_cRazsoc	  	:= AllTrim(oJson["principal"]["dadosfornecedor"]:GetJsonText("nome"))
	_cNomeReduz	  	:= AllTrim(oJson["principal"]["dadosfornecedor"]:GetJsonText("nome_reduzido")) 
	_cEndereco	  	:= AllTrim(oJson["principal"]["dadosfornecedor"]:GetJsonText("endereco"))
	_cEndNum	    := AllTrim(oJson["principal"]["dadosfornecedor"]:GetJsonText("end_numero"))
	_cBairro 		:= AllTrim(oJson["principal"]["dadosfornecedor"]:GetJsonText("bairro"))
	_cMunicipio	  	:= AllTrim(oJson["principal"]["dadosfornecedor"]:GetJsonText("municipio"))
	_cEstado      	:= AllTrim(oJson["principal"]["dadosfornecedor"]:GetJsonText("estado"))
	_cCepForn	  	:= AllTrim(oJson["principal"]["dadosfornecedor"]:GetJsonText("cepfornec"))
	_cTipo   		:= AllTrim(oJson["principal"]["dadosfornecedor"]:GetJsonText("tipo_fornecedor"))

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
*/
