#Include 'TOTVS.CH'

/*/{Protheus.doc} U_Folder
    @type		Function
    @author		Milton J.dos Santos
    @since		01/03/2020
    @version	1.0.0
    @param		Nenhum
    @return		Vazio (nil)
    @example    Exemplo da utilizacao de Folders Instantâneos (Pastas)
    @see		https://tdn.engpro.totvs.com.br/display/tec/@+...+FOLDER
/*/

User Function Folder1()
Local oDlg     
Local oFolder
	
DEFINE MsDialog oDlg TITLE "Exemplo de FOLDER" FROM 0,0 TO 600,800 PIXEL

@ 10,15 FOLDER oFolder PROMPTS 'Aba 01','Aba 02' SIZE 260, 200 OF oDlg  PIXEL

@ 10,10 SAY "Texto na Aba 01" OF oFolder:aDialogs[1] PIXEL
@ 10,10 SAY "Texto na Aba 02" OF oFolder:aDialogs[2] PIXEL

ACTIVATE MsDialog oDlg CENTER 

Return

User Function Folder2()
Local oDlg     
Local oFolder
	
DEFINE MsDialog oDlg TITLE "Exemplo de ADD FOLDER" FROM 0,0 TO 600,800 PIXEL

@ 10,15 FOLDER oFolder SIZE 260, 200 OF oDlg  PIXEL

oFolder:AddItem("Aba 01",.T.)
oFolder:AddItem("Aba 02",.T.)

@ 10,10 SAY "Texto na Aba 01" OF oFolder:aDialogs[1] PIXEL
@ 10,10 SAY "Texto na Aba 02" OF oFolder:aDialogs[2] PIXEL
        
oFolder:SetOption(1)

ACTIVATE MsDialog oDlg CENTER 

Return

