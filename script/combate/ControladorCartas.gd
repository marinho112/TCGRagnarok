extends Node2D

#listas

var listaTimes =[]
var listaJogadores =[]

var cartaSelecionada
var cursorMouse 
var cursorMousePosition
var duploClick = false
var pai

func _ready():
	var listaPosicoes = []
	var pai=get_parent()
	set_process(true)

func _process(delta):
	
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
							cartaSelecionada = area
							cursorMousePosition = cursorMouse.get_global_position()


	if(Input.is_action_just_released("clicar")):
		duploClick = true
		$Timer.start()
		if(cartaSelecionada!=null):
			
			var menorArea = null
			var menorDiferenca
			#controlar cartas no campo.
			for area in cartaSelecionada.get_overlapping_areas():
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
							
							
					
			if(menorArea==null):
				positionAreaCarta(cartaSelecionada.posicaoJogo,cartaSelecionada)
			else:
				positionAreaCarta(menorArea,cartaSelecionada)
				
			cartaSelecionada=null
	else:
		if(cartaSelecionada!=null):
			var posicaoCarta = cartaSelecionada.get_global_position()
			var novaPosicao = cursorMouse.get_global_position()
			cartaSelecionada.set_global_position(posicaoCarta-cursorMousePosition+novaPosicao)
			cursorMousePosition=novaPosicao
		return


func positionAreaCarta(area,carta):
	
	var auxArea
	var auxCarta
	
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
