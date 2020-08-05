extends Node2D

var pai
var dono
var listaAlvos = []

func _ready():
	add_to_group(Constante.GRUPO_ANIMACAO)
	

func play(dono,listaAlvos = [],pause = null):
	self.dono=dono
	self.listaAlvos = listaAlvos
	set_process(true)
	var controla = pai.get_node("controladorAnimacao")
	if(pause != null):
		pai.pausar(pause)
		controla.listaAnimacoes.append(self)
		controla.ativado = true

	

func definirPai(novoPai):
	if(novoPai!= null):
		pai=novoPai
		pai.add_child(self)
		set_z_index(120)
		
func encerrar():
	var controla = pai.get_node("controladorAnimacao")
	controla.listaAnimacoes.remove(controla.listaAnimacoes.find(self))
	queue_free()
