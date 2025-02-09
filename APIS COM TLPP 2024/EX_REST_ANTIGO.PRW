#Include 'totvs.ch'
#Include 'tlpp-core.th'

{{APIS REST PROTHEUS}}

- WSRESTFUL: PALAVRA RESERVADA PARA DECLARAÇÃO DA CLASSE COM SITAXE ESPECÍFICA PARA DESENVOLVIMENTO DE APIS
- END WSRESTFUL: INDICA O FIM DA DECLARAÇÃO DE UM WEBSERVICE REST
- WSDATA: PALAVRA RESERVADA PARA DECLARAÇÃO DAS PROPRIEDADES DE CLASSES DE API REST ADVPL
- WSMETHOD: PALAVRA RESERVADA PARA DECLARAÇÃO DOS MÉTODOS DE UMA CLASSE DA API REST
/*OBS.: NUMA API SOAP, OS MÉTODOS PODEM TER O NOME QUE O DESENVOLVEDOR DESEJAR, PORÉM NO REST, É NECESSÁRIO OBEDECER 
O PADRÃO DA ARQUITETURA REST UTILIZANDO OS VERBOS GET, POST, DELET, PUT*/
- WSSYNTAX: INDICA AS OPÇÕES DE ROTA PARA O MÉTODO, EXEMPLOS:
/* HTTP://LOCALHOST:8081/API/PRODUTO
   HTTP://LOCALHOST:8081/API/PRODUTO/:CODIGO
   HTTP://LOCALHOST:8081/API/PRODUTO?nPagina=1&nCount=10 */

::aUrlParams
//Array contendo os parâmetros enviados no formato path params na URL da rota 
::getcontent()
//Método interno da classe para recuperar o body para as requisições post e put
::setcontenttype('application/json)
//Método Interno da classe para indicar no header da requisição o tipo de dado a ser retornado)
::setresponse(cJson)
//Método interno à classe para indicar o corpo do retorno da requisição.
::SetRestFault(nCode,cMSG,lJson,cMSG2)
//Função para indicar o tratamento de erro personalizado, caso necessário.
::JsonObject():new()
//Classe para conversão de uma string formatada com json para um objeto JSON da linguagem advpl

EXEMPLO DE CÓDIGO REST COM PADRÃO BASEADO EM SOAP:

#include 'restful.ch'
#Include 'totvs.ch'

WSRESTFUL PRODUTO DESCRIPTION 'METODO DE ACESSO CADASTRO DE PRODUTOS'

WSDATA nPagina AS INTEGER
WSDATA nCount  AS INTEGER
WSDATA cResponse AS STRING 

WSMETHOD GET DESCRIPTION "CONSULTA PRODUTOS" WSSYNTAX '/api/prdutos/:codigo' // declaração do método get

END WSRESTFUL 

WSMETHOD GET WSRECEIVE nPagina, nCount WSSEND cResponse WSSERVICE PRODUTO //construção do método declarado
Local cIdProduto := ''
Local cContent   := ::GetContent()
Local jContent   := JsonObject():New()

jContent::FromJson(cContent)

if len(::aUrlParams) > 0
cIdProduto := ::aURLParms[1]
EndIf

Default ::nPagina := 1
Default ::nCount := 10

if ::nPagina := -1
 SetRestFault(400,"DADOS INVÁLIDOS",.T."PAGINA INICIAL INVALIDA!")
 Return .F.
EndIf

//CÓDIGO PARA LISTA DE PRODUTOS CONFORME PARÂMETROS

::cResponse := '{"produtos":[]}'

Return .T.






 
