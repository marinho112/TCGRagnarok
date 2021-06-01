extends Node2D


var ativado = false
var listaAnimacoes = []
var listaAnimacaoMorte=[]
var atualizarAoTermino=false

func _ready():
	set_process(true)
	
func _process(delta):
	if ativado:
		if (listaAnimacoes.size() == 0):
			if(atualizarAoTermino):
				get_parent().atualizaTodasCartas()
				atualizarAoTermino=false
			ativado = false
			get_parent().pausar(0)

func estaAnimando():
	if((listaAnimacoes.size()==0)and(!atualizarAoTermino)):
		return false
	return true
	
func ativar(animacao = null):
	ativado = true
	if(animacao != null):
		if(animacao.is_in_group(Constante.GRUPO_ANIMACAO)):
			listaAnimacoes.append(animacao)
		else:
			ativado = false
