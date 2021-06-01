extends Area2D

const TEMPO_ESPERA=1
var ativado = true
var clickado = TEMPO_ESPERA

func _ready():
	set_process(true)
	
func _process(delta):
	if ativado:
		if clickado < TEMPO_ESPERA:
			clickado+=delta
			return
		if Input.is_action_just_pressed("clicar"):
			var areas = get_overlapping_areas()
			for area in areas:
				if(area.is_in_group(Constante.GRUPO_MOUSE)):
					clickado= 0
					return acaoClick()
					
func acaoClick():
	pass
	
func mudaEstado(estadoNovo):
	pass
	
func set_text(texto,ativar=null,visual = null):
	if(ativar!=null):
		ativado = ativar
	if(visual!=null):
		set_visible(visual)
	$fundo/texto.set_text(Ferramentas.receberTexto("Combate",texto))
	var font = $fundo/texto.get("custom_fonts/font")
	font.set("size",(int(Ferramentas.receberTexto("Combate",texto,1))))
