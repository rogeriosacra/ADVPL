

#include "totvs.ch" //substitui o fivewin.ch
#include "fileio.ch" //Classe para geracao do TXT
#include "topconn.ch"


///Chamada de Funcoes no Protheus12 - Pois o Formulas nao funciona no Protheus12
//--- incluir tratamento para verificar se a funcao existe no APO --->Findfunction( < cFuncao > )
User function IM_XFUNC()
    Local sFunc
    Local sRet
    Local Enter:=chr(13)+chr(10)
    sFunc:= FWInputBox("Macroexecu��o - Digite o nome da Fun�ao"+enter+"[Ex: U_FUNC(y,x)]","")
    sRet:= &(sFunc)
    aviso("Aten��o","Foi executada a fun��o:"+chr(13)+chr(10)+sFunc,{"ok"})
   
Return .t.



