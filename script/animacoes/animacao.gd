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


