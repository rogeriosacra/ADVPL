#include 'protheus.ch'
#include "tbiconn.ch"
#DEFINE CRLF Chr(13)+Chr(10)
 
/*{Protheus.doc} User Function fTamSx3
    (Essa função tem por finalidade mostrar a função TamSx3 em ADVPL/TL++ para obter o tamanho do campo e o tamanho
    do seu decimal na SX3 do TOTVS Protheus)
    @type  Function
    @author Adilio Costa
    @since 27/06/2022
    @version Protheus 12.1.2210
    @site https://www.protheusadvpl.com.br
    @canal https://www.youtube.com/protheusadvpl
    @instagram https://www.instagram.com/protheusadvpl
    @Portal ProtheusAdvpl:https://hotmart.com/pt-br/marketplace/produtos/portal-protheusadvpl/O10336806O
*/
 
User Function fTamSx3()
 
Local nTamCampo
Local nTamCamDec
Local xTipoCampo
Local cInf := ""
 
//Abro o ambiente
    RpcSetType(3)
    PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "FAT"
 
//Retorna o tamanho do campo D1_QUANT na tabela SX3
nTamCampo := TamSx3("D1_QUANT")[1]
//Retorna o tamanho do decimal do campo D1_QUANT na tabela SX3
nTamCamDec := TamSx3("D1_QUANT")[2]
//Retorna o tipo de dado do campo D1_QUANT na tabela SX3
xTipoCampo := TamSx3("D1_QUANT")[3]
 
cInf := "Tamanho do Campo D2_QUANT:"+cValToChar(nTamCampo)
cInf += ", Tamanho do Decimal do D2_QUANT:"+cValToChar(nTamCamDec)
cInf += ", Tipo de dado do campo D2_QUANT:"+xTipoCampo
 
ConOut(cInf)
 
 
Return
