extends Node2D



func _ready():
	
	var carta = ControladorCartas.criarCartaDoZero(1,self,Vector2(200,200),true)
	carta.add_to_group(Constante.GRUPO_CARTA_EM_CAMPO)
	$Combate/ControladorCartas.cursorMouse = $Mouse
