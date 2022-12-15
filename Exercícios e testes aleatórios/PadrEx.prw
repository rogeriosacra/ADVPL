#Include 'Protheus.ch'
#Include 'Totvs.ch'

User Function PadrEx()

cTeste1 := PadR("teste1", 100)
cTeste2 := Padl("teste2",10)

MsgInfo(cTeste1, )
MsgInfo(cTeste2, )


Return
 /*Em PadR a string informada em "Expressão" (informada no 1º parâmetro) será alinhada à esquerda, e o "Caractere" (informado no 3º parâmetro) irá complementar a string à direita até o seu "Comprimento" (informado no 2º parâmetro).

Em PadL é exatamente o contrário, ou seja, alinha a "Expressão" à direita, e acrescenta caracteres à esquerda.

Logo:

PadR acrescenta caracteres à direita (Right) da expressão informada; e

PadL acrescenta caracteres à esquerda (Left) da expressão informada.

Se "Caractere" não for informado serão acrescentados espaços em branco.

Exemplo:

Padr("Teste",10)
"Teste     "

PadL("Teste",10)
"     Teste"





 */
