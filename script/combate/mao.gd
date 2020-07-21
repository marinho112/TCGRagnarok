extends Node2D


var mao= []
var pai = self
var variacaoX=80
var variacaoY=10
var variacaoRotate = 0.02

func _ready():
	mao = [ControlaDados.carregaCartaPorID(1),ControlaDados.carregaCartaPorID(1),ControlaDados.carregaCartaPorID(1),ControlaDados.carregaCartaPorID(1),ControlaDados.carregaCartaPorID(1),ControlaDados.carregaCartaPorID(1),ControlaDados.carregaCartaPorID(1)]
	atualizaMao()
	
func atualizaMao():
	
	var tamanho = mao.size()
	var posicaoInicial = get_global_position()
	var meio = posicaoInicial.y
	var valorY= variacaoY
	var valorR= variacaoRotate * int(tamanho/2)
	posicaoInicial+= Vector2(int(variacaoX/2)*tamanho,variacaoY*int(tamanho/2))
	var cartaNova
	
	for carta in mao:
		cartaNova = ControladorCartas.criarCarta(carta,pai,posicaoInicial)
		print(posicaoInicial)
		cartaNova.set_rotation(valorR)
		if(posicaoInicial.y<=meio):
			valorY= -variacaoY
			
		valorR-=variacaoRotate
			
		posicaoInicial-= Vector2(variacaoX,valorY)
