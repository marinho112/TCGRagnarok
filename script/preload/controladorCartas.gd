extends Node

func criaCartaAleatoria(jogador,pai,posicao,val=false):
	var carta = ControlaDados.carregaCartaAleatoria(jogador)
	return criarCarta(carta,pai,posicao,val)
	

func criarCartaDoZero(idCarta,jogador,pai,posicao,val=false):
	var carta = ControlaDados.carregaCartaPorID(idCarta,jogador)
	carta.revelada=true
	return criarCarta(carta,pai,posicao,val)
	
func criarCarta(carta,pai,posicao,val=false):
	var retorno
	
	if (!carta.revelada):
		return criaCartaEscondida(carta,pai,posicao)
	match carta.tipo:
		
		Constante.CARTA_PERSONAGEM:
			retorno=criarCartaMonstro(carta,pai,posicao,val)
		Constante.CARTA_MONSTRO:
			retorno=criarCartaMonstro(carta,pai,posicao,val)
		Constante.CARTA_ITEM:
			retorno=criarCartaItem(carta,pai,posicao)
		Constante.CARTA_HABILIDADE:
			pass
		Constante.CARTA_EFEITO:
			pass
	retorno.get_superPai()
	return retorno
	
func criaCartaEscondida(carta,pai,posicao):
	var objetoCarta = load("res://cenas/cartas/CartaEscondida.tscn").instance()
	
	objetoCarta.carta = carta
	pai.add_child(objetoCarta)
	objetoCarta.set_global_position(posicao)
	return objetoCarta
	
func criarCartaMonstro(carta,pai,posicao,val):
	
	var loadCarta
	
	if val:
		loadCarta = load("res://cenas/cartas/miniaturas/MiniaturaMonstro.tscn")
	else:
		loadCarta = load("res://cenas/cartas/CartaMonstro.tscn")
	
	var objetoCarta=loadCarta.instance()
	
	preparaCarta(pai,objetoCarta,carta,posicao)
	
	return objetoCarta

func criarCartaItem(carta,pai,posicao):
	
	var objetoCarta = load("res://cenas/cartas/CartaItem.tscn").instance()
	
	preparaCarta(pai,objetoCarta,carta,posicao)
	
	return objetoCarta

func preparaCarta(pai,objetoCarta,carta,posicao):
	pai.add_child(objetoCarta)
	objetoCarta.preparaCarta(carta)
	if(posicao!=null):
		objetoCarta.set_global_position(posicao)
