extends "res://script/animacoes/animacao.gd"

var cont = 0
var timer = 0.3
var frame = 0
var alvo
var dano
var propriedade


func _ready():
	add_to_group(Constante.GRUPO_SELECIONA_DANO)

func executa(delta):
	if(executando==false):
		alvo = listaAlvos[0]
		if(Ferramentas.verificaLogicoObjeto(alvo) == Constante.LOGI_CARTA):
			alvo=alvo.obj
		if(Ferramentas.verificaLogicoObjeto(dono) == Constante.LOGI_CARTA):
			dono=dono.obj
		var posicao = alvo.get_global_position()
		self.set_global_position(posicao)
		executando=true
	cont+=delta
	if(cont>timer):
		cont=0
		frame+=1
		if(frame>2):
			encerrar()
		else:
			$AnimatedSprite.set_frame(frame)
			
			
			
func encerrar():
	var animacao= load("res://cenas/animacoes/animacaoDano.tscn").instance()
	animacao.definirPai(pai)
	var posicao = alvo.get_node("coracao").get_global_position()
	animacao.set_global_position(posicao)
	var causado = dono.causarDano(alvo,dano,propriedade)
	animacao.setDano(causado)
	animacao.play(dono,[alvo],-1,1,1)
	.encerrar()

func clone():
	var dup = .duplicate()
	dup.dano=dano
	return dup
