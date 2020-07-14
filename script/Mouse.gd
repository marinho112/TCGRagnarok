extends Area2D



func _ready():
	add_to_group(Constante.GRUPO_MOUSE)
	set_process(true)
	
func _process(delta):
	set_global_position(get_global_mouse_position())
