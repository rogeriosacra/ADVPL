#Include "Protheus.ch"

User Function xExcel()

Local aCabExcel :={}
Local aItensExcel :={}

	//-----------------------
	// Colunas              |
	//-----------------------
	Aadd(aCabExcel, {"CODIGO" ,"C", 06, 0})
	Aadd(aCabExcel, {"NOME" ,"C", 30, 0})

	//-----------------------
	// Linhas               |
	//-----------------------
	Aadd(aItensExcel, {"000001", "JULIA",""})
	Aadd(aItensExcel, {"000002", "MARIA",""})

	MsgRun("Carregando...", "Selecionando os Registros",;
	{|| GProcItens(aCabExcel, @aItensExcel)})

	MsgRun("Carregando...", "Exportando para o Excel",;
	{||DlgToExcel({{"GETDADOS","Dados dos Clientes",aCabExcel,aItensExcel}})})
Return

/*	[19:39, 21/01/2020] Solsol: #include 'protheus.ch'
	#include 'parmtype.ch'
	#include "fileio.ch"*/

/*/{Protheus.doc} delline
// TODO Descrição Alteração do arquivo xml/txt.
@author Solange Sspirano
@since 30/09/2019
@version undefined

@type function 
/*/

User Function delline()
	local  cString	 
	local  cLine
	local  nX 
	local  cLocalFile  	:= ""//"C:\teste\XML_DTOS\"      		// local do arquivo de alterado
	local  cLocalDest  	:= "C:\TESTE\IMP\"  			    //local de destino
	//local  cLogArquivo	:= "LOG DE PROCESSAMENTO"
	local  cLogError	:= "..."
	local  cLogProcesso	:= ProcName()
	//local  cDiretorio  	:= "C:\teste\Log_Imp\"
	local  cMascara  	:= "Todos os arquivos|."
	local  cTitulo   	:= "Escolha o arquivo"
	local  nMascpad  	:= 0
	local  cDirIni   	:= "\"
	local  lSalvar   	:= .F. /*.T. = Salva || .F. = Abre*/
	local  nOpcoes   	:= GETF_LOCALHARD
	local  lArvore   	:= .F. /*.T. = apresenta o árvore do servidor || .F. = não apresenta*/

	PRIVATE aFiles 		:= {}       						//array os arquivos a serem mofificados

	cLocalFile	        := cGetFile( cMascara, cTitulo, nMascpad, cDirIni, lSalvar, nOpcoes, lArvore)

	cLocalFile			:= SubStr(cLocalFile,1,len(cLocalFile)-1)

	ADIR(cLocalFile+ "*.XML", aFiles)


	makedir("C:\TESTE\")
	makedir("C:\TESTE\IMP\")

	For nX := 1 to Len(aFiles)

		// Abre o arquivo
		nHandle := fopen(cLocalFile+Alltrim(aFiles[nX]) , FO_READWRITE + FO_SHARED )          //busca e abre o arquivo
		// Se houver erro de abertura abandona processamento
		if nHandle = -1
			//gravalog     
			cLogError := Alltrim(aFiles[nX])+ " arquivo não foi alterado."
			U_LogFunction(,cLogError,cLogProcesso,.t.)
			//	copia o arquivo alterado do local de origem para o destino	
			LOOP
		endif 

		FT_FGoTop()

		cString := FReadStr( nHandle, 62 )  				
		cLine  := FT_FReadLn()
		If '<retornoEvento' $ cLine
			fclose(nHandle)  
			cLogError := Alltrim(aFiles[nX])+ " arquivo não foi alterado."
			U_LogFunction(,cLogError,cLogProcesso,.t.)
			loop
		endif
		cLine :=''
		FWrite(nHandle, "v02_05_00")
		fclose(nHandle)    
		// Alterar o nome do arquivo.

		__CopyFile(cLocalFile+Alltrim(aFiles[nX]),cLocalDest+Alltrim(aFiles[nX]))     
		FErase(cLocalFile + Alltrim(aFiles[nX]))										 
		cLogError := Alltrim(aFiles[nX])+ " arquivo foi alterado."
		U_LogFunction(,cLogError,cLogProcesso,.t.)
	NEXT 	nX // não é necessário usar o nX  depois do NEXnotT conforme orientação do "Analista Roberto Santiago" 

	MsgInfo("Arquivo gerado no diretorio " + cLocalDest +".")

Return
