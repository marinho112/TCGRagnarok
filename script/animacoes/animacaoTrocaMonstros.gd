extends "res://script/animacoes/animacao.gd"

var origem
var destino
var cartaOrigem
var cartaDestino

func ativar(paraOrigem,paraDestino,pause = null,velo = 1.0):
	origem = paraOrigem
	cartaOrigem =paraOrigem.carta
	destino = paraDestino
	cartaDestino=paraDestino.carta
	if(origem.posicaoJogo==destino):
		return encerrar()
	
	play(paraOrigem,paraDestino,pause,velo)


func encerrar():
	pai.get_node('ControladorCartas').positionAreaCarta(destino,cartaOrigem)
	.encerrar()
