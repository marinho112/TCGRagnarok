extends Node

func criarCartaDoZero(idCarta,pai,posicao,val=false):
	var carta = ControlaDados.carregaCartaPorID(idCarta)
	return criarCarta(carta,pai,posicao,val)
	
func criarCarta(carta,pai,posicao,val=false):
	var retorno
	match carta.tipo:
		
		Constante.CARTA_PERSONAGEM:
			pass
		Constante.CARTA_MONSTRO:
			retorno=criarCartaMonstro(carta,pai,posicao,val)
			
		Constante.CARTA_ITEM:
			pass
		Constante.CARTA_HABILIDADE:
			pass
		Constante.CARTA_EFEITO:
			pass
	return retorno
	
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
	
