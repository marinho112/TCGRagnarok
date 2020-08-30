extends "res://script/animacoes/animacao.gd"

var cartaVelha
var cartaNova
var transformado = false
var efeitosProntos = false
var sizeInicial
var cimaBaixo=true
var time = true
var variacao=0.2
var cont=0
var final=1

func transformarCarta(carta,idNovaCarta):
	cartaVelha=carta
	cartaNova=idNovaCarta
	sizeInicial= cartaVelha.get_scale()
	
	play(cartaVelha,[],4)
	
func _process(delta):

	if transformado:
		if(efeitosProntos):
			pai.limparListaEfeitos(cartaVelha.carta.dono.listaAoReceberDano)
			var alerta = load("res://cenas/animacoes/animacaoAlertaBonus.tscn").instance()
			alerta.definirPai(pai)
			alerta.setTexto(null,"Transformado!")
			alerta.set_global_position(cartaVelha.get_global_position())
			alerta.play(dono)
			encerrar()
		elif(cartaVelha.transformar(cartaNova)):
			efeitosProntos=true
	else:
		if(time):
			if(cimaBaixo):
				cartaVelha.set_scale(sizeInicial*(1-variacao))
			else:
				cartaVelha.set_scale(sizeInicial*(1+variacao))
			if(cont>=1):
				transformado=true
				cartaVelha.set_scale(sizeInicial)
			time = false
			cimaBaixo=!cimaBaixo
			cont+=0.1
			$Timer.start()
			

func _on_Timer_timeout():
	time = true
	
