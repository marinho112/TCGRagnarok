extends "res://script/classes/botao.gd"

var estado = Constante.INPUT_BTN_VERMELHO

func acaoClick():
	var jogador=get_parent().get_parent().get_node("controladorDeFases").retornaJogador()
	var input= Classes.InputUsuario.new(jogador,estado)
	get_parent().get_parent().inputDoUsuario.append(input)
	
func mudaEstado(estadoNovo):
	match(estadoNovo):
		Constante.INPUT_BTN_VERMELHO_CANCEL:
			estado=estadoNovo
			set_text(8,true,true)
		Constante.INPUT_BTN_DESATIVADO:
			estado=estadoNovo
			set_text(0,false,false)	
		_:
			estado=Constante.INPUT_BTN_VERMELHO
			set_text(2,true,true)
