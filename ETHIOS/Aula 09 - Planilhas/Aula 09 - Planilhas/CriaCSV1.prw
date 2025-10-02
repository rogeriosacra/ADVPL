#INCLUDE "TOTVS.CH"

#DEFINE ENTER CHR(13)+CHR(10)

/*/ {Protheus.doc} User Function CriaCSV1
    (Exemplos de funcoes para criar CSV )
    @type  Function
    @author Milton J.dos Santos
    @since 01/03/2020
    @version 1.0.0
    @param Nenhum
    @return Vazio (nil)
    @example
    (examples)
    @see 
/*/

User Function CriaCSV1() 
Local cTexto	:= ""
Local aTexto	:= {}
Local cArquivo	:= "C:\TEMP\CriaCSV1.CSV"
Local cDivisor	:= ";"

aAdd( aTexto, { "NOME1","TITULO1","ARQUIVO1","PERGUNTE1" })
aAdd( aTexto, { "NOME2","TITULO2","ARQUIVO2","PERGUNTE2" })
aAdd( aTexto, { "NOME3","TITULO3","ARQUIVO3","PERGUNTE3" })
aAdd( aTexto, { "NOME4","TITULO4","ARQUIVO4","PERGUNTE4" })

cTexto := PADR("NOME",5) + cDivisor + PADR("TITULO",7) + cDivisor + PADR("ARQUIVO",8) + cDivisor + PADR("PERGUNTE",9) + ENTER
For nCount := 1 TO Len( aTEXTO )
	cTexto += PADR(aTEXTO[ nCount,1],5 ) + cDivisor + PADR(aTEXTO[ nCount,2],7) + cDivisor + PADR(aTEXTO[ nCount,3],8) + cDivisor + PADR(aTEXTO[ nCount,4],9)+ ENTER
Next

MemoWrite(cArquivo,cTexto)

Return
