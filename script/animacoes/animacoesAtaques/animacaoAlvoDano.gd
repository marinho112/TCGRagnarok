extends "res://script/animacoes/animacao.gd"

var cont = 0
var timer = 0.2
var frame = 0

func executa(delta):
	executando=true
	cont+=delta
	if(cont>timer):
		cont=0
		frame+=1
		if(frame>2):
			encerrar()
		else:
			$AnimatedSprite.set_frame(frame)
			
			
			
func encerrar():
	var alvo=listaAlvos[0]
	var animacao= load("res://cenas/animacoes/animacaoDano.tscn").instance()
	animacao.definirPai(pai)
	var posicao = alvo.get_node("coracao").get_global_position()
	animacao.set_global_position(posicao)
	var causado = dono.golpear(alvo)
	animacao.setDano(causado)
	animacao.play(dono,[alvo],null,1)
	.encerrar()
