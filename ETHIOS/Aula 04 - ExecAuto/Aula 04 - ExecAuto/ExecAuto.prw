#Include "Protheus.ch"
#include "TBICONN.CH"

/*/{Protheus.doc} MATA030
Função de exemplo para utilização da rotina automática de Clientes.
/*/
//-------------------------------------------------------------------

User Function MATA030()
 
Local aSA1Auto := {}
Local aAI0Auto := {}
Local nOpcAuto := 3
Local lRet := .T.
 
Private lMsErroAuto := .F.
 
lRet := RpcSetEnv("99","01","Admin")

If lRet
 
	 //----------------------------------
	 // Dados do Cliente
	 //----------------------------------
	 aAdd(aSA1Auto,{"A1_COD" ,"XBX141" ,Nil})
	 aAdd(aSA1Auto,{"A1_LOJA" ,"01" ,Nil})
	 aAdd(aSA1Auto,{"A1_NOME" ,"ROTINA AUTOMATICA" ,Nil})
	 aAdd(aSA1Auto,{"A1_NREDUZ" ,"ROTAUTO" ,Nil}) 
	 aAdd(aSA1Auto,{"A1_TIPO" ,"F" ,Nil})
	 aAdd(aSA1Auto,{"A1_END" ,"BRAZ LEME" ,Nil}) 
	 aAdd(aSA1Auto,{"A1_BAIRRO" ,"CASA VERDE" ,Nil}) 
	 aAdd(aSA1Auto,{"A1_EST" ,"SP" ,Nil})
	 aAdd(aSA1Auto,{"A1_MUN" ,"SAO PAULO" ,Nil})
	 aAdd(aSA1Auto,{"A1_INCISS" ,"N" ,Nil})
//	 aAdd(aSA1Auto,{"A1_GRPVEN" ,"000001" ,Nil})
	 
	 //---------------------------------------------------------
	 // Dados do Complemento do Cliente
	 //---------------------------------------------------------
	 aAdd(aAI0Auto,{"AI0_SALDO" ,30 ,Nil})
	 
	 //------------------------------------
	 // Chamada para cadastrar o cliente.
	 //------------------------------------
	 MSExecAuto({|a,b,c| MATA030(a,b,c)}, aSA1Auto, nOpcAuto, aAI0Auto)
	 
	 If lMsErroAuto 
	 	lRet := lMsErroAuto
	 	if isblind()
	 		Conout("OCORREU UM ERRO!")
	 	else
	 		MostraErro()// não usar via JOB
	 	endif
	 Else
	 	Conout("Cliente incluído com sucesso!")
	 EndIf
 
EndIf
 
RpcClearEnv()
 
Return lRet