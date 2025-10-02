#Include "Protheus.ch"

/*/{Protheus.doc} U_SduLogin
    @type		Ponto de Entrada
    @author		Milton J.dos Santos
    @since		01/03/2020
    @version	1.0.0
    @param		Nenhum
    @return		Vazio (nil)
    @example    Exemplo da utilizacao de SduLogin
    @see		https://tdn.totvs.com/display/public/PROT/SDULogin+-+Entrada+e+acesso
/*/

User Function SduLogin()
Local lRet	:= .T.
Local cUser	:= ParamIXB

MsgAlert("Usuário "+ Alltrim(cUser) + " efetuou login no APSDU em " + DTOC(Date()) + " às "+Time())

Return .T.

