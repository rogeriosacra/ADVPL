#Include 'Protheus.ch'
#Include 'Totvs.ch'

User Function DecodEx()
 
  Local cTexto := ""
  Local cEncodeUTF8 := ""
  Local cDecodeUTF8 := ""
  Local cMensagem := ""
    
  cTexto := "� noite, vov� kowalsky v� o �m� cair no p� do ping�im "
  cTexto += "queixoso e vov� p�e a��car no ch� de t�maras do jabuti feliz."
  cEncodeUTF8 := EncodeUTF8(cTexto, "cp1252")
  cDecodeUTF8 := DecodeUTF8(cEncodeUTF8, "cp1252")
  cMensagem := "Pangrama origem: [" + cTexto + "]"
  cMensagem += CRLF + "Texto -> UTF8: [" + cEncodeUTF8 + "]"
  cMensagem += CRLF + "UTF8 -> Texto: [" + cDecodeUTF8 + "]"
  MsgInfo(cMensagem, "Exemplo")
    
  // Brasil em Russo
  cTexto := chr(193)+chr(240)+chr(224)+chr(231)+chr(232)+chr(235)+chr(201)+chr(235)+chr(255)
  cEncodeUTF8 := EncodeUTF8(cTexto, "cp1251")
  cDecodeUTF8 := DecodeUTF8(cEncodeUTF8, "cp1251")
  cMensagem := "Pangrama origem: [" + cTexto + "]"
  cMensagem += CRLF + "Texto -> UTF8: [" + cEncodeUTF8 + "]"
  cMensagem += CRLF + "UTF8 -> Texto: [" + cDecodeUTF8 + "]"
  MsgInfo(cMensagem, "Exemplo")
 
Return
