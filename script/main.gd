extends Node2D



func _ready():
	
	$Combate/ControladorCartas.criarMonstro(ControlaDados.carregaCartaPorID(2))
	#$Combate.cursorMouse = $Mouse
