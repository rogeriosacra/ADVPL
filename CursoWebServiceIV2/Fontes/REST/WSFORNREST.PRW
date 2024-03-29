#INCLUDE 'Protheus.ch'
#INCLUDE 'FwMvcDef.ch'
#INCLUDE 'RestFul.ch'
//1 - PARA WEBSERVICE REST NECESS�RIO INCLUDE ESPEC�FICA RESTFUL.CH

/* 2- DEFINI��O DA ESTRUTURA DO WEBSERVICE: PARA CRIARMOS UM WS � NECESS�RIO
DEFINIR A ESTRUTURA DO MESMO, OU SEJA, ATRIBUTOS  E M�TODOS QUE IREMOS DISPONIBILIZAR
WSRESTFUL: IN�CIO DA DECLARA��O DA ESTRUTURA/ WSFORNREST=NOME DO WEBSERVICE/ DESCRIPTION= DESCRI��O 
*/
// TEREMOS ENT�O A SEGUINTE DEFINI��O
WSRESTFUL WSFORNREST DESCRIPTION "Servi�o de integra��o Fornecedor" FORMAT APPLICATION_JSON
WSMETHOD GET; 
DESCRIPTION "Realiza a consulta Fornecedor";
WSSYNTAX "/WSFORNREST"
END WSRESTFUL
//OS DEMAIS M�TODOS (POST, PUT, DELETE) PODERIAM SEM INCLUIDOS NO MESMO LA�O DO WSRESTFUL
WSMETHOD GET WSRECEIVE ccNpJcpf  WSSERVICE WSFORNREST
Local cErro
local oJson
Local cJson
//Abre tabela a tabela e posiciona no �ndice 03
DbSelectArea("SA2")
SA2->(DbSetOrder(03))//indice 03=A2_FILIAL+A2_CGC
//DEFINI��O DO TIPO DE RETORNO
SetContentType('application/json')
//Cria um objeto a partir da classe JsonObject() m�todo :New()
oJson := JsonObject():New()
//Converte uma string UTF-8 para um buffer com encondig especificado em Enconding
oJson:fromJson(DECODEUTF8( Self:GeTContent(,.T.)))
//Pega a String do Json
cJson := Self:GetContent(,.T.)
// Valida os dados do Json , chamada fun��o customizada
cErro := ValoJson(oJson,"C")
//Retorna a mensagem de erro
IF !Empty(cErro)
        Return SetMsgErro(Self,cErro)
EndIF

//J� posicionado no registro pela fun��o ValoJson()
//ESTRUTURA DE COMUNI��O PARA O JSON:

cJson := '{'
cJson := ' "principal":{'
cJson := '      "cCnpjCpf":"' + EncodeUtf8(AllTrim(SA2->A2_CGC)  ,"cp1252") + '",'
cJson := '      "dadosfornecedor":{'
cJson := '                 "nome": "'   + EncodeUtf8(AllTrim(SA2->A2_NOME)  ,"cp1252") + '",'   
cJson := '                 "endereCo": "'   + EncodeUtf8(AllTrim(SA2->A2_END)  ,"cp1252") + '"' 
cJson := '                 }'
cJson := '              }'
cJson := '}'

//Fun��o para verificar dados recebidos via Json e retornar caso 
Static Function ValoJson(oJson,cTipo)
Local _cCnpjCpf := Space(014)
Local _cMSg     := Space(001)
Local _cChave   := Space(001)
Local _cRazSoc  := Space(040)
Local _lAchou 

Begin SEQUENCE
//Verifica se enviou o CNPJ na chamada do WEBservice
_cCnpjCpf := AllTrim(oJson["principal"]:GetJsonText("cCnpjCpf"))
If   Empty(_cCnpjCpf)
        _cMsg := "Informar CNPJ/CPF � obrigat�rio !"
        BREAK
EndIf 
_cChave := XFilial("SA2")
_cChave += PADR( _cCnpjCpf, TamSx3("A2_CGC")[1] ,"" ) 
SA2->(DbSetOrder(03))//indice 03=A2_FILIAL+A2_CGC
_lAchou := SA2->(DBSEEK(_cChave))

IF !_lAchou .and. cTipo == "C"
        _cMSg := _cCnpjCpf + " n�o cadastrado, o processo ser� encerrado "
        BREAK
EndIf 
//Fazer valida��o
_cRazSoc :=  AllTrim(oJson["principal"]["dadosfornecedor"]:GetJsonText("nome"))
If   Empty(_cRazSoc)
        _cMsg := "Informar nome do fornecedor � obrigat�rio !"
        BREAK
EndIf 
End Sequence
Return(_cMSg)




