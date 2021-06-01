extends "res://script/animacoes/animacao.gd"

var preDano = preload("res://cenas/animacoes/animacaoDano.tscn")
var acabado
var cont=0
var listaLinhas = []
var listaAnimacoes= []

func play(dono,listaAlvos = [],pausar = 4,velo = 1.0):
	.play(dono,listaAlvos,pausar,velo)
	posicionarLinhas()
	if(!pausar):
		listaAnimacoes[0].append(self)
	$AnimationPlayer.play("main",-1,velo)

func executa(delta):
	executando=true
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
				listaAnimacoes[1].append(novaAnimacao)
				
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
		var altura = 0
		var novaLinha = $linha.duplicate()
		var novaPonta = $ponta.duplicate()
		add_child(novaLinha)
		add_child(novaPonta)
		listaLinhas.append(novaLinha)
		listaLinhas.append(novaPonta)
		var posicaoAlvo = alvo.get_global_position()
		var posicaoMedia = (posicaoAlvo+posicaoDono)/2.0
		if(posicaoDono<posicaoAlvo):
			altura = 180
		
		novaLinha.set_global_position(posicaoMedia)
		#criarPonto(posicaoAlvo)
		var distanciaX = Ferramentas.positivo(posicaoDono.x-posicaoAlvo.x)
		var distanciaY = Ferramentas.positivo(posicaoAlvo.y-posicaoDono.y)
		var diagonalDistancia = sqrt((distanciaX*distanciaX)+(distanciaY*distanciaY))
		var scala = diagonalDistancia/tamanhoSprite.x
		novaLinha.set_scale(Vector2(scala/0.3,0.4))
		novaPonta.set_scale(Vector2(1.5,1.5))
		if (distanciaX == 0):
			altura += 180
		var seno = distanciaY/diagonalDistancia
		var cosseno = distanciaX/diagonalDistancia
		novaPonta.set_global_position(posicaoAlvo)
		novaLinha.set_rotation(-asin(seno))
		novaPonta.set_rotation_degrees(rad2deg(-asin(seno))+altura)
		
		
	
	
func setListaAnimacao(lista):
	listaAnimacoes=lista

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
