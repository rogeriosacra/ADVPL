 //Chamada de Funcoes no Protheus12 - Pois o Formulas nao funciona no Protheus12
//--- incluir tratamento para verificar se a funcao existe no APO --->Findfunction( < cFuncao > )
User function IM_XFUNC()
    Local sFunc
    Local sRet
    Local Enter:=chr(13)+chr(10)
    sFunc:= FWInputBox("Macroexecução - Digite o nome da Funçao"+enter+"[Ex: U_FUNC(y,x)]","")
    sRet:= &(sFunc)
    aviso("Atenção","Foi executada a função:"+chr(13)+chr(10)+sFunc,{"ok"})
    /*
    Local iCount
    Local nTot := 500
    Local clPerg    := "IM_CSTPA"
    IF !Pergunte(clPerg,.T.,"Geração Planilha de Custo")
    Return .T.
    ENDIF
    Processa( {|| XXX() }, "Aguarde...", "Carregando definição dos campos...",.F.)
    msgalert("fim")     
    */     
Return .t.



