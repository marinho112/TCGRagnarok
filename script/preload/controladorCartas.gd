extends Node


func criarCarta(idCarta,pai,posicao):
	
	
	var carta = ControlaDados.carregaCartaPorID(idCarta)
	
	match carta.tipo:
		
		Constante.CARTA_PERSONAGEM:
			pass
		Constante.CARTA_MONSTRO:
			criarCartaMonstro(carta,pai,posicao)
		Constante.CARTA_ITEM:
			pass
		Constante.CARTA_HABILIDADE:
			pass
		Constante.CARTA_EFEITO:
			pass
	
func criarCartaMonstro(carta,pai,posicao):
	var objetoCarta = load("res://cenas/cartas/CartaMonstro.tscn").instance()
	objetoCarta.preparaCarta(carta)
	pai.add_child(objetoCarta)
	objetoCarta.set_global_position(posicao)
	
