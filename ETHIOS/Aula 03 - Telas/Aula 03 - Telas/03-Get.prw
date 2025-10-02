#Include 'TOTVS.CH'

/*/{Protheus.doc} U_Get
    @type		Function
    @author		Milton J.dos Santos
    @since		01/03/2020
    @version	1.0.0
    @param		Nenhum
    @return		Vazio (nil)
    @example    Exemplo da utilizacao de Get
    @see		https://tdn.engpro.totvs.com.br/display/tec/@+...+GET
/*/

User Function Get()
Local oDlg, oGet1, oGet2 
Local cGet1 := Space(20)
Local cGet2 := Space(20)

DEFINE MsDialog oDlg TITLE "Exemplo de Get" FROM 180,180 TO 550,700 PIXEL

// Cria o Objeto tGet usando o comando @ .. GET
@ 10,10 GET oGet1 VAR cGet1 SIZE 200,20 OF oDlg PIXEL

// Cria o Objeto tGet usando o comando @ .. GET
@ 50,10 GET oGet2 VAR cGet2 SIZE 200,20 OF oDlg PIXEL VALID !empty(cGet2) PASSWORD

ACTIVATE MsDialog oDlg CENTERED

Return
