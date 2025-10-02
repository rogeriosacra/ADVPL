#INCLUDE "TOTVS.CH"

/*/ {Protheus.doc} User Function MsgRun
    (Exemplos de funcoes de alerta)
    @type		Function
    @author		Milton J.dos Santos
    @since		01/03/2020
    @version	1.0.0
    @param		Nenhum
    @return		Vazio (nil)
    @example    (examples)
    @see		(https://tdn.totvs.com/display/tec/MsgRun)
/*/

User Function MsgRun

MsgRun("MsgRun","Processando",{|| Alert("Processamento...") })

Return
