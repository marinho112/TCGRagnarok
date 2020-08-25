extends "res://script/animacoes/animacao.gd"

var ocilacao = 5
var tempo= 1
var contador =0

func play(dono,listaAlvos = [],pausar = null,velo = 1.0):
	pai.get_node("controladorAnimacao").atualizarAoTermino=true
	.play(dono,listaAlvos,4,velo)

func _process(delta):
	
	if(contador<(tempo*velo)):
		var position = dono.posicaoJogo.get_global_position()
		var ajuste = Vector2(randi()%ocilacao,randi()%ocilacao)
		dono.set_global_position(position+ajuste)
	else:
		encerrar()
	
	contador+=delta
	
func encerrar():
	var listaDono = dono.carta.listaEfeitoMorrer+pai.jogador.listaAoMorrer
	if(pai.resolveHabilidades(listaDono,pai.oponente.listaAoMorrer)):
		dono.queue_free()
		.encerrar()
