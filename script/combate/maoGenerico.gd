extends Node2D


var mao= []
var maoVisual = []
var posicaoMao = []
var pai 
var variacaoX=70
var variacaoY=8
var variacaoRotate = 1.5
var jogador 



func _ready():
	pass
	
	
func atualizaMao():
	pass

func zoomCarta(carta,booleano):
	if booleano:
		for elemento in maoVisual:
			elemento.setZoom(false)
			carta.set_z_index(0)
		if(carta != null):
			carta.setZoom(true)
			carta.set_z_index(10)
	else:
		carta.setZoom(false)
		carta.set_z_index(0)
