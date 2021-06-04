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
	if zoom:
		exibirCartas()
	
func set_scale(scale):
	.set_scale(scale)
	$ScrollContainer/fundo.set_scale(Vector2(1,1)/scale)

func desenharHabilidades():
	pass

func morre(algoz):
	.morre(algoz)
	posicaoJogo.carta=null
	animacaoMorte()
	
func verificaVida(algoz):
	if(carta.retornaVida()<=0):
		morre(algoz)
		return true
	else:
		return false


func animacaoMorte():
	var animacao = load("res://cenas/animacoes/animacaoMorte.tscn").instance()
	print("MORREU!")
	animacao.definirPai(get_parent())
	animacao.play(self,[])
	
