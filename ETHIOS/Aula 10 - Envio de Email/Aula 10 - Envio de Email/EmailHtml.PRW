#include "rwmake.ch"
#include "ap5mail.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO2     บAutor  ณMicrosiga           บ Data ณ  08/10/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Envia email em Html                                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP5                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function EmailHtml()
      Private lEnvia := .F.
      Private cPass     := Space(25)
      Private cAccount  := "seu@email.com.br"
      Private cServer   := "smtp.suaconta.com.br"
      Private cPara     := "email@para.com.br

      lEnvia := Dialogo()
      If lEnvia
         EnviaEmail()
         Alert("Email Enviado !")
      Endif
Return


Static Function Enviaemail()

Local cMensagem   := ''
Local aLista      := {}
Local CRLF := chr(13)+chr(10)
Local cMSG := ""

Private aDados := {}

cMsg += '<html>' + CRLF
cMsg += '<head>' + CRLF
cMsg += '<title> E X E M P L O </title>' + CRLF
cMsg += '</head>' + CRLF

cMsg += '<b><font size="3" face="Arial">Email enviado atraves do Ap5</font></b>' + CRLF

cMsg += '<font size="2" face="Arial">Retorna Cadastro de Clientes em forma de tabela.</font>' + CRLF

//Abre Tabela
cMsg += '<table border="1" width="100%" bgcolor="#0080C0">'
cMsg += '<tr>'
cMsg += '<td width="30%">'
cMsg += '<font size="2" face="Arial">Codigo/Loja</font></td>'
cMsg += '<td width="60%">'
cMsg += '<font size="2" face="Arial">Nome</font></td>'
cMsg += '<td width="10%">'
cMsg += '<font size="2" face="Arial">Estado</font></td>'
cMsg += '</tr>' + CRLF

aDados := BuscaDados()

//Preenche Tabela
For x:= 1 to Len(aDados)

    cCodigo := alltrim(aDados[x,1]) + "/" + alltrim(aDados[x,2])
    cNome   := alltrim(aDados[x,3])
    cEstado := alltrim(aDados[x,4])

    cMsg += '<tr>'
    cMsg += '<td width="30%">'
    cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + cCodigo + '</font></td>'
    cMsg += '<td width="60%">'
    cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + cNome + '</font></td>'
    cMsg += '<td width="10%">'
    cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + cEstado + '</font></td>'
    cMsg += '</tr>' + CRLF

Next

//Fecha Tabela
cMsg += '</table>'


cMsg += '</body>' + CRLF
cMsg += '</html>' + CRLF

Aadd( aLista, cPara )

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPass

SEND MAIL FROM cAccount   ;
TO aLista[1]  ;
SUBJECT 'TESTE EMAIL AP5'                     ;
BODY cMsg

DISCONNECT SMTP SERVER

Return


Static Function BuscaDados()

Local  nCounter := 0

DbSelectArea("SA1")
DbSetOrder(1)
DbGotop()

While !Eof() 

      //CODIGO,LOJA,NOME,ESTADO
      AADD( aDados, {SA1->A1_COD,SA1->A1_LOJA, SA1->A1_NOME, SA1->A1_EST} )
      
      nCounter++
      DbSkip()
      
      If nCounter >= 10
         Exit
      Endif
      
Enddo

Return(aDados)



Static Function Dialogo()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Criacao da Interface                                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
@ 106,74 To 346,606 Dialog oDialog Title OemToAnsi("T E S T E -- Email")
@ 9,12 To 63,196 Title OemToAnsi("Dados para Envio de Email- REMETENTE") Object Quadro
@ 25,24 Say OemToAnsi("Servidor SMTP") Size 42,8
@ 38,25 Say OemToAnsi("Conta Email") Size 34,8
@ 49,26 Say OemToAnsi("Senha") Size 42,8

@ 24,68 Get cServer Size 115,10
@ 38,68 Get cAccount Size 115,10
@ 51,68 Get cPass Size 115,9 PASSWORD

@ 67,25 Say OemToAnsi("Enviar Para:") Size 34,8
@ 67,68 Get cPara Size 115,10

@ 13,207 Button OemToAnsi("_Confirma") Size 36,16 Action Close(oDialog)
@ 33,207 Button OemToAnsi("_Cancela") Size 36,16 Action Close(oDialog)
ACTIVATE MsDialog oDialog
 cServer  := alltrim(cServer)
 cAccount := alltrim(cAccount)
 cPass    := alltrim(cPass)
 cPara    := alltrim(cPara)
 lEnvia   := .T.
 Alert(alltrim(cPass))
Return(lEnvia)
