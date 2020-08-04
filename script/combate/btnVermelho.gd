extends "res://script/classes/botao.gd"

var estado = 0

func acaoClick():
	
	match(estado):
		0:
			pass
		1:
			get_parent().subFase = 0
			get_parent().fase = 10
		2:
			pass
