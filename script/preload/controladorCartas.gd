extends Node

func criaCartaAleatoria(pai,posicao,val=false):
	var carta = ControlaDados.carregaCartaAleatoria()
	return criarCarta(carta,pai,posicao,val)
	

func criarCartaDoZero(idCarta,pai,posicao,val=false):
	var carta = ControlaDados.carregaCartaPorID(idCarta)
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
			pass
		Constante.CARTA_HABILIDADE:
			pass
		Constante.CARTA_EFEITO:
			pass
	return retorno
	
func criaCartaEscondida(carta,pai,posicao):
	var objetoCarta = load("res://cenas/cartas/CartaEscondida.tscn").instance()
	
	objetoCarta.carta = carta
	pai.add_child(objetoCarta)
	objetoCarta.set_global_position(posicao)
	return objetoCarta
	
func criarCartaMonstro(carta,pai,posicao,val):
	
	var objetoCarta
	
	if val:
		objetoCarta = load("res://cenas/cartas/miniaturas/MiniaturaMonstro.tscn").instance()
	else:
		objetoCarta = load("res://cenas/cartas/CartaMonstro.tscn").instance()

	objetoCarta.preparaCarta(carta)
	pai.add_child(objetoCarta)
	objetoCarta.set_global_position(posicao)
	return objetoCarta
	
