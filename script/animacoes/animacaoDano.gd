extends "res://script/animacoes/animacao.gd"

var vel = 100
var timer = 0.6

func _ready():
	add_to_group(Constante.GRUPO_ANIMACAO_DANO)

func play(dono,listaAlvos = [],pausar = 4,velo = 1.0,sequencia=null):
	.play(dono,listaAlvos,pausar,velo)
	vel *= velo 
	timer *= velo
	
	
func setDano(dano):
	if(dano>=0):
		$Label.set_text("-"+str(dano))
	else:
		$Label.set_text("+"+str(dano))
		$Label.set("custom_colors/font_color","#47f416")
		
func executa(delta):
	executando=true
	if (timer<=0):
		set_visible(false)
		encerrar()
	else:
		var position = get_global_position()
		var movimento = Vector2(0.6,-1) * vel * delta
		var novaPosition = position+movimento
		set_global_position(novaPosition)	
		timer -= delta

func encerrar():
	.encerrar()

