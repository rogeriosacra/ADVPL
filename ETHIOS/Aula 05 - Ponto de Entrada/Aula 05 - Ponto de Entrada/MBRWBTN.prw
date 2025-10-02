#Include 'TOTVS.CH'

/*/{Protheus.doc} U_MBRWBTN
    @type		Ponto de Entrada
    @author		Milton J.dos Santos
    @since		01/03/2020
    @version	1.0.0
    @param		Nenhum
    @return		Vazio (nil)
    @example    Exemplo da utilizacao de MBRWBTN
    @see		https://tdn.totvs.com/pages/releaseview.action?pageId=6815197
/*/

// Este ponto de entrada tem por finalidade, validar se a rotina selecionada 
// na MBrowse será executada ou não a partir do retorno lógico do ponto de entrada.


User Function MBRWBTN()
Local cText := ""
Local lRet	:= .T.

cText := "Alias [ " + PARAMIXB[1]				+ " ]" + CRLF
cText += "Recno [ " + AllTrim(Str(PARAMIXB[2])) + " ]" + CRLF
cText += "Recno [ " + AllTrim(Str(PARAMIXB[3])) + " ]" + CRLF
cText += "Recno [ " + PARAMIXB[4]				+ " ]" + CRLF

lRet := MsgYesNo(cText,"Deseja Executar?")

Return lRet

