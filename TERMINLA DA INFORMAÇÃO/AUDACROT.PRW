#Include 'Protheus.ch'
#Include 'Parmtype.ch'
#Include 'Totvs.ch'

/*P.E.: AFTERLOGIN
DESC.: FUN��O CHAMADA A CADA LOGIN DE USUARIO E A CADA ABA NO SIGAMDI
LINKS.: TDN.TOTVS.COM/PAGES/RELEASEVIEW.ACTION?PAGEID=6815186
ROBERTO MENDES
*/

User Function afterlogin()//n�o funciona na entrada pelo sigamdi apenas quando troca de m�dulo

FatuAudit()

Return

//**************************
Static Function FatuAudit()
//**************************

Reclock("ZZ9",.T.)

ZZ9_FILIAL := cFilAnt
ZZ9_USER   := cUserName
ZZ9_COMP   := GetComputerName()
ZZ9_DACESS := Date()
ZZ9_HACESS := TIME()
ZZ9_ROTINA := omainwnd:ccaption 
ZZ9_IP     := GetClientiP(.T.)
ZZ9->(MsUnlock())

Return


