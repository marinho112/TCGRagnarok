extends "res://script/animacoes/animacao.gd"

var preDano = preload("res://cenas/animacoes/animacaoDano.tscn")

func play(dono,listaAlvos = [],pausar = null,velo = 1.0):
	.play(dono,listaAlvos,2,velo)
	
	$AnimationPlayer.play("main",-1,velo)
	
func acabar():
	for alvo in listaAlvos:
		var novaAnimacao = preDano.instance()
		novaAnimacao.definirPai(get_parent())
		var posicao = alvo.get_node("coracao").get_global_position()
		novaAnimacao.set_global_position(posicao)
		var causado = dono.golpear(alvo)
		novaAnimacao.setDano(causado)
		novaAnimacao.play(dono,[alvo],null,velo)
	encerrar()
