extends "res://script/animacoes/animacao.gd"

var ocilacao = 5
var tempo= 1
var contador =0
var morto = false

func play(dono,listaAlvos = [],pausar = null,velo = 1.0,sequencia=null):
	pai.get_node("controladorDeAnimacao").atualizarAoTermino=true
	.play(dono,listaAlvos,4,velo)

func executa(delta):
	executando=true
	if(contador<(tempo*velo)):
		var position = dono.posicaoJogo.get_global_position()
		var ajuste = Vector2(randi()%ocilacao,randi()%ocilacao)
		dono.set_global_position(position+ajuste)
	else:
		encerrar()
	
	contador+=delta
	
func encerrar():
	
	if(!morto):
		dono.set_visible(false)
		morto=true
	elif(dono.aoSairDeJogo(pai)):
		dono.terminar()
		.encerrar()
