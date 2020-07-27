extends "res://script/cartas/CartaMonstro.gd"

var posicaoJogo

func _ready():
	._ready()
	add_to_group(Constante.GRUPO_CARTA_REDUZIDA)
	
	miniatura = true

func desenhaAtributosComplementares():
	pass
	
func defineFraqueseResistencia(fraco,forte):
	pass

func carregaImagem():
	fundo="ScrollContainer/fundo"
	.carregaImagem()
	$ScrollContainer/fundo.set_position(carta.posicaoImagem + Vector2(174,95))

func desenharPropriedade(complemento=""):
	.desenharPropriedade("-Reduzido")
	
func setZoom(zoom):
	if(zoom):
		self.ativado = false
		var carta = ControladorCartas.criarCartaMonstro(self.carta,get_parent(),Vector2(0,0),false)
		carta.setZoom(true)
		carta.add_to_group(Constante.GRUPO_CARTA_EM_CAMPO)
		get_parent().add_child(carta)
		if(visual!=null):
			visual.queue_free()
		visual=carta
		carta.visual=self

func set_scale(scale):
	.set_scale(scale)
	$ScrollContainer/fundo.set_scale(Vector2(1,1)/scale)
