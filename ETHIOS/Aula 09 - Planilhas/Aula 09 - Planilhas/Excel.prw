#include 'protheus.ch'
#include 'parmtype.ch'

Private oExcel := FWMSEXCEL():New()

User Function Excel()

	Local aHeader := {"Codigo","Descricao"}
	Local aColunas:= ({ {"0001","laranja"}	,;
						{"0002","rosa"}		,;
						{"0003","verde"}	,;
						{"0004","azul"}		,;
						{"0005","preto"} })
	

	Pasta("Tabelas","Tabelas", aHeader,aColunas)


Return

Static Function Pasta( cPar1, cPar2, aPar3, aPar4 )

	
	oExcel:AddworkSheet( cPar1 )
	oExcel:AddTable (cPar1,cPar2)

	For i := 1 to Len( aPar3 )
		oExcel:AddColumn(cPar1,cPar2,aPar3[i],1,1)
	Next
	
	For i := 1 to Len( aPar4 )
		oExcel:AddRow(cPar1,cPar2,aPar4[i])
	Next

Return