extends Node2D

var pai
var dono
var listaAlvos = []
var velo = 1.0
var contadorHabilidade = 0

func _ready():
	add_to_group(Constante.GRUPO_ANIMACAO)
	

func play(dono,listaAlvos = [],pause = null,velo = 1.0):
	self.dono=dono
	self.velo = velo
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
	set_process(false)
	queue_free()

func resolveHabilidades(listaJogador,listaOponente,carta=null,alvo=null):
	var qtdJogador = listaJogador.size() 
	var qtdOponente = listaOponente.size()
	
	if(contadorHabilidade<(qtdJogador+qtdOponente)):
		if(contadorHabilidade<qtdJogador):
			listaJogador[contadorHabilidade].ativar(carta,alvo)
			
		else:
			listaOponente[contadorHabilidade-qtdJogador].ativar(carta,alvo)
		contadorHabilidade+=1
		return false
	else:
		contadorHabilidade=0
		return true
