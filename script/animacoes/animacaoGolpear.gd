extends "res://script/animacoes/animacao.gd"

func play(dono,listaAlvos = [],pausar = null):
	.play(dono,listaAlvos,2)
	
	$AnimationPlayer.play("main")
	
func acabar():
	for alvo in listaAlvos:
		dono.carta.golpear(alvo.carta)
	encerrar()
