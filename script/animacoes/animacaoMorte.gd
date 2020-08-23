extends "res://script/animacoes/animacao.gd"

var ocilacao = 5
var tempo= 1
var contador =0

func _process(delta):
	
	if(contador<(tempo*velo)):
		var position = dono.posicaoJogo.get_global_position()
		var ajuste = Vector2(randi()%ocilacao,randi()%ocilacao)
		dono.set_global_position(position+ajuste)
	else:
		encerrar()
	
	contador+=delta
	
func encerrar():
	dono.queue_free()
	.encerrar()
