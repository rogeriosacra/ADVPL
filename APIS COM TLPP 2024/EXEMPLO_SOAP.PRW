#include "TOTVS.ch"
#include "APWEBSERV.ch"

WSSERVICE APIPRODUTOSOAP; //DECLARAÇÃO DA CLASSE APIPRODUTOSOAP 
DESCRIPTION 'API PARA MANIPULAÇÃO DO CADASTRO DE PRODUTOS';// DESCRIÇÃO APARECERÁ NO CATÁLOGO DE SERVICOS SOAP
NAMESPACE 'HTTP://APIPRODUTOSOAP.LOCALHOST.COM.BR'// 

WSDATA cCODIGO    AS STRING // estas variáveis representam as propriedades que o XML tem que ter, ou seja, as informações que tem que constar na requisição 
WSDATA cDESCRICAO AS STRING // estas variáveis representam as propriedades que o XML tem que ter
WSDATA nPESO      AS FLOAT  // estas variáveis representam as propriedades que o XML tem que ter
WSDATA cRETORNO   AS STRING // estas variáveis representam as propriedades que o XML tem que ter

WSMETHOD INCLUIR DESCRIPTION 'MÉTODO PARA INCLUIR PRODUTOS'//MÉTODO QUE SERÁ EXECUTADO, EQUIVALE AOS VERBOS DA ARQUITETURA REST, NESTE CASO SEU NOME É "INCLUIR", MAS PODERIA SE OUTRO. 
ENDWSSERVICE

WSMETHOD INCLUIR;
WSRECEIVE cCODIGO, cDESCRICAO, nPESO;
WSSEND cRETORNO;
WSSERVICE APIPRODUTOSOAP // RELACIOANDO MÉTODO INCLUIR COM A API APIPRODUTOSOAP 

//DESENVOLVENDO O MÉTODO INCLUIR, MENCIONADO DENTRO DA CLASSE, CUJA COMPORTAMENTO DEVE SER CODDIFICADO.  
// Os métodos determinam o comportamento dos objetos de uma classe e são análogos a funções ou procedimentos da programação estruturada

If empty(::cDESCRICAO) .OR. empty(::cCODIGO) 
   SetSoapFault("ERRO", "DESCRICAO NÃO INFORMADA")
   Return .F.  
Endif

SB1->(reclock(SB1,.T.))
    SB1->B1_COD  := cCODIGO
    SB1->B1_DESC := cDESCRICAO
    SB1->B1_PESO := nPESO
SB1->(MSUnlock())

::cRETORNO := "PRODUTO INCLUÍDO COM SUCESSO!"

Return .T.
