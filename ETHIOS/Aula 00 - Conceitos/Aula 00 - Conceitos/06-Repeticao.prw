#Include "TOTVS.CH"

/*
 
   Programa.: Repeticao.PRW
   Autor....: Milton J.dos Santos
   Data.....: 01/01/2020
   Descricao: Exemplo de estrutura de repeticao

   Esta estrutura sao chamadas de "Lacos de repeticao"

   Funcao...: Exemplo FOR  : U_FOR1,U_FOR2,U_FOR3,U_FOR4
              Exemplo WHILE: U_WHILE1,U_WHILE2

*/

/*/
    Exemplo de FOR mostrando um alerta
/*/

User Function For1()

Local i

For i := 1 To 10
    MsgAlert(i)
Next

Return

/*/
    Exemplo de FOR contando de 2 em 2, forcando a saida da repeticao
/*/

User Function For2()

Local i
Local nIni, nFim

nIni := 100
nFim := 120

For i := nIni To nFim Step 2
    MsgAlert(i)
    If i > 110
       Exit      // Break tambem encerra.
    EndIf
Next

Return

/*/
    Exemplo de FOR contagem regressiva mostrando mensagem
/*/

User Function For3()

Local i
Local nIni, nFim

nIni := 1
nFim := 10

For i := nFim To nIni Step -1
    MsgAlert(i)
Next

Return

/*/
    Exemplo de FOR em cascata 
/*/

User Function For4()
Local i
Local j

For i := 20 To 25
    MsgAlert("i=" + Str(i))
    For j := 1 To 5
        MsgAlert("i=" + Str(i) + "   j=" + Str(j))
    Next
Next

Return

/*
    While permite repetir de forma condicional
*/

User Function While1()
Local nCnt := 1

Do While nCnt <= 10

   nCnt := nCnt * nCnt
   nCnt++

Enddo

MsgAlert(nCnt)

Return

/*
    A mesma funcao tambem pode ser escrita d a seguinte forma 

*/

User Function While2()
Local nCnt := 1

While nCnt <= 10

   nCnt := nCnt * nCnt
   nCnt++

End

MsgAlert(nCnt)

Return
