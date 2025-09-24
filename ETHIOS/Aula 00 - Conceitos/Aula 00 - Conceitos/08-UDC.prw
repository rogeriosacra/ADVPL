#Include "TOTVS.CH"

/*

   Programa.: UDC.PRW
   Funcao...: U_UDC
   Autor....: Milton J.dos Santos
   Data.....: 01/01/2020
   Descricao: Teste de Comandos Definidos pelo Usuario.

   UDC = User Defined Commands (Comandos definidos pelo usuario)

   Mais informações: https://tdn.totvs.com/display/tec/AdvPL+-+Compiler+Directives

*/


//  Sem o uso de constantes #define.

User Function UDC()

Local i
Local aArray := {{"Joao",25,.T.,"4567-9876",2}, {"Maria",30,.F.,"9517-6541",0}, {"Jose",18,.T.,"6348-7537",3}}

For i := 1 To Len(aArray)

    MsgAlert(aArray[i, 1])
    MsgAlert(aArray[i, 4])
    MsgAlert(aArray[i, 2])
    MsgAlert(aArray[i, 3])
    MsgAlert(aArray[i, 5])

Next

Return

// A mesma rotina, mas com o uso de UDC ( constantes #define ), interagindo com a execução da rotina.

#define __NOME     1
#define __IDADE    2
#define __ESTCIVIL 3
#define __FONE     4
#define __NRDEPEND 5

User Function TstUDC2()

Local i
Local aArray := {{"Joao",25,.T.,"4567-9876",2}, {"Maria",30,.F.,"9517-6541",0}, {"Jose",18,.T.,"6348-7537",3}}

For i := 1 To Len(aArray)

    MsgAlert(aArray[i, __NOME    ])
    MsgAlert(aArray[i, __FONE    ])
    MsgAlert(aArray[i, __IDADE   ])
    MsgAlert(aArray[i, __ESTCIVIL])
    MsgAlert(aArray[i, __NRDEPEND])

Next

Return

// Outra rotina usando UDC, usando constante #define porém interagindo na compilação

#define BRASIL

User Function TstUDC3()

#IfDef BRASIL
   Local cPais
   Local cLingua
   cPais   := "Brasil"
   cLingua := "Portugues"
 #Else
   Local cPais
   cPais := "Argentina"
#EndIf

MsgAlert(cPais + "/" + cLingua)

Return Nil 
