#INCLUDE 'Protheus.ch'
#INCLUDE 'FwMvcDef.ch'
#INCLUDE 'RestFul.ch'
//1 - PARA WEBSERVICE REST NECESSÁRIO INCLUDE ESPECÍFICA RESTFUL.CH

/* 2- DEFINIÇÃO DA ESTRUTURA DO WEBSERVICE: PARA CRIARMOS UM WS É NECESSÁRIO
DEFINIR A ESTRUTURA DO MESMO, OU SEJA, ATRIBUTOS  E MÉTODOS QUE IREMOS DISPONIBILIZAR
WSRESTFUL: INÍCIO DA DECLARAÇÃO DA ESTRUTURA/ WSFORNREST=NOME DO WEBSERVICE/ DESCRIPTION= DESCRIÇÃO 
*/
// TEREMOS ENTÃO A SEGUINTE DEFINIÇÃO
WSRESTFUL WSFORNREST DESCRIPTION "Serviço de integração Fornecedor" FORMAT APPLICATION_JSON
WSMETHOD GET; 
DESCRIPTION "Realiza a consulta Fornecedor";
WSSYNTAX "/WSFORNREST"
END WSRESTFUL
//OS DEMAIS MÉTODOS (POST, PUT, DELETE) PODERIAM SEM INCLUIDOS NO MESMO LAÇO DO WSRESTFUL
WSMETHOD GET WSRECEIVE ccNpJcpf  WSSERVICE WSFORNREST
Local cErro
local oJson
Local cJson
//Abre tabela a tabela e posiciona no índice 03
DbSelectArea("SA2")
SA2->(DbSetOrder(03))//indice 03=A2_FILIAL+A2_CGC
//DEFINIÇÃO DO TIPO DE RETORNO
SetContentType('application/json')
//Cria um objeto a partir da classe JsonObject() método :New()
oJson := JsonObject():New()
//Converte uma string UTF-8 para um buffer com encondig especificado em Enconding
oJson:fromJson(DECODEUTF8( Self:GeTContent(,.T.)))
//Pega a String do Json
cJson := Self:GetContent(,.T.)
// Valida os dados do Json , chamada função customizada
cErro := ValoJson(oJson,"C")
//Retorna a mensagem de erro
IF !Empty(cErro)
        Return SetMsgErro(Self,cErro)
EndIF

//Já posicionado no registro pela função ValoJson()
//ESTRUTURA DE COMUNIÇÃO PARA O JSON:

cJson := '{'
cJson := ' "principal":{'
cJson := '      "cCnpjCpf":"' + EncodeUtf8(AllTrim(SA2->A2_CGC)  ,"cp1252") + '",'
cJson := '      "dadosfornecedor":{'
cJson := '                 "nome": "'   + EncodeUtf8(AllTrim(SA2->A2_NOME)  ,"cp1252") + '",'   
cJson := '                 "endereCo": "'   + EncodeUtf8(AllTrim(SA2->A2_END)  ,"cp1252") + '"' 
cJson := '                 }'
cJson := '              }'
cJson := '}'

//Função para verificar dados recebidos via Json e retornar caso 
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
        _cMsg := "Informar CNPJ/CPF é obrigatório !"
        BREAK
EndIf 
_cChave := XFilial("SA2")
_cChave += PADR( _cCnpjCpf, TamSx3("A2_CGC")[1] ,"" ) 
SA2->(DbSetOrder(03))//indice 03=A2_FILIAL+A2_CGC
_lAchou := SA2->(DBSEEK(_cChave))

IF !_lAchou .and. cTipo == "C"
        _cMSg := _cCnpjCpf + " não cadastrado, o processo será encerrado "
        BREAK
EndIf 
//Fazer validação
_cRazSoc :=  AllTrim(oJson["principal"]["dadosfornecedor"]:GetJsonText("nome"))
If   Empty(_cRazSoc)
        _cMsg := "Informar nome do fornecedor é obrigatório !"
        BREAK
EndIf 
End Sequence
Return(_cMSg)




