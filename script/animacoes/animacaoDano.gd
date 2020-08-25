extends "res://script/animacoes/animacao.gd"

var vel = 100
var timer = 0.6

func play(dono,listaAlvos = [],pausar = null,velo = 1.0):
	.play(dono,listaAlvos,4,velo)
	vel *= velo 
	timer *= velo
	
func setDano(dano):
	$Label.set_text("-"+str(dano))
	
func _process(delta):
	var position = get_global_position()
	var movimento = Vector2(0.6,-1) * vel * delta
	var novaPosition = position+movimento
	set_global_position(novaPosition)
	
	if (timer<=0):
		encerrar()
		
	timer -= delta

