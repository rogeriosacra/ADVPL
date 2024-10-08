#include "TOTVS.ch"
#include "APWEBSERV.ch"

WSSERVICE APIPRODUTOSOAP; //DECLARA��O DA CLASSE APIPRODUTOSOAP 
DESCRIPTION 'API PARA MANIPULA��O DO CADASTRO DE PRODUTOS';// DESCRI��O APARECER� NO CAT�LOGO DE SERVICOS SOAP
NAMESPACE 'HTTP://APIPRODUTOSOAP.LOCALHOST.COM.BR'// 

WSDATA cCODIGO    AS STRING // estas vari�veis representam as propriedades que o XML tem que ter, ou seja, as informa��es que tem que constar na requisi��o 
WSDATA cDESCRICAO AS STRING // estas vari�veis representam as propriedades que o XML tem que ter
WSDATA nPESO      AS FLOAT  // estas vari�veis representam as propriedades que o XML tem que ter
WSDATA cRETORNO   AS STRING // estas vari�veis representam as propriedades que o XML tem que ter

WSMETHOD INCLUIR DESCRIPTION 'M�TODO PARA INCLUIR PRODUTOS'//M�TODO QUE SER� EXECUTADO, EQUIVALE AOS VERBOS DA ARQUITETURA REST, NESTE CASO SEU NOME � "INCLUIR", MAS PODERIA SE OUTRO. 
ENDWSSERVICE

WSMETHOD INCLUIR;
WSRECEIVE cCODIGO, cDESCRICAO, nPESO;
WSSEND cRETORNO;
WSSERVICE APIPRODUTOSOAP // RELACIOANDO M�TODO INCLUIR COM A API APIPRODUTOSOAP 

//DESENVOLVENDO O M�TODO INCLUIR, MENCIONADO DENTRO DA CLASSE, CUJA COMPORTAMENTO DEVE SER CODDIFICADO.  
// Os m�todos determinam o comportamento dos objetos de uma classe e s�o an�logos a fun��es ou procedimentos da programa��o estruturada

If empty(::cDESCRICAO) .OR. empty(::cCODIGO) 
   SetSoapFault("ERRO", "DESCRICAO N�O INFORMADA")
   Return .F.  
Endif

SB1->(reclock(SB1,.T.))
    SB1->B1_COD  := cCODIGO
    SB1->B1_DESC := cDESCRICAO
    SB1->B1_PESO := nPESO
SB1->(MSUnlock())

::cRETORNO := "PRODUTO INCLU�DO COM SUCESSO!"

Return .T.
