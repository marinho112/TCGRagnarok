extends Node2D

var carta
var posicaoRaiz
var zoom
var visual
var ativado = true

func _ready():
	add_to_group(Constante.GRUPO_CARTA)
	setZoom(false)

func setZoom(zoom):
	self.zoom=zoom
	if(zoom):
		scale = Vector2(1.5,1.5)
	else:
		if(visual!=null):
			visual.visual=null
			visual.ativado=true
			self.queue_free()
		scale = Vector2(0.8,0.8)
		
