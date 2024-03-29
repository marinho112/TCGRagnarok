extends Node2D

#listas

var listaTimes =[]
var listaJogadores =[]
var jogador 

var ativado = true
var interacaoAvancada=true
var defesa = false
var podeJogar=false
var cartaSelecionada = null
var cursorMouse 
var cursorMousePosition
var duploClick = false
var pai

func _ready():
	
	pai=get_parent().get_parent()
	cursorMouse = pai.get_parent().get_node("Mouse")
	set_process(true)
	
func _process(delta):
	if (ativado and jogador.ativado and (pai.get_node("controladorMao/mao").cartaSelecionada==null) and (!pai.get_node("controladorCampo/listaExibicaoCartas").ativado)):
		if((cursorMouse!=null) and (cartaSelecionada==null)):
			if(Input.is_action_pressed("clicar")):
				for area in cursorMouse.get_overlapping_areas():
					if((area.is_in_group(Constante.GRUPO_CARTA))and area.ativado and area.is_in_group(Constante.GRUPO_CARTA_EM_CAMPO) and !area.is_in_group(Constante.GRUPO_PERSONAGEM)):
						if(duploClick):
							area.setZoom(!area.zoom)
							duploClick=false
						elif((!defesa)or(area.posicaoJogo.is_in_group(Constante.GRUPO_AREA_CARTA_DEFESA))):	
							if(!area.zoom):
								selecionaCarta(area)
								cursorMousePosition = cursorMouse.get_global_position()
			if(Input.is_action_just_released("clicarDireito")):
				for area in cursorMouse.get_overlapping_areas():
					if((area.is_in_group(Constante.GRUPO_CARTA))and area.ativado and area.is_in_group(Constante.GRUPO_CARTA_EM_CAMPO)):
						if(interacaoAvancada):
							interacaoAvancada=false
							area.morre()
	
		if(Input.is_action_just_released("clicar")):
			duploClick = true
			$Timer.start()
			
			if(cartaSelecionada!=null):
				
				var menorArea = receberAreaMaisRelevante(cartaSelecionada)
			
				if(menorArea==null):
					positionAreaCarta(cartaSelecionada.posicaoJogo,cartaSelecionada)
				else:
					positionAreaCarta(menorArea,cartaSelecionada)
					
				selecionaCarta(null)
		else:
			if(cartaSelecionada!=null):
				var posicaoCarta = cartaSelecionada.get_global_position()
				var novaPosicao = cursorMouse.get_global_position()
				cartaSelecionada.set_global_position(posicaoCarta-cursorMousePosition+novaPosicao)
				cursorMousePosition=novaPosicao
			return

func receberAreaMaisRelevante(cartaSelecionada):
	var lista = cartaSelecionada.get_overlapping_areas()
	var menorArea = null
	var menorDiferenca
	#controlar cartas no campo.
	for area in lista:
		if(area.is_in_group(Constante.GRUPO_AREA_CARTA)):
			
			if(menorArea==null):
				menorArea=area
				var posicao = area.get_global_position() - cartaSelecionada.get_global_position()
				menorDiferenca = Ferramentas.positivo(posicao.x)+Ferramentas.positivo(posicao.y)
			else:
				var posicao = area.get_global_position() - cartaSelecionada.get_global_position()
				if((Ferramentas.positivo(posicao.x)+Ferramentas.positivo(posicao.y))<menorDiferenca):

					menorDiferenca = Ferramentas.positivo(posicao.x)+Ferramentas.positivo(posicao.y)
					menorArea=area
					
	return menorArea

func criarMonstro(carta,jogador):
	var area = retornarArea(jogador)
	if(area!=null):
		var cartaNova = ControladorCartas.criarCartaMonstro(carta,pai,Vector2(0,0),true)
		cartaNova.add_to_group(Constante.GRUPO_CARTA_EM_CAMPO)
		positionAreaCarta(area,cartaNova)
		return cartaNova
	else:
		return null
		
func retornarArea(jogador,val=2):
	
	var areas 
	if((val==0) or val>1):
		areas= pai.get_node("controladorCampo").retornaListaAreas((jogador.time+1),2)
		
		for area in areas:
			if area.carta == null:
				return area
	
	if(val>0):	
		areas = pai.get_node("controladorCampo").retornaListaAreas((jogador.time+1),1)
		
		for area in areas:
			if area.carta == null:
				return area
				
	return null

func positionAreaCarta(area,carta,livre=false):
	
	var auxArea
	var auxCarta
	var areaJogador=(carta.carta.dono != area.retornaDono())
	var livrePraDefesa=(defesa and(!area.is_in_group(Constante.GRUPO_AREA_CARTA_DEFESA)))
	var indisponivel=(!podeJogar and !livre)
	if(areaJogador or livrePraDefesa or indisponivel):
		area= carta.posicaoJogo
	if(area!=null):
		if(area.carta != null):
			if(area.carta.imovel):
				area = carta.posicaoJogo
	
	if(carta!=null):
		if(carta.imovel):
			area = carta.posicaoJogo
	
	if(area!=null):
		auxCarta= area.carta
		area.carta = carta
	if(carta!=null):
		auxArea = carta.posicaoJogo
		carta.posicaoJogo = area
		carta.set_global_position(area.get_global_position())
		var escala = (area.get_parent().get_scale()) * area.get_parent().get_parent().get_scale()
		carta.set_scale(escala)
		
	if(auxArea!=null):
		auxArea.carta = auxCarta
	if(auxCarta!=null):
		auxCarta.posicaoJogo = auxArea
		if(auxArea!=null):
			auxCarta.set_global_position(auxArea.get_global_position())
			var escala = (auxArea.get_parent().get_scale()) * auxArea.get_parent().get_parent().get_scale()
			auxCarta.set_scale(escala)

func animacaoTrocaDeCartas(area,carta):
	
	if((area==carta.posicaoJogo)or (area==null) or (carta == null)):
		return positionAreaCarta(area,carta)
	var animacao=load("res://cenas/animacoes/animacaoTrocaMonstros.tscn").instance()
	animacao.definirPai(get_parent().get_parent())
	animacao.play(carta.posicaoJogo,area,5)
	

func _on_Timer_timeout():
	duploClick=false

func selecionaCarta(carta):
	
	if carta == null:
		pai.get_node("controladorMao/mao").ativado = true
		cartaSelecionada.set_z_index(0)
	else:
		pai.get_node("controladorMao/mao").ativado = false
		carta.set_z_index(10)
	
	cartaSelecionada = carta


func recebeAreaVazia(area):
	for item in area.get_children():
		if(item.is_in_group(Constante.GRUPO_AREA_CARTA)):
			if(item.carta== null):
				return item
	return null
	

func recebeAreaCartaMovel(area):
	for item in area.get_children():
		if(item.is_in_group(Constante.GRUPO_AREA_CARTA)):
			if(item.carta!= null):
				if(item.carta.carta.temPalavraChave(4)):
					pass
				else:
					return item
	return null
