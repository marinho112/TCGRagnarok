extends Node2D

func comprarCarta(jogadorr):
	if(jogadorr.listaBaralho.size()>0):
		if(jogadorr.listaMao.size()<Constante.VALOR_MAXIMO_CARTAS):
			var animacao=load("res://cenas/animacoes/animacaoComprar.tscn").instance()
			animacao.definirPai(get_parent())
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
		get_parent().get_node("controladorMao/mao").adicionaCartaMao(carta)
	else:
		get_parent().get_node("controladorMao/maoOponente").adicionaCartaMao(carta)
	jogadorr.listaBaralho.remove(0)
