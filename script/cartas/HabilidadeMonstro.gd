extends Node2D

var habilidade
var cartaPai

func _ready():
	cartaPai=get_parent()
	set_process(true)
	
func _process(delta):
	if cartaPai.ativado:
		if Input.is_action_just_pressed("clicar"):
			for area in $custoHabilidade/colisao.get_overlapping_areas():
				if(area.is_in_group(Constante.GRUPO_MOUSE)):
					print("FOI")
