#Include 'TOTVS.CH'

/*/{Protheus.doc} U_Input
    @type		Function
    @author		Milton J.dos Santos
    @since		01/03/2020
    @version	1.0.0
    @param		Nenhum
    @return		Vazio (nil)
    @example    Exemplo de uma tela que solicita dados ao usuário
/*/

User Function Input()
Local cNome := ""

	cNome := FwInputBox("Qual o seu nome?", cNome)
	Alert(cNome)

Return()
