#Include "Protheus.ch"
#Include "AP5MAIL.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ REGISTRA ºAutor  ³ Milton J.dos Santosº Data ³  18/05/14       º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Transfere um arquivo local para o Ftp                           ³±±
±±³          ³                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³FtpTransfere(cFtpHost, cFtpLogin, cFtpSenha, cFtpPorta,         ³±±
±±³          ³    cDirOrigem, cDirDestino, cArqOrigem, cArqDestino, cLog)     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cFtpHost		Host Ftp                                          ³±±
±±³          ³ cFtpLogin	Login de acesso ao Ftp                            ³±±
±±³          ³ cFtpSenha	Senha de acesso ao Ftp                            ³±±
±±³          ³ nFtpPorta	Porta de acesso ao Ftp                            ³±±
±±³          ³ cDirOrigem	Diretorio de origem do arquivo a ser transferido  ³±±
±±³          ³ cDirDestino Diretorio de destino no Ftp                        ³±±
±±³          ³ cArqOrigem	Nome do arquivo de origem (local)                 ³±±
±±³          ³ cArqDestino	Nome do arquivo final (ftp)                       ³±±
±±³          ³ cLog			Retorno das mensagens de erro (por referencia)    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Linha pronta para gravacao no arquivo texto                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function Registra

Local lRet         := .F.
Local cBARRAS      := If(isSRVunix(),"/","\")
Local cBarLocal    := if(GetRemoteType() == 2, "/", "\" ) // Linux

Local  cFtpHost   := "ftp.centralrepair.com.br"
Local  cFtpLogin  := "centralr"
Local  cFtpSenha  := "1=7398=$#@"
Local  nFtpPorta  := 21
Local  cDirOrigem := "\TMP\" 
Local  cDirDestino:= "teste/"  
Local  cArqOrigem := "teste.txt"
Local  cArqDestino:= "teste.txt" 
Local  cLog       := "" 

U_FtpEnvREG(cFtpHost, cFtpLogin, cFtpSenha, nFtpPorta, cDirOrigem, cDirDestino, cArqOrigem, cArqDestino, cLog)

U_FtpRecREG(cFtpHost, cFtpLogin, cFtpSenha, nFtpPorta, cDirOrigem, cDirDestino, cArqOrigem, cArqDestino, cLog)

Return

User Function FtpEnvREG(cFtpHost, cFtpLogin, cFtpSenha, nFtpPorta, cDirOrigem, cDirDestino, cArqOrigem, cArqDestino, cLog)

Private aMsg       := {}

//+-------------------------
//| Envia Dados para o FTP
//+-------------------------

FTPDisconnect()
If FTPConnect(cFtpHost,nFtpPorta,cFtpLogin,cFtpSenha)
	FTPDirChange(cDirDestino)
	FTPSetType(1)    
	If File(cDirOrigem + cArqOrigem)
		FTPErase(cArqOrigem)
		If FTPUpload(cDirOrigem + cArqOrigem ,cArqOrigem)
			__CopyFile(cDirOrigem + cArqOrigem ,cDirOrigem + "enviado\ " + cArqOrigem )
			aAdd(aMsg,"Upload Realizado com sucesso")
//			SendEMail()
		Else
			aAdd(aMsg,"Nao foi possivel realizar o download!!")
			Return NIL
		Endif
	Endif
	FTPDisconnect()
Endif
Return

//+----------------------
//| Recebe Dados do FTP
//+----------------------

User Function FtpRecREG(cFtpHost, cFtpLogin, cFtpSenha, nFtpPorta, cDirOrigem, cDirDestino, cArqOrigem, cArqDestino, cLog)

Private aMsg       := {}

FTPDisconnect()
If FTPConnect(cFtpHost,nFtpPorta,cFtpLogin,cFtpSenha)
	If FTPDOWNLOAD ( cDirOrigem + "recebido\"+ cArqOrigem , cArqOrigem)
		aadd(aMsg,"Download Realizado com sucesso")
	//	SendEMail()
	Else
		aadd(aMsg,"Nao foi possivel realizar o download!!")
		Return NIL
	EndIf                    
	FTPDisconnect()
Endif
Return
