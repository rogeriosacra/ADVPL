# include "parmtype.ch"
# iNCLUDE "PROTHEUS.CH"



//PASSAGEM DE PARÂMETR0S - EXEMPLOS

User Function PasPar1()

Local nNumero1    := 0
Local nNumero2    := 0
Local nInformados := 0
Local nTotal      := 0
	


MsgInfo("Rotina **Soma doi números** !")
MsgInfo("Digite dois números para que sejam somados!!!")


While nInformados < 2
    nNumero1:= Val(FwInputBox("Informe o primeiro número a ser somado.Caso queira cancelar, digite a letra 'C'", ""))
           
         If nNumero1 == "C"  
              MSGAlert("Foi digitada a letra"+CvalToChar(nNumero1)+",operação cancelada pelo usuário!")
              Return         
         EndIf
			
         WHILE ValType(nNumero1) <> "N"
               nNumero1 := 0          
			   	MSGAlert("O valor inválido:"+CvalToChar(nNumero1)+", por favor digitar dado numérico! ")                 
         EndDO

			nInformados++

         nNumero2:= Val(FwInputBox("Informe o segundo número a ser somado.Caso queira cancelar, digite a letra 'C'", ""))

         If nNumero2 == "C"  
            MSGAlert("Foi digitada a letra"+CvalToChar(nNumero2)+",operação cancelada pelo usuário!")
            Return
         EndIf           

         While ValType(nNUmero2) <> "N"
               nNumero2 := 0          
			   	MSGAlert("O valor inválido:"+CvalToChar(nNumero)+", por favor digitar dado numérico! ")               
         EndDo      

         nInformados++     
         nTotal := Soma(nNumero1, nNUmero2)

         MsgInfo("A soma dos valores digitados é = "+CvalToChar(nTotal))
END DO

Return

//FUNÇÃO PARA SOMAR OS VALORES DIGITADOS 

Static Function Soma(nVal1, nVal2)

Local nVal1 := 0
Local nVal2 := 0
Local nTotal1 := 0

nTotal1 := nVal1 + nVal2

Return(nTotal)


