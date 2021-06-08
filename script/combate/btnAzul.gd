extends "res://script/classes/botao.gd"

var estado = Constante.INPUT_BTN_AZUL

func acaoClick():
	var pai=get_parent().get_parent()
	var jogador=pai.get_node("controladorDeFases").retornaJogador(pai.jogador)
	var input= Classes.InputUsuario.new(jogador,estado)
	get_parent().get_parent().inputDoUsuario.append(input)
	
func mudaEstado(estadoNovo):
	match(estadoNovo):
		Constante.INPUT_BTN_AZUL_BLOQUEIO:
			estado=estadoNovo
			set_text(6,true,true)
		Constante.INPUT_BTN_AZUL_ATAQUE:
			estado=estadoNovo
			set_text(1,true,true)
		Constante.INPUT_BTN_AZUL_DANO:
			estado=estadoNovo
			set_text(5,true,true)
		Constante.INPUT_BTN_AZUL_ENVIAR:
			estado=estadoNovo
			set_text(7,true,true)
		Constante.INPUT_BTN_AZUL_PRONTO:
			estado=estadoNovo
			set_text(9,true,true)	
		Constante.INPUT_BTN_DESATIVADO:
			estado=estadoNovo
			set_text(0,false,false)	
		_:
			estado=Constante.INPUT_BTN_AZUL
			set_text(2,true,true)



