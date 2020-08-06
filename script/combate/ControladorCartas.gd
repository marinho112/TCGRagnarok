extends Node2D

#listas

var listaTimes =[]
var listaJogadores =[]
var jogador 

var ativado = true
var cartaSelecionada
var cursorMouse 
var cursorMousePosition
var duploClick = false
var pai

func _ready():
	
	pai=get_parent()
	cursorMouse = pai.get_parent().get_node("Mouse")
	set_process(true)

func _process(delta):
	if (ativado and jogador.ativado):
		if((cursorMouse!=null) and (cartaSelecionada==null)):
			if(Input.is_action_pressed("clicar")):
				var passa= false
				for area in cursorMouse.get_overlapping_areas():
					if((area.is_in_group(Constante.GRUPO_CARTA))and area.ativado and area.is_in_group(Constante.GRUPO_CARTA_EM_CAMPO)):
						if(duploClick):
							area.setZoom(!area.zoom)
							duploClick=false
						else:	
							if(!area.zoom):
								selecionaCarta(area)
								cursorMousePosition = cursorMouse.get_global_position()
	
	
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

func criarMonstro(carta):
	var cartaNova = ControladorCartas.criarCartaMonstro(carta,pai,Vector2(0,0),true)
	cartaNova.add_to_group(Constante.GRUPO_CARTA_EM_CAMPO)
	var areas = pai.retornaListaAreas(1,2)
	
	for area in areas:
		if area.carta == null:
			positionAreaCarta(area,cartaNova)
			return cartaNova
		
	areas = pai.retornaListaAreas(1,1)
	
	for area in areas:
		if area.carta == null:
			positionAreaCarta(area,cartaNova)
			return cartaNova
	
	return cartaNova

func positionAreaCarta(area,carta):
	
	var auxArea
	var auxCarta
	
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
	
func _on_Timer_timeout():
	duploClick=false

func selecionaCarta(carta):
	
	if carta == null:
		pai.get_node("mao").ativado = true
		cartaSelecionada.set_z_index(0)
	else:
		pai.get_node("mao").ativado = false
		carta.set_z_index(10)
	
	cartaSelecionada = carta
