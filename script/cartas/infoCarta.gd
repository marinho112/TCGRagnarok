extends Node2D



func _ready():
	set_process(true)
	
func _process(delta):
	if Input.is_action_just_pressed("clicar"):
		get_parent().ativado = true
		queue_free()

func setTexto(texto):
	$texto.set_text(texto)
