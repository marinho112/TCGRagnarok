extends Node2D

var ativado = false
var pai
var numSelecao
var jogador
var listaPossibilidades
var tipoSelecao
var enviado = false
var obrigatorio = true
var listaCartas=[]
var listaSelecao=[]
var novaLista = []
var selecionador

func _ready():
	set_process(true)
	pai=get_parent()
	
func ativar():
	ativado = true
	pai.ativado=false
	pai.get_node("ControladorCartas").ativado = false
	pai.get_node("mao").ativado = false
	
func desativar():
	if (novaLista.size()==0):
		for item in listaSelecao:
			item.get_node("brilho").set_visible(false)
			novaLista.append(item.carta)
	if(selecionador.fimSelecao(novaLista)):
		for carta in listaCartas:
			carta.queue_free()
		ativado = false
		pai.ativado=true
		pai.get_node("ControladorCartas").ativado = true
		pai.get_node("mao").ativado = true
		
func _process(delta):
	if ativado:
		definirBtns(delta)
		if(!enviado):
			match tipoSelecao:
				Constante.TIPO_SELECAO_CAMPO:
					selecao(delta,Constante.GRUPO_CARTA_EM_CAMPO,jogador)
				Constante.TIPO_SELECAO_MONSTRO_CAMPO:
					selecao(delta,Constante.GRUPO_CARTA_REDUZIDA,jogador)
				Constante.TIPO_SELECAO_MAO:
					selecao(delta,Constante.GRUPO_CARTA_NA_MAO,jogador)
				Constante.TIPO_SELECAO_AREA_FLUTUANTE:
					selecao(delta,Constante.GRUPO_CARTA_FLUTUANTE,jogador)
		else:
			desativar()

func criarLista(listaCartas):
	var listaNova = []
	var tamanhoLista = listaCartas.size()
	var ajusteY=-100
	var xP =320
	var y=0
	
	var meio = (tamanhoLista/2)+(tamanhoLista%2)
	
	if(tamanhoLista>5):
		tamanhoLista=meio
		y=-200
		
	var x= -int(tamanhoLista/2)*xP
	if(tamanhoLista%2==0):
		x+=xP/2.0
		
	for i in listaCartas.size():
		if(i==meio):
			x= -int(tamanhoLista/2)*xP
			if(tamanhoLista%2==0):
				x+=xP/2.0
			y*=-1
			
		var posicao = Vector2(x,y+ajusteY)
		var item  = listaCartas[i]
		var cartaNova=ControladorCartas.criarCarta(item,self,posicao)
		cartaNova.set_z_index(1000)
		cartaNova.add_to_group(Constante.GRUPO_CARTA_FLUTUANTE)
		listaNova.append(cartaNova)
		x+=xP
	
	return listaNova
		
func definirBtns(delta):
	if(numSelecao!=null):
		var numItens = listaSelecao.size()
		var btn = pai.get_node("btnAzul")
		var btn2 = pai.get_node("btnVermelho")
		if(numItens<numSelecao):
			btn.estado=0
			btn.set_text(0,false)
		else:
			btn.estado=3
			btn.set_text(7,true)
		
		if(numItens<=0):
			btn2.set_text(8,true,true)
			btn2.estado = 2
		elif(obrigatorio):
			btn2.set_text(0,false,false)
		else:
			btn2.set_text(2,true,true)
			btn2.estado = 2

func selecao(delta,tipo,jogador):
	if Input.is_action_just_pressed("clicar"):
		var area = receberAreaMaisRelevante(pai.cursorMouse,tipo,jogador)
		if(area!=null):
			var posiArea = listaSelecao.find(area)
			if(posiArea==-1):
				if(listaSelecao.size()<numSelecao):
					listaSelecao.append(area)
					area.defineBrilho(true)
			else:
				listaSelecao.remove(posiArea)
				area.defineBrilho(false)
				
		
func prepararLista(numSelecao,selecionador,tipoSelecao,obrigatorio=true,jogador=null,listaCartas=[]):
	self.numSelecao = numSelecao
	self.selecionador=selecionador
	self.obrigatorio=obrigatorio
	self.tipoSelecao= tipoSelecao
	self.jogador = jogador
	if(tipoSelecao==Constante.TIPO_SELECAO_AREA_FLUTUANTE):
		self.listaCartas=criarLista(listaCartas)
	listaSelecao=[]
	novaLista=[]
	enviado = false
	ativar()
	
func cancelar():
	
	desativar()

func receberAreaMaisRelevante(cartaSelecionada,tipo,jogador):
	var lista = cartaSelecionada.get_overlapping_areas()
	var menorArea = null
	var menorDiferenca
	#controlar cartas no campo.
	for area in lista:
		print(jogador)
		if(area.is_in_group(tipo)):
			if((jogador!=null)and area.carta.dono == jogador):
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
