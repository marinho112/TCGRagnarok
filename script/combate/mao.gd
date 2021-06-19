extends "res://script/combate/maoGenerico.gd"


var cursorMouse
var cartaSelecionada = null
var cursorMousePosition

var duploClik = false

var tamanhoMao

func _ready():
	add_to_group(Constante.GRUPO_AREA_MAO)
	pai= get_parent().get_parent()
	cursorMouse = pai.get_parent().get_node("Mouse")
	set_process(true)
	
	
func _process(delta):
	
	if (ativado and (pai.get_node("controladorCampo/ControladorCartas").cartaSelecionada==null)):
		
		if((cursorMouse!=null) and (cartaSelecionada==null)):
			
			if(Input.is_action_pressed("clicar")):
				var area = receberCartaNaFrente()
				if(area != null):
					selecionaCarta(area)
					cursorMousePosition = cursorMouse.get_global_position()
					
		if(Input.is_action_just_released("clicar")):
			var item = receberCartaNaFrente()
			if(cartaSelecionada!=null):
				if(!cartaSelecionada.zoom):
					var cont =0
					var controlador = pai.get_node("controladorCampo/ControladorCartas")
					var areaRelevante = controlador.receberAreaMaisRelevante(cartaSelecionada)
					var estado=Constante.INPUT_JOGAR_CARTA
					var jogadorObj=get_parent().get_parent().get_node("controladorDeFases").listaJogadores[0]
					var input= Classes.InputUsuario.new(jogadorObj,estado,[areaRelevante,cartaSelecionada,self])
					get_parent().get_parent().inputDoUsuario.append(input)
				selecionaCarta(null)
			
			if(item != null):
				if(duploClik):
					item.exibirCartas()
					zoomCarta(item,false)
					duploClik = false
				else:
					duploClik = true
					$Timer.start()
					
					if(item.zoom):
						var cartaDoZoom = item
						zoomCarta(cartaDoZoom,false)
					else:
						if !cardZoom:
							zoomCarta(item,true)
				
			
		else:
			if(cartaSelecionada!=null):
				var posicaoCarta = cartaSelecionada.get_global_position()
				var novaPosicao = cursorMouse.get_global_position()
				if(cartaSelecionada.zoom and moveu(cartaSelecionada)):
					zoomCarta(cartaSelecionada,false)
				cartaSelecionada.set_global_position(posicaoCarta-cursorMousePosition+novaPosicao)
				cursorMousePosition=novaPosicao
			return
	
func jogar(carta,areaRelevante=null):
	var cartaLogica = carta.carta
	if((cartaLogica.custo <= jogador.zeny) and (cartaLogica.dono == areaRelevante.retornaDono())):
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
				for carta in mao:
					print(carta.obj)
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
		
func selecionaCarta(carta):
	
	if carta == null:
		pai.get_node("controladorCampo/ControladorCartas").ativado = true
		if(cartaSelecionada!=null):
			cartaSelecionada.set_z_index(0)
		if cardZoom != null:
			cardZoom.set_z_index(100)
	else:
		pai.get_node("controladorCampo/ControladorCartas").ativado = false
		carta.set_z_index(100)
	
	cartaSelecionada = carta
	
func adicionaCartaMao(carta):
	
	mao.append(carta)
	var novaCarta = ControladorCartas.criarCarta(carta,self,Vector2(0,0))
	novaCarta.add_to_group(Constante.GRUPO_CARTA_NA_MAO_JOGADOR)
	novaCarta.add_to_group(Constante.GRUPO_CARTA_NA_MAO)
	carta.obj=novaCarta
	maoVisual.append(novaCarta)
	posicaoMao = []
	
	var tamanho = mao.size()
	tamanhoMao = tamanho
	var posicaoInicial = get_global_position()
	var par = false
	var meio = posicaoInicial.y
	var valorY= variacaoY
	var valorR= variacaoRotate * int(tamanho/2)
	if(tamanho%2==0):
		par =  true
	
	posicaoInicial+= Vector2(int(variacaoX/2)*tamanho,variacaoY*int(tamanho/2))
	
	
	for num in maoVisual.size():
		carta = maoVisual[num]
		carta.set_global_position(posicaoInicial)
		carta.posicaoRaiz=posicaoInicial
		posicaoMao.append(carta.get_global_position())
		carta.set_rotation(deg2rad(valorR))
		valorR-=variacaoRotate
		if!(par and (num==(mao.size()-mao.size()/2-1))):
			if((num==(mao.size()-(mao.size()+1)/2))):
				valorY= -variacaoY
			posicaoInicial-= Vector2(variacaoX,valorY)
		else:
			posicaoInicial-= Vector2(variacaoX,0)
			valorR-=variacaoRotate
			valorY= -variacaoY
	
	
func atualizaMao():
	selecionaCarta(null)
	for item in maoVisual:
		item.queue_free()
	maoVisual=[]
	
	
	var tamanho = mao.size()
	tamanhoMao = tamanho
	var posicaoInicial = get_global_position()
	var par = false
	var meio = posicaoInicial.y
	var valorY= variacaoY
	var valorR= variacaoRotate * int(tamanho/2)
	posicaoInicial+= Vector2(int(variacaoX/2)*tamanho,variacaoY*int(tamanho/2))
	var cartaNova
	var carta
	posicaoMao = []
	
	if(tamanho%2==0):
		par =  true
	
	for num in mao.size():
		carta = mao[num]
		cartaNova = ControladorCartas.criarCarta(carta,self,posicaoInicial)
		cartaNova.posicaoRaiz=posicaoInicial
		cartaNova.add_to_group(Constante.GRUPO_CARTA_NA_MAO_JOGADOR)
		cartaNova.add_to_group(Constante.GRUPO_CARTA_NA_MAO)
		posicaoMao.append(cartaNova.get_global_position())
		maoVisual.append(cartaNova)
		carta.obj=cartaNova
		cartaNova.set_rotation(deg2rad(valorR))
		
		valorR-=variacaoRotate
		if!(par and (num==(mao.size()-mao.size()/2-1))):
			if((num==(mao.size()-(mao.size()+1)/2))):
				valorY= -variacaoY
			posicaoInicial-= Vector2(variacaoX,valorY)
		else:
			posicaoInicial-= Vector2(variacaoX,0)
			valorR-=variacaoRotate
			valorY= -variacaoY

	
func receberCartaNaFrente():
	
	var retorno 
	for area in cursorMouse.get_overlapping_areas():
		if((area.is_in_group(Constante.GRUPO_CARTA))and area.ativado and area.is_in_group(Constante.GRUPO_CARTA_NA_MAO_JOGADOR)):
			retorno = area
			if(retorno == cardZoom):
				return retorno
			
	return retorno
		
func retornarCarta():
	for elemento in maoVisual.size():
		var dif = maoVisual[elemento].get_global_position()-posicaoMao[elemento]
		if((Ferramentas.positivo(dif.x)+Ferramentas.positivo(dif.y))> 10):
			zoomCarta(maoVisual[elemento],false)
		
		maoVisual[elemento].set_global_position(posicaoMao[elemento])
	
func moveu(carta):
	var moveu = false
	var novaPosicao = carta.get_global_position()
	
	if(Ferramentas.positivo(carta.posicaoRaiz.x - novaPosicao.x)>10):
		moveu = true
	if(Ferramentas.positivo(carta.posicaoRaiz.y - novaPosicao.y)>10):
		moveu = true
	
	return moveu
	

func _on_Timer_timeout():
	duploClik = false
	
		
	
