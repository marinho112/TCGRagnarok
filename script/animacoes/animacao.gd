extends Node2D

var pai
var dono
var listaAlvos = []
var velo = 1.0
var contadorHabilidade = 0
var controla
var executado=false
var executando=false

func _ready():
	add_to_group(Constante.GRUPO_ANIMACAO)
	

func play(dono,listaAlvos = [],pause = null,velo = 1.0,sequencia=null):
	self.dono=dono
	self.velo = velo
	self.listaAlvos = listaAlvos
	#set_process(true)
	controla = pai.get_node("controladorDeAnimacao")
	#executando=true
	if(pause != null):
		pai.pausar(pause)
		if(sequencia!=null):
			controla.adicionarAnimacaoSequencia(self,sequencia)
		else:	
			controla.adicionarAnimacao(self)
		#controla.ativado = true

	

func definirPai(novoPai):
	if(novoPai!= null):
		pai=novoPai
		pai.add_child(self)
		set_z_index(120)
		
func encerrar():
	#controla.listaAnimacoes.remove(controla.listaAnimacoes.find(self))
	pai.pausar(0)
	executado=true
	#set_process(false)
	#queue_free()

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
