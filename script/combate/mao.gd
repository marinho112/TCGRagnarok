extends Node2D


var mao= []
var maoVisual = []
var posicaoMao = []
var pai 
var variacaoX=80
var variacaoY=10
var variacaoRotate = 0.02
var ativado = true

var cursorMouse
var cartaSelecionada
var cursorMousePosition

func _ready():
	add_to_group(Constante.GRUPO_AREA_MAO)
	pai= get_parent()
	mao = [ControlaDados.carregaCartaPorID(1),ControlaDados.carregaCartaPorID(1),ControlaDados.carregaCartaPorID(1),ControlaDados.carregaCartaPorID(1),ControlaDados.carregaCartaPorID(1),ControlaDados.carregaCartaPorID(1),ControlaDados.carregaCartaPorID(1)]
	atualizaMao()
	cursorMouse = pai.get_parent().get_node("Mouse")
	set_process(true)
	
	
func _process(delta):
	
	if ativado:	
		
		if((cursorMouse!=null) and (cartaSelecionada==null)):
			
			if(Input.is_action_pressed("clicar")):
				var area = receberCartaNaFrente()
				if(area != null):
					selecionaCarta(area)
					cursorMousePosition = cursorMouse.get_global_position()
	
	
		if(Input.is_action_just_released("clicar")):
			var item = receberCartaNaFrente()
			if(item != null):
				if(item.zoom):
					item.setZoom(false)
				else:
					zoomCarta(item)
				
			if(cartaSelecionada!=null):
				var cont =0
				for area in cursorMouse.get_overlapping_areas():
					if area.is_in_group(Constante.GRUPO_AREA_CARTA):
						cont+=1
				if cont>0:		
					jogar(cartaSelecionada)
				else:
					for elemento in maoVisual.size():
						var dif = maoVisual[elemento].get_global_position()-posicaoMao[elemento]
						if((Ferramentas.positivo(dif.x)+Ferramentas.positivo(dif.y))> 50):
							maoVisual[elemento].setZoom(false)
						maoVisual[elemento].set_global_position(posicaoMao[elemento])
						
					
				selecionaCarta(null)
		else:
			if(cartaSelecionada!=null):
				var posicaoCarta = cartaSelecionada.get_global_position()
				var novaPosicao = cursorMouse.get_global_position()
				if(cartaSelecionada.zoom):
					cartaSelecionada.setZoom(false)
				cartaSelecionada.set_global_position(posicaoCarta-cursorMousePosition+novaPosicao)
				cursorMousePosition=novaPosicao
			return
	
func jogar(carta):
	
	if(carta.carta.tipo == Constante.CARTA_MONSTRO):
		var controlador = pai.get_node("ControladorCartas")
		var cartaNova = controlador.criarMonstro(carta.carta)
		mao.remove(mao.find(carta.carta))
		atualizaMao()
	
func selecionaCarta(carta):
	
	if carta == null:
		pai.get_node("ControladorCartas").ativado = true
		cartaSelecionada.set_z_index(0)
	else:
		pai.get_node("ControladorCartas").ativado = false
		carta.set_z_index(10)
	
	cartaSelecionada = carta
	
func atualizaMao():
	
	for item in maoVisual:
		item.queue_free()
	maoVisual=[]
	
	var tamanho = mao.size()
	var posicaoInicial = get_global_position()
	var meio = posicaoInicial.y
	var valorY= variacaoY
	var valorR= variacaoRotate * int(tamanho/2)
	posicaoInicial+= Vector2(int(variacaoX/2)*tamanho,variacaoY*int(tamanho/2))
	var cartaNova
	
	for carta in mao:
		cartaNova = ControladorCartas.criarCarta(carta,self,posicaoInicial)
		cartaNova.add_to_group(Constante.GRUPO_CARTA_NA_MAO)
		posicaoMao.append(cartaNova.get_global_position())
		maoVisual.append(cartaNova)
		cartaNova.set_rotation(valorR)
		if(posicaoInicial.y<=meio):
			valorY= -variacaoY
			
		valorR-=variacaoRotate
			
		posicaoInicial-= Vector2(variacaoX,valorY)

func zoomCarta(carta):
	for elemento in maoVisual:
		elemento.setZoom(false)
	carta.setZoom(true)

func receberCartaNaFrente():
	
	var retorno 
	for area in cursorMouse.get_overlapping_areas():
		if((area.is_in_group(Constante.GRUPO_CARTA))and area.ativado and area.is_in_group(Constante.GRUPO_CARTA_NA_MAO)):
			retorno = area
			
	return retorno
		
