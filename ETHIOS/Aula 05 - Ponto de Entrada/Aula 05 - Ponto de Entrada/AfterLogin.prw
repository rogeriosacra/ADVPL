#Include "Protheus.ch"

/*/{Protheus.doc} U_AfterLogin
    @type		Ponto de Entrada
    @author		Milton J.dos Santos
    @since		01/03/2020
    @version	1.0.0
    @param		Nenhum
    @return		Vazio (nil)
    @example    Exemplo da utilizacao de AfterLogin
    @see		https://tdn.totvs.com/pages/releaseview.action?pageId=6815186
/*/

User Function AfterLogin()

Local cId	:= ParamIXB[1]
Local cNome := ParamIXB[2]

	ApMsgAlert("Usuário "+ cId + " - " + Alltrim(cNome)+" efetuou login às "+Time())
	  
Return

