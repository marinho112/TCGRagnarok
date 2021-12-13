extends "res://script/combate/maoGenerico.gd"



func _ready():
	add_to_group(Constante.GRUPO_AREA_MAO_OPONENTE)
	listaGrupos=[Constante.GRUPO_CARTA_NA_MAO_OPONENTE,Constante.GRUPO_CARTA_NA_MAO]
	pai= get_parent().get_parent()
	atualizaMao()

func atualizaMao():
	
	for item in maoVisual:
		item.queue_free()
	maoVisual=[]
	
	var tamanho = mao.size()
	var posicaoInicial = get_global_position()
	var par=false
	var meio = posicaoInicial.y
	var valorY= -variacaoY
	var valorR= variacaoRotate * int(tamanho/2)
	posicaoInicial-= Vector2(int(variacaoX/2)*tamanho,variacaoY*int(tamanho/2))
	var cartaNova
	
	var carta
	
	if(tamanho%2==0):
		par =  true
	
	for num in mao.size():
		carta = mao[num]
		cartaNova = ControladorCartas.criarCarta(carta,self,posicaoInicial)
		cartaNova.posicaoRaiz=posicaoInicial
		cartaNova.add_to_group(Constante.GRUPO_CARTA_NA_MAO_OPONENTE)
		cartaNova.add_to_group(Constante.GRUPO_CARTA_NA_MAO)
		posicaoMao.append(cartaNova.get_global_position())
		maoVisual.append(cartaNova)
		cartaNova.set_rotation(deg2rad(valorR+180))
		carta.obj=cartaNova
		valorR+=-variacaoRotate
		

		if!(par and (num==(mao.size()-mao.size()/2-1))):
			if((num==(mao.size()-(mao.size()+1)/2))):
				valorY= variacaoY
			posicaoInicial-= Vector2(-variacaoX,valorY)
		else:
			posicaoInicial-= Vector2(-variacaoX,0)
			valorR-=variacaoRotate
			valorY= variacaoY


func adicionaCartaMao(carta):
	.adicionaCartaMao(carta)
	#mao.append(carta)
	#maoVisual.append(ControladorCartas.criarCarta(carta,self,Vector2(0,0)))
	
	var tamanho = mao.size()
	var posicaoInicial = get_global_position()
	var par=false
	var meio = posicaoInicial.y
	var valorY= -variacaoY
	var valorR= variacaoRotate * int(tamanho/2)
	posicaoInicial-= Vector2(int(variacaoX/2)*tamanho,variacaoY*int(tamanho/2))
	
	if(tamanho%2==0):
		par =  true

	
	for num in maoVisual.size():
		carta = maoVisual[num]
		carta.set_global_position(posicaoInicial)
		carta.posicaoRaiz=posicaoInicial
		carta.add_to_group(Constante.GRUPO_CARTA_NA_MAO_OPONENTE)
		carta.add_to_group(Constante.GRUPO_CARTA_NA_MAO)
		posicaoMao.append(carta.get_global_position())
		carta.set_rotation(deg2rad(valorR+180))
		valorR+=-variacaoRotate
		if!(par and (num==(mao.size()-mao.size()/2-1))):
			if((num==(mao.size()-(mao.size()+1)/2))):
				valorY= variacaoY
			posicaoInicial-= Vector2(-variacaoX,valorY)
		else:
			posicaoInicial-= Vector2(-variacaoX,0)
			valorR-=variacaoRotate
			valorY= variacaoY
