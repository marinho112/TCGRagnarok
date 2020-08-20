
var combate
var areaMao
var areaMiniatura
var areaZenys
var areaAtaque
var areaDefesa
var jogador


var tempoPassado = 0

func definirJogador(jogador):
	
	self.jogador = jogador
	areaMao = jogador.areaMao
	areaMiniatura=jogador.areaMiniatura
	areaZenys=jogador.areaZenys
	areaAtaque=jogador.areaAtaque
	areaDefesa=jogador.areaDefesa
	print(jogador)


func faseInicial(delta):
	return combate.faseInicial(delta)
	
func inicioFaseDeCompra(delta):
	return combate.inicioFaseDeCompra(delta)
	
func faseDeCompra(delta):
	return combate.faseDeCompra(delta)
func inicioFasePrincipal1(delta):
	return combate.inicioFasePrincipal1(delta)
	
func fasePrincipal(delta):
	var retorno = false
	tempoPassado+=delta
	if (tempoPassado > 1):
		retorno = true
		tempoPassado = 0
	return retorno
	
func fasePrincipal1(delta):
	return fasePrincipal(delta)
func inicioFaseCombate(delta):
	return combate.inicioFaseCombate(delta)
func faseCombate(delta):
	var retorno = false
	tempoPassado+=delta
	if (tempoPassado > 1):
		retorno = calcularCartaJogada(delta)
		tempoPassado = 0
	return retorno

func realizarAtaque(delta):
	return combate.realizarAtaque(delta)
func inicioFasePrincipal2(delta):
	return combate.inicioFasePrincipal2(delta)
func fasePrincipal2(delta):
	return fasePrincipal(delta)
func inicioFaseFinal(delta):
	return combate.inicioFaseFinal(delta)
func faseFinal(delta):
	return combate.faseFinal(delta)


func calcularCartaJogada(delta):
	var listaCartasPossiveis=[]
	var zeny = jogador.zeny
	var retorno = true
	for item in jogador.listaMao:
		#print(str(item.custo)+"/"+str(jogador.zeny))
		if (item.custo < zeny):
			#print(str(item.custo))
			listaCartasPossiveis.append(item)
	if(listaCartasPossiveis.size()>0):
		var numero = randi()%listaCartasPossiveis.size()
		retorno = !jogar(listaCartasPossiveis[numero])
	return retorno
	
func jogar(carta):
	var retorno = false
	var mao = areaMao.mao
	if((carta.custo <= jogador.zeny)):
		if(carta.tipo == Constante.CARTA_MONSTRO):
			carta.revelada=true
			var controlador = combate.get_node("ControladorCartas")
			var cartaNova = controlador.criarMonstro(carta,jogador)
			
			if(cartaNova != null):
				#controlador.positionAreaCarta(areaRelevante,cartaNova)
				var lista = cartaNova.carta.listaPalavraChave
				for elemento in lista:
					if (elemento.id == 4):
						cartaNova.imovel=true
			
			mao.remove(mao.find(carta))
			areaMao.atualizaMao()
			jogador.zeny -= carta.custo
			jogador.areaZenys.atualizarZeny()
			retorno= true
	else:
		areaMao.atualizaMao()
		retorno= false
	
	print (Ferramentas.receberTexto("cartas",carta.nome))
	return retorno
