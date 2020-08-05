extends Node2D


var ativado = false
var listaAnimacoes = []

func _ready():
	set_process(true)
	
func _process(delta):
	if ativado:
		if (listaAnimacoes.size() == 0):
			ativado = false
			get_parent().pausar(0)


func ativar(animacao = null):
	ativado = true
	if(animacao != null):
		if(animacao.is_in_group(Constante.GRUPO_ANIMACAO)):
			listaAnimacoes.append(animacao)
		else:
			ativado = false
