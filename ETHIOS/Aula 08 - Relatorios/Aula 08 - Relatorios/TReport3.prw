#Include "TOTVS.ch"
#INCLUDE "TBICONN.CH"


/*/ {Protheus.doc} TReport3

	Impressão de relatório

    (Exemplos de funcoes de relatorio TREPORT)
	
    @type		Function
    @author		Milton J.dos Santos
    @since		01/03/2020
    @version	1.0.0
    @param		Nenhum
    @return		Vazio (nil)
    @example    (Examplos)
    @see (https://tdn.totvs.com/pages/)
	
/*/

User Function TReport3()

SLDBRSX1()

oReport := ReportDef()

If Valtype( oReport ) == 'O'
	If ! Empty( oReport:uParam )
		Pergunte( oReport:uParam, .F. )
	EndIf	
	
	oReport:PrintDialog()      
Endif
	
oReport := Nil

RETURN

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportDef		º Autor ³ MILTON J.DOS SANTOSº Data ³   01/01/21  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio ReportDef                                            º±±
±±º          ³                                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RELATORIO DE CONTRATOS DE CARRETEIRO EMITIDOS			      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()
local aArea	   		:= GetArea()   
Local CREPORT		:= "R9RTMS05"
Local CTITULO		:= "CONTRATOS CARRETEIRO EMITIDOS"
Local CDESC			:= "Este programa tem como objetivo imprimir relatorio de CONTRATOS CARRETEIRO EMITIDOS"
Local cPerg	   		:= "R90TMS05" 

Pergunte( cPerg , .T. )                   

oReport	:= TReport():New( cReport,Capital(CTITULO),CPERG, { |oReport| Pergunte(cPerg , .F. ), If(! ReportPrint( oReport ), oReport:CancelPrint(), .T. ) }, CDESC ) 
oReport:ParamReadOnly()

oReport:SetLandScape(.T.)

oSection1  := TRSection():New( oReport, "DOCUMENTOS EMBARCADOS", {"DTY","DA3"},, .F., .F. )

TRCell():New( oSection1, "COL001"	,,"FILIAL"/*Titulo*/	,/*Picture*/, tamsx3("Z01_CDFR90")	[01]/*Tamanho*/, /*lPixel*/, /*CodeBlock*/  )
TRCell():New( oSection1, "COL002"	,,"CONTRATO"/*Titulo*/	,/*Picture*/, tamsx3("DTY_NUMCTC")	[01]/*Tamanho*/, /*lPixel*/, /*CodeBlock*/  )
TRCell():New( oSection1, "COL003"	,,"EMISSAO"/*Titulo*/	,/*Picture*/, tamsx3("DTY_DATCTC")	[01]/*Tamanho*/, /*lPixel*/, /*CodeBlock*/  )
TRCell():New( oSection1, "COL004"	,,"VEÍCULO"/*Titulo*/	,/*Picture*/, tamsx3("DTY_CODVEI")	[01]/*Tamanho*/, /*lPixel*/, /*CodeBlock*/  )
TRCell():New( oSection1, "COL005"	,,"FRETE"/*Titulo*/		,/*Picture*/, tamsx3("DTY_VALFRE")	[01]/*Tamanho*/, /*lPixel*/, /*CodeBlock*/  )
TRCell():New( oSection1, "COL006"	,,"IRRF"/*Titulo*/		,/*Picture*/, tamsx3("DTY_IRRF")	[01]/*Tamanho*/, /*lPixel*/, /*CodeBlock*/  )
TRCell():New( oSection1, "COL007"	,,"SEST"/*Titulo*/		,/*Picture*/, tamsx3("DTY_SEST")	[01]/*Tamanho*/, /*lPixel*/, /*CodeBlock*/  )
TRCell():New( oSection1, "COL008"	,,"INSS"/*Titulo*/		,/*Picture*/, tamsx3("DTY_INSS")	[01]/*Tamanho*/, /*lPixel*/, /*CodeBlock*/  )
TRCell():New( oSection1, "COL009"	,,"FROTA"/*Titulo*/		,/*Picture*/, tamsx3("DA3_FROVEI")	[01]/*Tamanho*/, /*lPixel*/, /*CodeBlock*/  )
TRCell():New( oSection1, "COL010"	,,"TIPO"/*Titulo*/		,/*Picture*/, tamsx3("DTY_TIPCTC")	[01]/*Tamanho*/, /*lPixel*/, /*CodeBlock*/  )

oSection1:SetTotalText('')

Return( oReport )


STATIC Function ReportPrint( oReport )  

Local oSection1 	:= oReport:Section(1) 
Local oMeter
Local oText
Local oDlg
Local oBreak
Local lImpPaisgm	:= .T.	
Local Tamanho		:= "G"
Local cFilUser		:= ""
Local cPed          := ""
Local lSection1		:= .T.
Local nCont := 1

// Gera arquivo temporario
MsgMeter({|	oMeter, oText, oDlg, lEnd | ; 
					RUNQUERY()},;
					"Criando Arquivo Temporário...")  				
  
oSection1:Init()
//processa o relatorio
CR001->(dbGoTop())
While CR001->(! EOF())

		//oSection1:SetPageBreak(.T.)
		oSection1:Cell("COL001"):SetBlock( {|| CR001->Z01_CDFR90 	} ) 
		oSection1:Cell("COL002"):SetBlock( {|| CR001->DTY_NUMCTC 	} ) 
		oSection1:Cell("COL003"):SetBlock( {|| CR001->EMISSAO		} ) 
		oSection1:Cell("COL004"):SetBlock( {|| CR001->DTY_CODVEI	} ) 
		oSection1:Cell("COL005"):SetBlock( {|| CR001->DTY_VALFRE 	} ) 
		oSection1:Cell("COL006"):SetBlock( {|| CR001->DTY_IRRF	 	} )
		oSection1:Cell("COL007"):SetBlock( {|| CR001->DTY_SEST	 	} )
		oSection1:Cell("COL008"):SetBlock( {|| CR001->DTY_INSS	 	} )		
		oSection1:Cell("COL009"):SetBlock( {|| CR001->DA3_FROVEI 	} ) 
		oSection1:Cell("COL010"):SetBlock( {|| CR001->DTY_TIPCTC 	} )

		oSection1:PrintLine()

   	CR001->(dbSkip())

EndDo                
oSection1:Finish()

dbSelectArea("CR001")
Set Filter To
dbCloseArea()
If Select("CR001") == 0
//	FErase(TRB_001+GetDBExtension())
//	FErase(TRB_001+OrdBagExt())
EndIF	

Return .T.

STATIC FUNCTION RUNQUERY()

Local cQuery 		:= ""
local cArq          := "CR001"

#IFDEF TOP
	
cQuery := " SELECT DISTINCT	Z01_CDFR90, DTY_NUMCTC, CONVERT(CHAR,convert(datetime, DTY_DATCTC),103) AS EMISSAO,DTY_CODVEI,DTY_VALFRE,DTY_IRRF, DTY_SEST, DTY_INSS, DA3_FROVEI,DTY_TIPCTC FROM DTY010	DTY (NOLOCK)"
cQuery += "	INNER JOIN DA3010 DA3 (NOLOCK) ON	DA3_FILIAL	=	''	AND DA3_COD		=	DTY_CODVEI	AND	DA3.D_E_L_E_T_	=	''"
cQuery += "	INNER JOIN Z01010 Z01 (NOLOCK) ON	Z01_FILTM6	=	DTY_FILORI AND Z01_CDFR90 IN	('SAO','SBC','BHZ','PAV','BSB','GYN','MIN','SUM','VIX','PEN','GRA','SSA','REC','MAU','STC','PET','ETM','MOG','PLN','GRU') AND Z01.D_E_L_E_T_ = ''"
cQuery += "	WHERE DTY_DATCTC BETWEEN '"+DTOS(MV_PAR01)+"'	AND '"+DTOS(MV_PAR02)+"'	AND	DTY.D_E_L_E_T_ = ''	AND DA3_FROVEI IN ('2', '3') AND DTY_TIPCTC IN ('1','5')"

	
	cQuery := ChangeQuery(cQuery)
	
	
	If Select("CR001") > 0
		dbSelectArea("CR001")
		dbCloseArea()
	Endif
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"CR001",.T.,.F.)
	
#ENDIF
  
dbSelectArea("CR001")
CR001->(dbGoTop())

Return 

STATIC Function SLDBRSX1()

Local aSaveArea 	:= GetArea()
Local aPergs		:= {}
Local aHelpPor		:= {}
Local aHelpEng		:= {}
Local aHelpSpa		:= {}

aHelpPor	:= {} 
aHelpEng	:= {}	
aHelpSpa	:= {}

Aadd(aPergs,{"EMISSAO DE :?","EMISSAO DE :?","EMISSAO DE:?","mv_ch1","D",8,0,0,"G",,"mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","S","",aHelpPor,aHelpEng,aHelpSpa})
Aadd(aPergs,{"EMISSAO ATE:?","EMISSAO ATE:?","EMISSAO ATE:?","mv_ch2","D",8,0,0,"G",,"mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","S","",aHelpPor,aHelpEng,aHelpSpa})
    
AjustaSx1("R90TMS05",aPergs)   
           
RestArea(aSaveArea)

Return      
 