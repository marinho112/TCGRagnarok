extends "res://script/animacoes/animacao.gd"

var rotacionado = 0
var destino
var inicio
var vel = 3000
var posicaoInicio
var posicaoFinal
var pontoMedio
var imagem
var raio
var fator = Vector2(0,0)

func play(dono,listaAlvos = [],pausar = null,velo = 1.0,sequencia=null):
	.play(dono,listaAlvos,5,velo)
	vel *= velo
	if(dono.time == 0):
		inicio = pai.get_node("controladorBaralho/deck")
		destino = pai.get_node("controladorMao/mao")
	else:
		inicio = pai.get_node("controladorBaralho/deckOponente")
		destino = pai.get_node("controladorMao/maoOponente")
	
	
	posicaoInicio = inicio.get_global_position()
	rotacionado = inicio.get_rotation()
	imagem = ControladorCartas.criaCartaEscondida(0,pai,posicaoInicio)
	imagem.set_rotation(rotacionado)
	imagem.set_scale(Vector2(0.5,0.5))
	posicaoFinal = destino.get_global_position()
	pontoMedio = ((posicaoFinal + posicaoInicio)/2) #+vec
	if(posicaoInicio.x > posicaoFinal.x):
		fator.x=-1
	else:
		fator.x=1
		
	fator.y=0.5
	
	
func executa(delta):
	
	executando=true
	var posicaoAtual = imagem.get_global_position()
	#print(posicaoAtual)
	var diferenca = posicaoAtual - posicaoFinal
	var positivoDiferenca = Vector2(Ferramentas.positivo(diferenca.x),Ferramentas.positivo(diferenca.y))
	var subFator = Vector2(1,1)
	if(pontoMedio.x < posicaoAtual.x):
		subFator.y=-1
	
	var passa = false
	
	if(dono.time == 0):
		if(posicaoAtual.x > posicaoFinal.x):
			passa = true
	else:
		if(posicaoAtual.x < posicaoFinal.x):
			passa = true
	
	if(passa):
		
		imagem.set_global_position(posicaoAtual+(subFator*fator*vel*delta))
		imagem.set_rotation(rotacionado+ deg2rad(-subFator.y*positivoDiferenca.x/100))
		
	else:
		imagem.set_visible(false)
		imagem.queue_free()
		pai.get_node("controladorBaralho").executarCompra(dono)
		encerrar()

