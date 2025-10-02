User Function ParamBox()
Local aPergs	:= {}
Local cCodRec	:= space(08)
Local cRecDest	:= space(08)   
Local aRet		:= {}

aAdd( aPergs ,{1,"Recurso De: "		,cCodRec	,"@"	,'.F.'				,,'.F.',40,.F.})
aAdd( aPergs ,{1,"Recurso Para: "	,cRecDest	,"@!"	,'!Empty(mv_par02)'	,,'.T.',40,.T.})

If ParamBox(aPergs ,"Substitui recurso",aRet)
	MsgAlert("Recurso original: " + aRet[1] + " substituido pelo recurso:" + aRet[2],"Exemplo do ParamBox" )
Else
	MsgAlert("Processo cancelado","Exemplo do ParamBox")
EndIf

Return .T.

