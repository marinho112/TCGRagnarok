extends Node2D

var listaCartas
var listaCartasCriar
var pai
var larguraCarta=290
var alturaCarta=370
var escala=1
var espaco=20
# vp
var qtd
var novoTamanho
var preItem=preload("res://cenas/ferramentas/ItemScrollCards.tscn")


func prepara(listaCartas,listaCartasCriar,pai):
	#vp=$Fundo/ScrollContainer/HBoxContainer/ViewportContainer/Viewport
	qtd = listaCartasCriar.size()
	calcularTamanho()
	criarListaCards(listaCartas,listaCartasCriar,pai)
	
	

func criarListaCards(listaCartas,listaCartasCriar,pai):
	self.listaCartas=listaCartas
	self.listaCartasCriar=listaCartasCriar
	self.pai=pai
	
	var xInicial=0
	var variacaoX=(espaco*2)+larguraCarta
	var posicaoY=((alturaCarta/2)+espaco)*escala
	for i in qtd:
		var logicCard=listaCartasCriar[i]
		logicCard.revelada=true
		#var posicaoX=((-1*(xInicial-(((larguraCarta/2)+(espaco*1.5)))))+(variacaoX*i))*escala
		#var position=Vector2(posicaoX,posicaoY)
		var item=preItem.instance()
		item.get_node("Viewport/GuardaCarta").add_to_group(Constante.GRUPO_AREA_FLUTUANTE)
		#print(item.get_node("Viewport/GuardaCarta"))
		#print(item.get_node("Viewport/GuardaCarta").is_in_group(Constante.GRUPO_AREA_FLUTUANTE))
		var carta = ControladorCartas.criarCarta(logicCard,item.get_node("Viewport/GuardaCarta"),null)
		item.get_node("Viewport/GuardaCarta").add_child(carta)
		carta.add_to_group(Constante.GRUPO_CARTA_FLUTUANTE)
		#carta.set_position(position)
		item.set_scale(Vector2(escala,escala))
		$Fundo/ScrollContainer/HBoxContainer.add_child(item)
		#item.set_z_index(100)
		listaCartas.append(item)

func calcularTamanho():
	var x=((larguraCarta+(espaco)))
	var y=(alturaCarta+((espaco*2)))
	var newX=(x*qtd)
	#vp.set_size(Vector2(newX,y)*escala)
	if(qtd>5):
		newX=(x*5)
	defineTamanho(newX,y)
	
func defineTamanho(x,y):
	var vector=Vector2(x,y)*escala
	var tamanhoFundo = $Fundo.rect_size
	var scale=vector/tamanhoFundo
	novoTamanho = tamanhoFundo*scale
	var tamanhoBorda = 20
	var vectorTamanho=Vector2(tamanhoBorda,tamanhoBorda)
	$Fundo.rect_size=novoTamanho
	$Fundo/ScrollContainer.rect_size=novoTamanho
	$Borda.rect_size=novoTamanho+vectorTamanho
	$Fundo.rect_position=(vectorTamanho/2.0)
	#set_scale(scale)
	set_global_position((-1*$Borda.rect_size)/2)
	
