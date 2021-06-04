extends Node2D
var controlador

func _ready():
	controlador=get_parent()

func comprarCarta(jogadorr):
	if(jogadorr.listaBaralho.size()>0):
		if(jogadorr.listaMao.size()<Constante.VALOR_MAXIMO_CARTAS):
			var animacao=load("res://cenas/animacoes/animacaoComprar.tscn").instance()
			animacao.definirPai(controlador)
			animacao.play(jogadorr)
		else:
			#DESCARTAR CARTA COMPRADA
			pass
	else:
		print("Perdeu!")
		
func executarCompra(jogadorr):
	#jogadorr.listaMao.append(jogadorr.listaBaralho[0])
	var carta = jogadorr.listaBaralho[0]
	if(jogadorr.time==0):
		carta.revelada = true
		controlador.get_node("controladorMao/mao").adicionaCartaMao(carta)
	else:
		controlador.get_node("controladorMao/maoOponente").adicionaCartaMao(carta)
	jogadorr.listaBaralho.remove(0)
	controlador.resolveHabilidades(jogadorr.listaAoComprar,controlador.get_oponente(jogadorr).listaAoComprar)
	
