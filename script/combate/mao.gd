extends "res://script/combate/maoGenerico.gd"


var ativado = true

var cursorMouse
var cartaSelecionada
var cursorMousePosition

var duploClik = false
var cartaDoZoom 

func _ready():
	add_to_group(Constante.GRUPO_AREA_MAO)
	pai= get_parent()
	mao = [ControlaDados.carregaCartaAleatoria(),ControlaDados.carregaCartaAleatoria(),ControlaDados.carregaCartaAleatoria(),ControlaDados.carregaCartaAleatoria(),ControlaDados.carregaCartaAleatoria()]
	atualizaMao()
	cursorMouse = pai.get_parent().get_node("Mouse")
	set_process(true)
	
	
func _process(delta):
	
	if (ativado):	
		
		if((cursorMouse!=null) and (cartaSelecionada==null)):
			
			if(Input.is_action_pressed("clicar")):
				var area = receberCartaNaFrente()
				if(area != null):
					selecionaCarta(area)
					cursorMousePosition = cursorMouse.get_global_position()
					
		if(Input.is_action_just_released("clicar")):
			var item = receberCartaNaFrente()
			if(item != null):
				if(duploClik):
					item.exibirCartas()
					zoomCarta(item,false)
				else:
					duploClik = true
					$Timer.start()
					if(item.zoom):
						cartaDoZoom = item
					else:
						zoomCarta(item,true)
				
			if(cartaSelecionada!=null):
				var cont =0
				for area in cursorMouse.get_overlapping_areas():
					if area.is_in_group(Constante.GRUPO_AREA_CARTA):
						cont+=1
				if cont>0:		
					jogar(cartaSelecionada)
				else:
					retornarCarta()
						
					
				selecionaCarta(null)
		else:
			if(cartaSelecionada!=null):
				var posicaoCarta = cartaSelecionada.get_global_position()
				var novaPosicao = cursorMouse.get_global_position()
				if(cartaSelecionada.zoom and moveu(cartaSelecionada)):
					zoomCarta(cartaSelecionada,false)
				cartaSelecionada.set_global_position(posicaoCarta-cursorMousePosition+novaPosicao)
				cursorMousePosition=novaPosicao
			return
	
func jogar(carta):
	if(jogador.ativado):
		var cartaLogica = carta.carta
		if(cartaLogica.tipo == Constante.CARTA_MONSTRO):
			cartaLogica.revelada=true
			var controlador = pai.get_node("ControladorCartas")
			var cartaNova = controlador.criarMonstro(cartaLogica)
			mao.remove(mao.find(cartaLogica))
			
			atualizaMao()
	else:
		retornarCarta()
		
func selecionaCarta(carta):
	
	if carta == null:
		pai.get_node("ControladorCartas").ativado = true
	else:
		pai.get_node("ControladorCartas").ativado = false
		carta.set_z_index(100)
	
	cartaSelecionada = carta
	
func atualizaMao():
	
	for item in maoVisual:
		item.queue_free()
	maoVisual=[]
	
	var tamanho = mao.size()
	var posicaoInicial = get_global_position()
	var par = false
	var meio = posicaoInicial.y
	var valorY= variacaoY
	var valorR= variacaoRotate * int(tamanho/2)
	posicaoInicial+= Vector2(int(variacaoX/2)*tamanho,variacaoY*int(tamanho/2))
	var cartaNova
	var carta
	
	if(tamanho%2==0):
		par =  true
	
	for num in mao.size():
		carta = mao[num]
		cartaNova = ControladorCartas.criarCarta(carta,self,posicaoInicial)
		cartaNova.posicaoRaiz=posicaoInicial
		cartaNova.add_to_group(Constante.GRUPO_CARTA_NA_MAO)
		posicaoMao.append(cartaNova.get_global_position())
		maoVisual.append(cartaNova)
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
		if((area.is_in_group(Constante.GRUPO_CARTA))and area.ativado and area.is_in_group(Constante.GRUPO_CARTA_NA_MAO)):
			retorno = area
			
			
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
	if(cartaDoZoom!=null):
		zoomCarta(cartaDoZoom,false)
		
	
