#Include 'Protheus.ch'
#Include 'Totvs.ch'

User Function A010tok()

	cGrupo := Alltrim(M->B1_GRUPO)
	lGrava := .T.

	if cGrupo == ""
		lGrava := .F.
		Alert("O preenchimento do campo <b>GRUPO DE PRODUTOS</b> é obrigatório!")
	endif

Return lGrava

