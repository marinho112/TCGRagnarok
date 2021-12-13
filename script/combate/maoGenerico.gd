extends Node2D

var ativado = true
var mao= []
var maoVisual = []
var posicaoMao = []
var pai 
var variacaoX=70
var variacaoY=8
var variacaoRotate = 1.5
var jogador 
var cardZoom=null
var listaGrupos=[]


func definirJogador(parametro):
	jogador = parametro
	mao = parametro.listaMao
	atualizaMao()
	
func atualizaMao():
	pass

func zoomCarta(carta,booleano):
	
	if booleano:
		cardZoom = carta
		for elemento in maoVisual:
			elemento.setZoom(false)
		if(carta != null):
			carta.setZoom(true)
			if(cardZoom!=null):
				cardZoom.set_z_index(100)
	else:
		if(carta.zoom):
			if(cardZoom!=null):
				cardZoom.set_z_index(0)
			carta.setZoom(false)
			cardZoom = null

func retornarCarta():
	for elemento in maoVisual.size():
		var dif = maoVisual[elemento].get_global_position()-posicaoMao[elemento]
		if((Ferramentas.positivo(dif.x)+Ferramentas.positivo(dif.y))> 10):
			zoomCarta(maoVisual[elemento],false)
		
		maoVisual[elemento].set_global_position(posicaoMao[elemento])

func jogar(carta,areaRelevante=null):
	var cartaLogica=carta
	if(Ferramentas.verificaLogicoObjeto(cartaLogica)==Constante.OBJ_CARTA):
		cartaLogica = cartaLogica.carta
	if(Ferramentas.verificaLogicoObjeto(carta)==Constante.LOGI_CARTA):
		carta=carta.obj
	var dono=cartaLogica.dono
	if(areaRelevante!=null):
		dono = areaRelevante.retornaDono()
	if((cartaLogica.custo <= jogador.zeny) and (cartaLogica.dono == dono)):
		var cartaNova
		if(cardZoom==carta):
			cardZoom=null
		var controlador = pai.get_node("controladorCampo/ControladorCartas")
		cartaLogica.revelada=true
		mao.remove(mao.find(cartaLogica))
		jogador.zeny -= cartaLogica.custo
		jogador.areaZenys.atualizarZeny()
		match cartaLogica.tipo:
			Constante.CARTA_MONSTRO:
				cartaNova = controlador.criarMonstro(cartaLogica,jogador)
				cartaLogica.obj=cartaNova
				if(areaRelevante!=null):
					pai.get_node("controladorCampo/ControladorCartas").positionAreaCarta(areaRelevante,cartaNova)
				cartaLogica.aoJogar()
				pai.get_node("controladorCampo").atualizaTodasCartas()
			Constante.CARTA_ITEM:
				print("Carta Item")
				cartaLogica.aoJogar()
		atualizaMao()
		return cartaNova
	else:
		if(cartaLogica.custo > jogador.zeny):
			var msg="Não possuo zenys o suficiente para jogar essa carta."
			pai.get_node("controladorCampo").adicionaAlerta(msg)
			#print("Carta de custo indevido.")
		retornarCarta()
		return null

func adicionaCartaMao(carta):
	mao.append(carta)
	var novaCarta = ControladorCartas.criarCarta(carta,self,Vector2(0,0))
	for item in listaGrupos:
		novaCarta.add_to_group(item)
	carta.obj=novaCarta
	print(carta.obj)
	maoVisual.append(novaCarta)
	posicaoMao = []
