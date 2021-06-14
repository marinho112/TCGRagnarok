extends Area2D

var carta

func _ready():
	add_to_group(Constante.GRUPO_AREA_CARTA)
	
func retornaDono():
	var pai=get_parent()
	return pai.get_parent().retornaDono(pai)


