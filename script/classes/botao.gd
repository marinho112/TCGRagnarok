extends Area2D

var ativado = true

func _ready():
	set_process(true)
	
func _process(delta):
	
	if ativado:
		if Input.is_action_just_pressed("clicar"):
			var areas = get_overlapping_areas()
			for area in areas:
				if(area.is_in_group(Constante.GRUPO_MOUSE)):
					return acaoClick()
					
func acaoClick():
	pass
	
	
func set_text(texto):
	$fundo/texto.set_text(Ferramentas.receberTexto("Combate",texto))
	var font = $fundo/texto.get("custom_fonts/font")
	font.set("size",(int(Ferramentas.receberTexto("Combate",texto,1))))
