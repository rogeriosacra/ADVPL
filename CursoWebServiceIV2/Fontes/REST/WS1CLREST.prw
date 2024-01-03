#INCLUDE 'PARMTYPE.CH'
#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"


	
/*/{Protheus.doc} WS1CLREST
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
			http://localhost:8081\REST\WS1CLREST

         https://centraldeatendimento.totvs.com/hc/pt-br/articles/360021048151-MP-ADVPL-RESPOSTA-JSON-EM-OBJETO
         https://centraldeatendimento.totvs.com/hc/pt-br/articles/360022851712-MP-ADVPL-RETORNAR-TODOS-OS-REGISTROS-UTILIZANDO-AS-API-TOTVS
         https://gist.github.com/vitorebatista/ce02d17cff99b39b67a852bf23d86bf9
executar no browse web https://www.receitaws.com.br/v1/cnpj/53113791000122
/*/

#include 'totvs.ch'
#include 'restful.ch'

WSRESTFUL WS1CLREST DESCRIPTION "Pesquisa CNPJ de Clientes" FORMAT APPLICATION_JSON
	WSMETHOD GET; 
	DESCRIPTION "Realiza a consulta Cliente";
	WSSYNTAX "/WS1CLREST"
END WSRESTFUL

WSMETHOD GET  WSSERVICE WS1CLREST
Local nStart    := Seconds() // HORA DE INÍCIO DA FUNÇÃO
Local oJSON     := NIL       // OBJETO JSON QUE RETORNADO PELA FUNÇÃO
Local oREST     := NIL       // OBJETO REST PARA GERAÇÃO DE REQUISIÇÃO
Local aHeader   as aRray        // CABEÇALHO DE INFORMAÇÕES DA REQUISIÇÃO
Local _aResult

Begin Sequence
    //RPCSetEnv("99", "01") // PREPARAÇÃO DE AMBIENTE (REMOVER SE EXECUTADO VIA SMARTCLIENT)
    oREST := FwRest():New("https://www.receitaws.com.br/v1/cnpj/53113791000122") // INSTANCIAÇÃO DE OBJETO REST
    // CAMINHO DO RECURSO WEB
    oREST:SetPath("")
    // INÍCIO DE REQUISIÇÃO GET
    If (oREST:Get(aHeader))
       _aResult :=  FwJSONDeserialize(oREST:cResult, @oJSON) // DESERIALIZAÇÃO DE STRING PARA OBJETO
    // MENSAGEM DE SUCESSO
    	FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01",;
        	             "JSON successfully parsed to Object", 0, (nStart -Seconds()), {})
    Else
        // MENSAGEM DE ERRO
        FwLogMsg("ERROR", /*cTransactionId*/, "REST", FunName(), "", "01",;
    			          "Can't successfully parse JSON to Object", 0, (nStart - Seconds()), {})
    EndIf
End Sequence	
Return .T.


//-------------------------------------------------------------------
/*{Protheus.doc} EREST_02
Função para testes do método GET da API Produtos1
@author Daniel Mendes
@since 06/07/2020
@version 1.0
*/
//-------------------------------------------------------------------
user function EREST_02()
local oRestClient as object
local aHeader as array

oRestClient := FWRest():New("http://10.21.1.24:8093")
aHeader := {"CODPRODUTO:300001"}

oRestClient:setPath("/resty/PRODUTOS1")

if oRestClient:Get(aHeader)
   ConOut("GET", oRestClient:GetResult())
else
   ConOut("GET", oRestClient:GetLastError())
endif

FreeObj(oRestClient)

return
