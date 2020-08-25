extends Node2D

var ativado = true
var mao= []
var maoVisual = []
var posicaoMao = []
var pai 
var variacaoX=70
var variacaoY=8
var variacaoRotate = 1.5
var jogador 
var cardZoom 


func definirJogador(parametro):
	jogador = parametro
	mao = parametro.listaMao
	atualizaMao()
	
func atualizaMao():
	pass

func zoomCarta(carta,booleano):
	
	if booleano:
		cardZoom = carta
		for elemento in maoVisual:
			elemento.setZoom(false)
		if(carta != null):
			carta.setZoom(true)
			cardZoom.set_z_index(100)
	else:
		if(carta.zoom):
			cardZoom.set_z_index(0)
			carta.setZoom(false)
			cardZoom = null
