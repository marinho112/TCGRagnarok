
var combate
var areaMao
var areaMiniatura
var areaZenys
var areaAtaque
var areaDefesa
var jogador

var criarListaAtaqueDefesa=false 
var listaDecidirAtaqueDefesa=[]
var listaCartasCampo=[]
var listaCartasCampoOponente=[]
var necessidadeDeDefesa = 0
var antiNecessidadeDeDefesa = 0
var tempoPassado = 0

func definirJogador(jogador):
	
	self.jogador = jogador
	areaMao = jogador.areaMao
	areaMiniatura=jogador.areaMiniatura
	areaZenys=jogador.areaZenys
	areaAtaque=jogador.areaAtaque
	areaDefesa=jogador.areaDefesa


func faseInicial(delta):
	return combate.faseInicial(delta)
	
func inicioFaseDeCompra(delta):
	return combate.inicioFaseDeCompra(delta)
	
func faseDeCompra(delta):
	return combate.faseDeCompra(delta)
func inicioFasePrincipal1(delta):
	criarListaAtaqueDefesa=true
	return combate.inicioFasePrincipal1(delta)
	
func fasePrincipal(delta):
	var retorno = false
	tempoPassado+=delta
	if (tempoPassado > 0.1):
		if(calcularCartaJogada(delta)):
			if criarListaAtaqueDefesa:
				criarListaAtaqueDefesa()
			else:
				retorno = calcularPosicoesCartasAtaque(delta)
		tempoPassado = 0
	return retorno
	
func fasePrincipal1(delta):
	return fasePrincipal(delta)
func inicioFaseCombate(delta):
	return combate.inicioFaseCombate(delta)
func faseCombate(delta):
	var retorno = false
	tempoPassado+=delta
	if (tempoPassado > 0.1):
		retorno = true
		tempoPassado = 0
	return retorno

func realizarAtaque(delta):
	return combate.realizarAtaque(delta)
func inicioFasePrincipal2(delta):
	criarListaAtaqueDefesa=true
	return combate.inicioFasePrincipal2(delta)
func fasePrincipal2(delta):
	return fasePrincipal(delta)
func inicioFaseFinal(delta):
	return combate.inicioFaseFinal(delta)
func faseFinal(delta):
	return combate.faseFinal(delta)


func calcularCartaJogada(delta):
	var zeny = jogador.zeny
	var listaCartasPossiveis= receberCartasPossiveis(zeny)
	var retorno = true
	
	if(listaCartasPossiveis.size()>0):
		var numero = randi()%listaCartasPossiveis.size()
		retorno = !jogar(listaCartasPossiveis[numero])
	return retorno
	
func receberCartasPossiveis(zeny):
	var lista = []
	for item in jogador.listaMao:
		#print(str(item.custo)+"/"+str(jogador.zeny))
		if (item.custo < zeny):
			#print(str(item.custo))
			lista.append(item)
	
	return lista
	
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
	
	return retorno

func criarListaAtaqueDefesa():
	antiNecessidadeDeDefesa = 0
	listaDecidirAtaqueDefesa = []
	listaCartasCampo = combate.retornaCartasArea(areaAtaque)+combate.retornaCartasArea(areaDefesa)
	for item in listaCartasCampo:
		var carta = item.carta
		var ataque = (carta.retornaPoder()*3) + (carta.retornaVidaTotal())
		var defesa = carta.danoRecebido * 2
		antiNecessidadeDeDefesa += carta.retornaPoder()*3  
		for palavra in carta.listaPalavraChave :
			ataque+= palavra.incentivoAtaqueDefesa
		listaDecidirAtaqueDefesa.append(ataque-defesa)
	criarListaAtaqueDefesa = false
	antiNecessidadeDeDefesa += jogador.personagem.danoRecebido * 2
	antiNecessidadeDeDefesa -= jogador.personagem.retornaVidaTotal() 
	defineNecessidadeDeDefesa()

func defineListaCartasCampoOponente():
	var oponenteAreaAtaque = combate.listaJogadores[0].areaAtaque
	var oponenteAreaDefesa = combate.listaJogadores[0].areaDefesa
	listaCartasCampoOponente = combate.retornaCartasArea(oponenteAreaAtaque)+combate.retornaCartasArea(oponenteAreaDefesa)
	

func defineNecessidadeDeDefesa():
	necessidadeDeDefesa = 0
	defineListaCartasCampoOponente()
	for item in listaCartasCampoOponente:
		var carta = item.carta
		necessidadeDeDefesa += (carta.retornaPoder()*3) 
		necessidadeDeDefesa -= carta.danoRecebido * 2
		
	necessidadeDeDefesa+= jogador.personagem.danoRecebido * 2
	necessidadeDeDefesa-= jogador.personagem.retornaVidaTotal() 


func listaXmaiores(x,lista):
	var listaNova = []
	var maior = [null,null]
	var limite = [null,null]
	for posi in x:
		maior = [null,null]
		for i in lista.size():
			var item = lista[i]
			if( (maior[0]==null)or(item>maior[0])):
				if((limite[0]==null)or (item<limite[0])):
					maior=[item,i]
				elif((item==limite[0]) and (i>limite[1])):
					maior=[item,i]
			elif(item==maior[0]):
				if(i<maior[1]):
					if((limite[1]==null)or(i>limite[1])):
						maior=[item,i]
		limite= maior
		listaNova.append(maior[1])
	return listaNova
	
func calcularPosicoesCartasAtaque(delta):
	var retorno = false
	var numAtacantes = calcularNumeroAtacantes()
	
	var listaAtacantes = listaXmaiores(listaCartasCampo.size(),listaDecidirAtaqueDefesa)
	var posicoesValidas = calcularPosicoesValidas(areaAtaque)
	var listaCartasAtacantes = []
	for c in listaCartasCampo.size():
		if(listaCartasAtacantes.size()<numAtacantes):
			var carta = listaCartasCampo[listaAtacantes[c]] 
			if(!carta.carta.temPalavraChave(4)):
				listaCartasAtacantes.append(carta)
	
	for carta in listaCartasAtacantes:
		var passa = true
		if(!carta.posicaoJogo.is_in_group(Constante.GRUPO_AREA_CARTA_ATAQUE)):
			for posicao in posicoesValidas:
				if passa:
					if(posicao.carta==null):
						combate.get_node('ControladorCartas').animacaoTrocaDeCartas(posicao,carta)
						passa=false
					elif(listaCartasAtacantes.count(posicao.carta)==0):
						if(!posicao.carta.carta.temPalavraChave(4)):
							combate.get_node('ControladorCartas').animacaoTrocaDeCartas(posicao,carta)
							passa=false
					
#	for p in posicoesValidas.size():
#		var posicao = posicoesValidas[p]
#		var carta = null 
#		if(p<listaAtacantes.size()):
#			carta=listaCartasCampo[listaAtacantes[p]] 
#		if(carta != null):
#			combate.get_node('ControladorCartas').animacaoTrocaDeCartas(posicao,carta)
	
	#print(listaDecidirAtaqueDefesa)
	#print(listaXmaiores(listaDecidirAtaqueDefesa.size(),listaDecidirAtaqueDefesa))
		
	retorno = true
	return retorno

func calcularNumeroAtacantes():
	var fator = necessidadeDeDefesa - antiNecessidadeDeDefesa
	var numAtacantes = 0
	if(fator>0):
		numAtacantes = listaCartasCampo.size() - listaCartasCampoOponente.size()
	else:
		numAtacantes = listaCartasCampo.size()
	if(numAtacantes>6):
		numAtacantes =6
	if(numAtacantes<0):
		numAtacantes=0
		
	return numAtacantes
	
func calcularPosicoesValidas(area):
	var lista = combate.retornaCartasArea(area,false)
	
	return lista
	