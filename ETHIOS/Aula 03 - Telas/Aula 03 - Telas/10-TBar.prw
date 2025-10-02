#Include "TOTVS.CH"

/*/{Protheus.doc} U_TBar
    @type		Function
    @author		Milton J.dos Santos
    @since		01/03/2020
    @version	1.0.0
    @param		Nenhum
    @return		Vazio (nil)
    @example    Exemplo da utilizacao de TBar 
    @see		https://tdn.totvs.com/display/tec/TBar
/*/

User Function TBar()

DEFINE MsDialog oDlg TITLE "Exemplo TBar" FROM 180, 180 TO 550, 700 PIXEL

oTBar := TBar():New( oDlg, 25, 32, .T.,,,, .F. )

oTBtnBmp1 := TBtnBmp2():New( 00, 00, 35, 25, 'copyuser',,,, { || Alert( 'TBtnBmp1' ) }, oTBar, 'msGetEx',, .F., .F. )
oTBtnBmp2 := TBtnBmp2():New( 00, 00, 35, 25, 'critica',,,, { || }, oTBar, 'Critica',, .F., .F. )
oTBtnBmp3 := TBtnBmp2():New( 00, 00, 35, 25, 'bmpcpo',,,, { || }, oTBar, 'PCO',, .F., .F. )
oTBtnBmp4 := TBtnBmp2():New( 00, 00, 35, 25, 'preco',,,, { || }, oTBar, 'Preço',, .F., .F. )

ACTIVATE MsDialog oDlg CENTERED

Return
