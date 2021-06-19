extends "res://script/animacoes/animacao.gd"

var cont = 0
var alvo
var cura
var propriedade

func executa(delta):
	if(executando==false):
		alvo = listaAlvos[0]
		if(ClassesCartas.verificaLogicoObjeto(alvo) == Constante.LOGI_CARTA):
			alvo=alvo.obj
		if(ClassesCartas.verificaLogicoObjeto(dono) == Constante.LOGI_CARTA):
			dono=dono.obj
		var posicao = alvo.get_global_position()
		self.set_global_position(posicao)
		executando=true
		$AnimationPlayer.play("cura")

func encerrar():
	var animacao= load("res://cenas/animacoes/animacaoDano.tscn").instance()
	animacao.definirPai(pai)
	var posicao = alvo.get_node("coracao").get_global_position()
	animacao.set_global_position(posicao)
	var curado = -1* alvo.carta.curar(cura)
	animacao.setDano(curado)
	animacao.play(dono,[alvo],-1,1,1)
	.encerrar()

func clone():
	var dup = .duplicate()
	dup.cura=cura
	return dup
