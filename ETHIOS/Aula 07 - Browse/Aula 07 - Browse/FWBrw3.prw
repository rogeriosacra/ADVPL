#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWBROWSE.CH"

/*/{Protheus.doc} U_FWBrw3
    @type		Function
    @author		Milton J.dos Santos
    @since		01/03/2020
    @version	1.0.0
    @param		Nenhum
    @return		Vazio (nil)
    @example    Exemplo da utilizacao do FWMBrowse, cria um objeto do tipo grid, botões laterais e detalhes das
				colunas baseado no dicionário de dados
    @see		https://tdn.totvs.com/pages/releaseview.action?pageId=62390842
/*/

User Function FWBrw3() 

Local aArea				 := GetArea()
Local oDlg         		 := Nil
Local oMarkBrow   		 := Nil
Local bInitBr			 := Nil
Local bSetFech  		 := Nil
Local bSetConf  		 := Nil
Local cAliasQry   		 := ""
Local aCampos            := ""
Local cArqTmp            := ""  
Local cFiltro			 := ""
Local cEntidad    		 := 'SA1'
Local nI 				 := 0
Local aColumns 			 := {}      
Local aButtons 			 := {}   
Local aLista 			 := {} 
Local lConfirm  		 := .F.      
Local lRet				 := .T.
Local cConcat	  		 := IIF(Trim(Upper(TcGetDb())) $ "ORACLE,POSTGRES,DB2,INFORMIX","||","+")
Local cQuery			 := ""
Local cTempKey			 := ""
Local aKey				 := {}

Local nTam				 := 0
Local nX				 := 0		

Private cMark			 := GetMark()  

If Empty( cEntidad ) 
	lRet := .F.     
	Help( " ", 1, "TK061CKENT" )//"Para adicionar membros ?lista ?necess?io selecionar uma entidade." ## "Clique no bot? "Entidade" para selecionar uma entidade."
EndIf

If lRet
	cAliasQry   		 := GetNextAlias() 
	aDados      		 := Campos( cEntidad )
	aStruct     		 := aDados[1]       
	aCampos     		 := aDados[2]
	cCpoQry     		 := aDados[3]
	cTempTab    		 := GetNextAlias()  
	
//	cFiltro := AllTrim( "A1_MSBLQL <> '1'" )

	If cEntidad == "SA1" //Clientes  
		
		cQuery := " SELECT '  ' MARK, " + cCpoQry
		cQuery += " FROM " + RetSqlName("SA1") + " SA1 "
		cQuery += " WHERE SA1.D_E_L_E_T_ = ' ' "

	EndIf

	DBUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasQry, .T., .T. ) 
	
	For nX := 1 To Len(aStruct)
		If ( aStruct[nX][2] <> "C" )
			TcSetField(cAliasQry,aStruct[nX][1],aStruct[nX][2],aStruct[nX][3],aStruct[nX][4])
		EndIf
	Next nX

	//-------------------------------------------------------------------
	// Instancia tabela temporaia.  
	//-------------------------------------------------------------------

	oTempTable	:= FWTemporaryTable():New( cTempTab )

	aAdd( aStruct, {})
	aIns(aStruct,1)
	aStruct[1] := {"MARK","C",2,0}

	//-------------------------------------------------------------------
	// Atribui os Indices
	//-------------------------------------------------------------------
	oTempTable:SetFields( aStruct )
	cTempKey    := ( cEntidad )->( IndexKey() )
	
	cTempKey	:= SubStr( cTempKey, At( "+", cTempKey ) + 1, Len( cTempKey ) )
	aKey 		:= StrTokArr( cTempKey, ",-+" )

	oTempTable:AddIndex("1",aKey)
	
	//------------------
	//Criacao da tabela
	//------------------
	oTempTable:Create()  
	
	DbSelectArea(cAliasQry)
	
	nTam 		:= Len(aStruct)
	
	While !(cAliasQry)->(Eof()) 
		RecLock( cTempTab,.T. )
		For nX := 1 to nTam 
			(cTempTab)->(FieldPut(nX,(cAliasQry)->(FieldGet(nX))))
		Next nX	 	
		(cTempTab)->(MsUnLock()) 	 	 
		(cAliasQry)->(DbSkip())		 	
	EndDo
	
	If ( Select( cAliasQry ) > 0 )
	       DbSelectArea( cAliasQry )
	       DbCloseArea()
	EndIf

	DbSelectArea(cTempTab)                                                          
	cFiltro := CRMXFilEnt( cEntidad, .T. ) 
	
	For nI := 1 To Len( aCampos )
	       AAdd( aColumns, FWBrwColumn():New() )
	       aColumns[nI]:SetType(aCampos[nI][3] )
		  //----------------------------------
		  // Tratamento para ComboBox
	   	  //----------------------------------
	       If Empty( aCampos[nI][6] )  
	             aColumns[nI]:SetData( &( "{|| " + aCampos[nI][1] + " }" ) )
	       Else
	             aColumns[nI]:SetData( &( "{|| X3Combo( "+"'"+aCampos[nI][1]+"',"+aCampos[nI][1]+" ) }" ) )   
	       EndIf
	       aColumns[nI]:SetTitle( aCampos[nI][2] )
	       aColumns[nI]:SetSize( aCampos[nI][4] )
	       aColumns[nI]:SetDecimal( aCampos[nI][5] )
	Next nI
	              
	DEFINE DIALOG oDlg TITLE "Cadastro de Clientes" FROM 0,0 TO 500,800 PIXEL
	
	       oMarkBrow:= FWBrowse():New()
	       oMarkBrow:SetDescription( "Cadastro de Cliente" ) 

		   // Cria uma coluna de marca/desmarca
	       oMarkBrow:AddMarkColumns( { ||Iif( !Empty( (cTempTab)->MARK ),"LBOK","LBNO" ) },{ || Mark( oMarkBrow ) }, { || MarkAll( oMarkBrow ), oMarkBrow:Refresh() } )            															             

	       oMarkBrow:SetDataQuery( .F. )
	       oMarkBrow:SetDataTable( .T. )                                           
	       oMarkBrow:SetAlias( cTempTab )
	       oMarkBrow:SetColumns( aColumns )
	       oMarkBrow:SetDBFFilter()
	       oMarkBrow:SetUseFilter()
	       oMarkBrow:SetOwner( oDlg )
	       oMarkBrow:Activate()                            
	             
			// Bloco a ser executado ao "Confirmar" a tela -> <CTRL+O>
			bSetConf := { || lConfirm := .T., GetKeys(), SetKey( VK_F3, Nil ), aLista := Tk61MarkOk( oMarkBrow, cEntidad ), Tk61EntGet( aLista ), oDlg:End() }
			
			// Bloco a ser executado ao "Finalizar" a tela -> <CTRL+X>
			bSetFech := { || lConfirm := .F. ,GetKeys(), SetKey( VK_F3, Nil ), oDlg:End() }  
			
		    // Habilitacao da EnchoiceBar
			bInitBr  := { || EnchoiceBar( oDlg, bSetConf, bSetFech, Nil ) }
			oDlg:bInit := bInitBr
	          
	ACTIVATE DIALOG oDlg CENTERED     
	
	If( Valtype(oTempTable) == "O")
		oTempTable:Delete()
		FreeObj(oTempTable)
		oTempTable := nil
	EndIf
		
	RestArea( aArea )

EndIf
       
Return( Nil )    

Static Function Campos( cEntidad )

Local aArea       := GetArea()
Local aCampos     := {}
Local aStruct	  := {}
Local cCampo      := ""
Local cCpoQry 	  := ""

DbSelectArea( "SX3" )
DbSetOrder( 1 )

If Dbseek( cEntidad )

       While !SX3->( Eof() ) .AND. SX3->X3_ARQUIVO == cEntidad
             cCampo := AllTrim( SX3->X3_CAMPO )
             If ( X3USO( SX3->X3_USADO ) .AND. SX3->X3_CONTEXT <> "V" .AND. SX3->X3_TIPO <> "M") 
                    AAdd( aCampos,{ cCampo, X3Titulo(),SX3->X3_TIPO, SX3->X3_TAMANHO, SX3->X3_DECIMAL,X3CBox() } )
                    AAdd( aStruct,{ cCampo,SX3->X3_TIPO, SX3->X3_TAMANHO, SX3->X3_DECIMAL } )
                    cCpoQry += cCampo+", "
             EndIf
             SX3->( DbSkip() )
       End
       cCpoQry := AllTrim( Padr( cCpoQry, Len( cCpoQry ) -2 ) )   
EndIf

RestArea( aArea )

Return( { aStruct, aCampos, cCpoQry } ) 

Static Function Mark( oMarkBrow )
Local cAliasTmp := (cTempTab)

RecLock( cAliasTmp,.F. )
If Empty( ( cAliasTmp )->MARK )
       ( cAliasTmp )->MARK := cMark
Else
       ( cAliasTmp )->MARK := "" 
EndIf 
MsUnLock()

Return( Nil ) 

Static Function MarkAll( oMarkBrow )

Local aArea 	 := GetArea()
Local cAlias 	 := (cTempTab) 
Local aAreaAlias := ( cAlias )->( GetArea() )     
Local lMarca	 := .F.
  
( cAlias )->( DbGoTop() )
 lMarca := ( cAlias )->MARK <> cMark
 
 While ( cAlias )->( !EOF() )

  RecLock( cAlias, .F. )   

  	( cAlias )->MARK := Iif( lMarca, cMark, "" )                      
 
  ( cAlias )->( MsUnlock() )
  ( cAlias )->( DbSkip() )                
  
EndDo

RestArea( aAreaAlias ) 
RestArea( aArea )

Return( Nil )
