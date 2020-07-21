extends Node2D



func _ready():
	
	$Combate/ControladorCartas.criarMonstro(ControlaDados.carregaCartaPorID(1))
	#$Combate.cursorMouse = $Mouse
