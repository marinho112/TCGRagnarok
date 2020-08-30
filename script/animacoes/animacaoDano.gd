extends "res://script/animacoes/animacao.gd"

var vel = 100
var timer = 0.6

func play(dono,listaAlvos = [],pausar = null,velo = 1.0):
	.play(dono,listaAlvos,4,velo)
	vel *= velo 
	timer *= velo
	
	
func setDano(dano):
	if(dano>=0):
		$Label.set_text("-"+str(dano))
	else:
		$Label.set_text("+"+str(dano))
		$Label.set("custom_colors/font_color","#47f416")
		
func _process(delta):
	
	if (timer<=0):
		set_visible(false)
		if(resolveHabilidades(dono.carta.dono.listaAoReceberDano,[],dono.carta.obj)):
			encerrar()
	else:
		var position = get_global_position()
		var movimento = Vector2(0.6,-1) * vel * delta
		var novaPosition = position+movimento
		set_global_position(novaPosition)	
		timer -= delta

