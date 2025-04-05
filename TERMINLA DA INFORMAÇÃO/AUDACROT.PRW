/*P.E.: AFTERLOGIN
DESC.: FUNÇÃO CHAMADA A CADA LOGIN DE USUARIO E A CADA ABA NO SIGAMDI
LINKS.: TDN.TOTVS.COM/PAGES/RELEASEVIEW.ACTION?PAGEID=6815186
ROBERTO MENDES
*/

User Function afterlogin()//não funciona na entrada pelo sigamdi apenas quando troca de módulo

FatuAudit()

Return

//**************************
Static Function FatuAudit()
//**************************

Reclock("ZZ9",.T.)

ZZ9_FILIAL := cFilAnt
ZZ9_USER   := cUserName
ZZ9_COMP   := ComputerName()
ZZ9_DACESS := Date()
ZZ9_HACESS := TIME()
ZZ9_ROTINA := omainwnd:ccaption
ZZ9_IP     := GetClientiP(.T.)
ZZ9->(MsUnlock())

Return


