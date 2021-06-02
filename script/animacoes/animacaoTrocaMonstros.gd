extends "res://script/animacoes/animacao.gd"

var origem
var destino
var cartaOrigem
var cartaDestino
var destinoOrigem
var destinoDestino

var indiceZ

var vel = 5

func play(paraOrigem,paraDestino=null,pause = null,velo = 1.0,sequencia=null):
	origem = paraOrigem
	cartaOrigem =paraOrigem.carta
	destino = paraDestino
	cartaDestino=paraDestino.carta
	destinoOrigem = origem.get_global_position()
	destinoDestino =destino.get_global_position()
	vel *= velo
	indiceZ= cartaOrigem.get_z_index()
	cartaOrigem.set_z_index(100)
	.play(paraOrigem,[paraDestino],pause,velo)


func encerrar():
	cartaOrigem.set_z_index(indiceZ)
	pai.get_node('ControladorCartas').positionAreaCarta(destino,cartaOrigem)
	.encerrar()

func executa(delta):
	executando=true
	if(moverCarta(cartaOrigem,destino,delta)):
		encerrar()
	
func moverCarta(carta,destino,delta):
	var diferenca = Ferramentas.calcularDistancia(carta,destino)
	if((diferenca.x+diferenca.y)>(vel)):
		var position = carta.get_global_position()
		var pDestino = destino.get_global_position()
		var vetorX = 1
		var vetorY =1
		if(pDestino.x<position.x):
			vetorX= -1
			pDestino.x*=-1
		if(pDestino.y<position.y):
			vetorY= -1
			pDestino.y*=-1
		
		var soma= diferenca.x+diferenca.y
		vetorX *= diferenca.x/soma
		vetorY *= diferenca.y/soma  
		carta.set_global_position(position+(Vector2(vetorX,vetorY)*delta*(vel*(soma)+100)))
		return false
	return true
