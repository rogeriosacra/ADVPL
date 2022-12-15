#Include 'Protheus.ch'
#Include 'Totvs.ch'

User Function PadrEx()

cTeste1 := PadR("teste1", 100)
cTeste2 := Padl("teste2",10)

MsgInfo(cTeste1, )
MsgInfo(cTeste2, )


Return
 /*Em PadR a string informada em "Express�o" (informada no 1� par�metro) ser� alinhada � esquerda, e o "Caractere" (informado no 3� par�metro) ir� complementar a string � direita at� o seu "Comprimento" (informado no 2� par�metro).

Em PadL � exatamente o contr�rio, ou seja, alinha a "Express�o" � direita, e acrescenta caracteres � esquerda.

Logo:

PadR acrescenta caracteres � direita (Right) da express�o informada; e

PadL acrescenta caracteres � esquerda (Left) da express�o informada.

Se "Caractere" n�o for informado ser�o acrescentados espa�os em branco.

Exemplo:

Padr("Teste",10)
"Teste     "

PadL("Teste",10)
"     Teste"





 */
