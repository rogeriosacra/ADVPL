#Include "TOTVS.CH"

/*/ {Protheus.doc} User Function BD5
    (Exemplos de funcoes de Banco de Dados)
    @type		Function
    @author		Milton J.dos Santos
    @since		01/03/2020
    @version	1.0.0
    @param		Nenhum
    @return		Vazio (nil)
    @example    (examples)
    @see		(https://tdn.totvs.com/display/tec/Banco+de+Dados)
/*/

User Function BD5()

U_Tabela()
U_Indice()
U_Ordem
U_Pesquisa()

Return

/*
   Descricao: Exemplo de abertura de tabelas

   Dica: - Estes exemplos devem ser executados pelo modulo Financeiro, na opção de "Lancamento Padrao"

   Exemplos: U_Tabela(), U_Indice(), U_Ordem, U_Pesquisa() 

*/

// Abre tabelas
// Se a tabela ainda nao existe no banco de dados, o sistema cria atraves dos dicionarios  

User Function Tabelas()

DbSelectArea("SA1")     // Cadastro de Cliente
DbSelectArea("SA2")     // Cadastro de Fornecedores
DbSelectArea("SB1")     // Cadastro de Cliente
                 
Return

User Function Indice()

DbSelectArea("SA1")  // Cadastro de Cliente
DbSetOrder(1)        // Indice 1 : FILIAL + CODIGO + LOJA
DbSetOrder(2)        // Indice 2 : FILIAL + NOME
DbSetOrder(3)        // Indice 3 : FILIAL + CGC
DbSetOrder(4)        // Indice 4 : FILIAL + TELEFONE

Return

User Function Ordem()

dbSelectArea("SA1")
dbSetOrder(2)

// Mostra na tela qual a chave
MsgAlert(SA1->(INDEXKEY()))

dbGoTop()

While !EOF()

   MsgAlert("Nome: " + SA1->A1_Nome)
   dbSkip()

   Exit
   
End

Return Nil

User Function Pesquisa()

Local cCod
Local cLoja

dbSelectArea("SA1")
dbSetOrder(1)

cCod  := "000001"
cLoja := "01"

// Pesquisa o codigo do cliente, e motra em tela sem se preocupar se existe na tabela
dbSeek(xFilial("SA1") + cCod + cLoja)
MsgAlert( "Nome do cliente:" + SA1->A1_Nome )

// Mensagem se nao encontrou ou qual registro encontrou
MsgAlert(IIf(EOF(), "Fim de arquivo", Str(Recno())))

// Pesquisa o cliente, e antes de monstrar em tela se preocupando se existe ou nao existe
If dbSeek(xFilial("SA1") + cCod + cLoja) 
   MsgAlert(  "Nome do cliente:" + SA1->A1_Nome )
Else
   MsgAlert( "Cliente nao encontrado !" )
EndIf

Return Nil


