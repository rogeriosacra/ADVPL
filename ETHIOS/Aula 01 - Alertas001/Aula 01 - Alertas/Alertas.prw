#INCLUDE "TOTVS.CH"

/*/ {Protheus.doc} User Function Alertas
    (Exemplos de funcoes de alerta)
    @type		Function
    @author		Milton J.dos Santos
    @since		01/03/2020
    @version	1.0.0
    @param		Nenhum
    @return		Vazio (nil)
    @example    (Examplos)
    @see (https://tdn.totvs.com/pages/)
/*/

User Function Alertas

// Alertas
Alert("Funcao Alert()")
MsgAlert("Mensagem","MsgAlert()")
ApMsgAlert("Mensagem", "ApMsgAlert" )

// Avisos com escolha
Aviso("Aviso()","Mensagem",{"Confirmar","Cancelar"},1,"Sub-Titulo")

// Informativos
MsgInfo("Mensagem","MsgInfo()")
ApMsgInfo("Mensagem", "ApMsgInfo()")

// Alertas com parada no processo
MsgStop("Mensagem","MsgStop()")
ApMsgStop("Mensagem","ApMsgStop()")

// Ajuda
Help("",1,"RECNO")

// Escolha Sim ou Não
MsgYesNo("Mensagem","MsgYesNo()")
ApMsgYesNo("Mensagem","ApMsgYesNo()") 
MsgNoYes("Mensagem","MsgNoYes()")
ApMsgNoYes("Mensagem","ApMsgNoYes()")
MsgYesNoTimer("Mensagem","MsgYesNoTimer()",10000,2)

// Falhas
MsgRetryCal("Mensagem","MsgRetryCal()")
MsgRetryCancel("Mensagem","MsgRetryCancel()")

Return
