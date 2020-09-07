extends Node2D

var carta
var posicaoRaiz
var zoom
var visual
var ativado = true
var selecionavel = false
var time = 0
var frame = 0

func _ready():
	add_to_group(Constante.GRUPO_CARTA)
	setZoom(false)

func defineBrilho(val):
	$brilho.set_visible(val)

func _process(delta):
	animacaoBrilho(delta)

func exibirCartas():
	pass

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
		
func animacaoBrilho(delta):
	if($brilho.is_visible()):
		if(time>0.1):
			time=0
			$brilho.set_frame(frame)
			var rot = $brilho.get_rotation_degrees()
			if(rot>=270):
				$brilho.set_rotation_degrees(rot+90)
			else:
				$brilho.set_rotation_degrees(0)
				frame+=1
				if(frame>1):
					frame=0
		else:
			time+=delta
