extends "res://script/classes/botao.gd"

var estado = 0

func acaoClick():
	
	match(estado):
		0:
			pass
		1:
			get_parent().passeLivre = true
		2:
			estado = 0
			get_parent().get_node("ControladorSelecao").enviado=true
		
	
	
