#Include "totvs.ch"

/*/ {Protheus.doc} User Function MessageBox
    (Exemplos de funcoes de alerta)
    @type		Function
    @author		Milton J.dos Santos
    @since		01/03/2020
    @version	1.0.0
    @param		Nenhum
    @return		Vazio (nil)
    @example    (examples)
    @see        (https://tdn.totvs.com/display/tec/MessageBox)
/*/

// A função MSGBOX foi descontinuada, em seu lugar entrou a MessageBox
// https://centraldeatendimento.totvs.com/hc/pt-br/articles/360018231932-Cross-Segmentos-TOTVS-Backoffice-Linha-Protheus-ADVPL-Fun%C3%A7%C3%A3o-msgbox

// Opções do MessageBox
#define MB_OK                       0
#define MB_OKCANCEL                 1
#define MB_YESNO                    4
#define MB_ICONHAND                 16
#define MB_ICONQUESTION             32
#define MB_ICONEXCLAMATION          48
#define MB_ICONASTERISK             64
  
// Retornos possíveis do MessageBox
#define IDOK			    1
#define IDCANCEL		    2
#define IDYES			    6
#define IDNO			    7
  

User Function MessageBox()
  // Executa os MessageBox e aguarda os valores de retorno
  nRet1 := MessageBox("MB_OK","",MB_OK)
  nRet2 := MessageBox("MB_OKCANCEL","",MB_OKCANCEL)
  nRet3 := MessageBox("MB_YESNO","",MB_YESNO)
  nRet4 := MessageBox("MB_ICONHAND","",MB_ICONHAND)
  nRet5 := MessageBox("MB_ICONQUESTION","",MB_ICONQUESTION)
  nRet6 := MessageBox("MB_ICONEXCLAMATION","",MB_ICONEXCLAMATION)
  nRet7 := MessageBox("MB_ICONASTERISK","",MB_ICONASTERISK)
Return
