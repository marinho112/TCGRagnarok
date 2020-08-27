extends "res://script/animacoes/animacao.gd"

var preDano = preload("res://cenas/animacoes/animacaoDano.tscn")
var acabado
var cont=0
var contadorHabilidade=0

func play(dono,listaAlvos = [],pausar = null,velo = 1.0):
	.play(dono,listaAlvos,4,velo)
	$AnimationPlayer.play("main",-1,velo)

func _process(delta):
	
	if(acabado):
		if(cont < listaAlvos.size()):
			var alvo = listaAlvos[cont]
			if(resolveHabilidades(dono.carta.dono.listaAoGolpear,alvo.carta.dono.listaAoSerGolpeado,dono,alvo)):
				cont+=1
				var novaAnimacao = preDano.instance()
				novaAnimacao.definirPai(get_parent())
				var posicao = alvo.get_node("coracao").get_global_position()
				novaAnimacao.set_global_position(posicao)
				var causado = dono.golpear(alvo)
				novaAnimacao.setDano(causado)
				novaAnimacao.play(dono,[alvo],null,velo)
				
		else:
			acabado=false
			cont=0
			encerrar()
	
func acabar():
	acabado = true

func resolveHabilidades(listaJogador,listaOponente,carta=null,alvo=null):
	var qtdJogador = listaJogador.size() 
	var qtdOponente = listaOponente.size()
	if(contadorHabilidade<(qtdJogador+qtdOponente)):
		if(contadorHabilidade<qtdJogador):
			listaJogador[contadorHabilidade].ativar(carta,alvo)
		else:
			listaOponente[contadorHabilidade-qtdJogador].ativar(carta,alvo)
		contadorHabilidade+=1
		return false
	else:
		contadorHabilidade=0
		return true
