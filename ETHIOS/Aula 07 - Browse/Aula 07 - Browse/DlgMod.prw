#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWBROWSE.CH"

/*/{Protheus.doc} U_DlgMod
    @type		Function
    @author		Milton J.dos Santos
    @since		01/03/2020
    @version	1.0.0
    @param		Nenhum
    @return		Vazio (nil)
    @example    Exemplo da utilizacao do FWDialogModal
    @see		https://tdn.totvs.com/display/framework/FwDialogModal
/*/

User Function DlgMod()
Local oModal
Local oContainer
 
 
    oModal  := FWDialogModal():New()       
    oModal:SetEscClose(.T.)
    oModal:setTitle("Ti­tulo da Janela ")
    oModal:setSubTitle("SubTitulo da Janela")
     
    //Seta a largura e altura da janela em pixel
    oModal:setSize(200, 140)
 
    oModal:createDialog()
    oModal:addCloseButton(nil, "Fechar")
    oContainer := TPanel():New( ,,, oModal:getPanelMain() )
    oContainer:SetCss("TPanel{background-color : red;}")
    oContainer:Align := CONTROL_ALIGN_ALLCLIENT
     
    TSay():New(1,1,{|| "Teste "},oContainer,,,,,,.T.,,,30,20,,,,,,.T.)
         
    oModal:Activate()
Return
