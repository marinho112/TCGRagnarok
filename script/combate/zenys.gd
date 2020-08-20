extends Node2D

var zeny=0
var zenyTotal = 10
var listaObjetos = []
var preMoeda = preload("res://cenas/elementos/moeda.tscn")
var jogador

func _ready():
	desenhar()
	pass # Replace with function body.


func defineZeny(total,atual=0):
	zeny = atual
	zenyTotal = total
	desenhar()
	
func atualizarZeny():
	zeny = jogador.zeny
	zenyTotal = jogador.maxZeny
	desenhar()
	
func desenhar():
	limparLista()
	var x= 0
	var y= 0
	for z in 10:
		x+=(z)
		y+=2
		if(z>5):
			x-=1
			y-=3
		var moeda = preMoeda.instance()
		add_child(moeda)
		var position
		if(jogador != null):
			if(jogador.time==1):
				position= Vector2((((2*z)+(x*3))),-((z*32)-x+y))
			else:
				position = Vector2((((2*z)+(x*3))),(z*32)-x+y)
			moeda.set_position(position)
		if (z >= zenyTotal):
			moeda.get_node("imagem").set_visible(false)
		if(zeny <= z):
			moeda.definirGasta(true)
		listaObjetos.append(moeda)

func limparLista():
	for item in listaObjetos:
		item.queue_free()
	listaObjetos = []
	
func setJogador(valor):
	jogador=valor
	desenhar()
