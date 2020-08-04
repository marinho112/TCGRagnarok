extends "res://script/classes/botao.gd"

var estado = 0

func acaoClick():
	
	match(estado):
		0:
			pass
		1:
			get_parent().subFase+=1
		2:
			pass
	

