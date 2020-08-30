extends "res://script/animacoes/animacao.gd"

var preDano = preload("res://cenas/animacoes/animacaoDano.tscn")
var acabado
var cont=0
var listaLinhas = []

func play(dono,listaAlvos = [],pausar = null,velo = 1.0):
	.play(dono,listaAlvos,4,velo)
	posicionarLinhas()
	$AnimationPlayer.play("main",-1,velo)

func _process(delta):
	
	if(acabado):
		if(cont < listaAlvos.size()):
			var alvo = listaAlvos[cont]
			if(resolveHabilidades(dono.carta.dono.listaAoGolpear,alvo.carta.dono.listaAoSerGolpeado,dono,alvo)):
				cont+=1
				var novaAnimacao = preDano.instance()
				novaAnimacao.definirPai(get_parent())
				var posicao = alvo.get_node("coracao").get_global_position()
				novaAnimacao.set_global_position(posicao)
				var causado = dono.golpear(alvo)
				novaAnimacao.setDano(causado)
				novaAnimacao.play(dono,[alvo],null,velo)
				
		else:
			acabado=false
			cont=0
			encerrar()
	
func acabar():
	acabado = true


func posicionarLinhas():
	var posicaoDono = dono.get_global_position()
	#criarPonto(posicaoDono)
	var tamanhoSprite = $linha.texture.get_size()
	for alvo in listaAlvos:
		var novaLinha = $linha.duplicate()
		#add_child(novaLinha)
		listaLinhas.append(novaLinha)
		var posicaoAlvo = alvo.get_global_position()
		var posicaoMedia = (posicaoAlvo+posicaoDono)/2.0
		novaLinha.set_global_position(posicaoMedia)
		#criarPonto(posicaoAlvo)
		
		var distanciaX = Ferramentas.positivo(posicaoDono.x-posicaoAlvo.x)
		var distanciaY = Ferramentas.positivo(posicaoAlvo.y-posicaoDono.y)
		var diagonalDistancia = sqrt((distanciaX*distanciaX)+(distanciaY*distanciaY))
		var scala = diagonalDistancia/tamanhoSprite.x
		novaLinha.set_scale(Vector2(scala/0.3,0.2))
		var seno = distanciaY/diagonalDistancia
		var cosseno = distanciaX/diagonalDistancia	
		novaLinha.set_rotation_degrees(sin(1/seno))
		
	
	


func criarPonto(position):
	var novaLinha = $linha.duplicate()
	pai.add_child(novaLinha)
	novaLinha.set_scale(Vector2(0.1,0.2))
	novaLinha.set_global_position(position)
	novaLinha.set_visible(true)
	novaLinha.set_z_index(1000)
	
func exibirLinhas():
	for linha in listaLinhas:
		linha.set_visible(true)
