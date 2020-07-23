extends "res://script/combate/maoGenerico.gd"



func _ready():
	add_to_group(Constante.GRUPO_AREA_MAO_OPONENTE)
	pai= get_parent()
	mao = [ControlaDados.carregaCartaPorID(1),ControlaDados.carregaCartaPorID(1),ControlaDados.carregaCartaPorID(1),ControlaDados.carregaCartaPorID(1),ControlaDados.carregaCartaPorID(1),ControlaDados.carregaCartaPorID(1),ControlaDados.carregaCartaPorID(1)]
	atualizaMao()

func atualizaMao():
	
	for item in maoVisual:
		item.queue_free()
	maoVisual=[]
	
	var tamanho = mao.size()
	var posicaoInicial = get_global_position()
	var meio = posicaoInicial.y
	var valorY= -variacaoY
	var valorR= variacaoRotate * int(tamanho/2)
	posicaoInicial-= Vector2(int(variacaoX/2)*tamanho,variacaoY*int(tamanho/2))
	var cartaNova
	
	for carta in mao:
		cartaNova = ControladorCartas.criarCarta(carta,self,posicaoInicial)
		cartaNova.posicaoRaiz=posicaoInicial
		cartaNova.add_to_group(Constante.GRUPO_CARTA_NA_MAO_OPONENTE)
		posicaoMao.append(cartaNova.get_global_position())
		maoVisual.append(cartaNova)
		cartaNova.set_rotation(deg2rad(valorR+180))
		if(posicaoInicial.y>=meio):
			valorY= variacaoY
			
		valorR+=-variacaoRotate
			
		posicaoInicial-= Vector2(-variacaoX,valorY)
