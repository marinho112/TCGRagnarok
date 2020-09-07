extends "res://script/classes/botao.gd"

var estado = 0

func acaoClick():
	
	match(estado):
		0:
			pass
		1:
			get_parent().subFase+=1
			estado = 0
		2:
			get_parent().bloqueado = true
			estado = 0
		3:
			estado = 0
			get_parent().get_node("ControladorSelecao").enviado=true

