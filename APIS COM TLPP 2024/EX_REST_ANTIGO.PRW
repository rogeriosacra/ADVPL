#Include 'totvs.ch'
#Include 'tlpp-core.th'

{{APIS REST PROTHEUS}}

- WSRESTFUL: PALAVRA RESERVADA PARA DECLARA��O DA CLASSE COM SITAXE ESPEC�FICA PARA DESENVOLVIMENTO DE APIS
- END WSRESTFUL: INDICA O FIM DA DECLARA��O DE UM WEBSERVICE REST
- WSDATA: PALAVRA RESERVADA PARA DECLARA��O DAS PROPRIEDADES DE CLASSES DE API REST ADVPL
- WSMETHOD: PALAVRA RESERVADA PARA DECLARA��O DOS M�TODOS DE UMA CLASSE DA API REST
/*OBS.: NUMA API SOAP, OS M�TODOS PODEM TER O NOME QUE O DESENVOLVEDOR DESEJAR, POR�M NO REST, � NECESS�RIO OBEDECER 
O PADR�O DA ARQUITETURA REST UTILIZANDO OS VERBOS GET, POST, DELET, PUT*/
- WSSYNTAX: INDICA AS OP��ES DE ROTA PARA O M�TODO, EXEMPLOS:
/* HTTP://LOCALHOST:8081/API/PRODUTO
   HTTP://LOCALHOST:8081/API/PRODUTO/:CODIGO
   HTTP://LOCALHOST:8081/API/PRODUTO?nPagina=1&nCount=10 */

::aUrlParams
//Array contendo os par�metros enviados no formato path params na URL da rota 
::getcontent()
//M�todo interno da classe para recuperar o body para as requisi��es post e put
::setcontenttype('application/json)
//M�todo Interno da classe para indicar no header da requisi��o o tipo de dado a ser retornado)
::setresponse(cJson)
//M�todo interno � classe para indicar o corpo do retorno da requisi��o.
::SetRestFault(nCode,cMSG,lJson,cMSG2)
//Fun��o para indicar o tratamento de erro personalizado, caso necess�rio.
::JsonObject():new()
//Classe para convers�o de uma string formatada com json para um objeto JSON da linguagem advpl

EXEMPLO DE C�DIGO REST COM PADR�O BASEADO EM SOAP:

#include 'restful.ch'
#Include 'totvs.ch'

WSRESTFUL PRODUTO DESCRIPTION 'METODO DE ACESSO CADASTRO DE PRODUTOS'

WSDATA nPagina AS INTEGER
WSDATA nCount  AS INTEGER
WSDATA cResponse AS STRING 

WSMETHOD GET DESCRIPTION "CONSULTA PRODUTOS" WSSYNTAX '/api/prdutos/:codigo' // declara��o do m�todo get

END WSRESTFUL 

WSMETHOD GET WSRECEIVE nPagina, nCount WSSEND cResponse WSSERVICE PRODUTO //constru��o do m�todo declarado
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
 SetRestFault(400,"DADOS INV�LIDOS",.T."PAGINA INICIAL INVALIDA!")
 Return .F.
EndIf

//C�DIGO PARA LISTA DE PRODUTOS CONFORME PAR�METROS

::cResponse := '{"produtos":[]}'

Return .T.






 
