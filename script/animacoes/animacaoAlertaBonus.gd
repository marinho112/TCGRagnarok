extends "res://script/animacoes/animacao.gd"

var vel = 50
var timer = 0.8

func play(dono,listaAlvos = [],pausar = null,velo = 1.0):
	.play(dono,listaAlvos,4,velo)
	vel *= velo 
	timer *= velo
	dono.desenhaAtributos()
	
	
func setTexto(num,string,negativo=false):
	if(num!= null):
		var sinal = "+"
		if negativo:
			sinal="-"
		$Label.set_text(sinal+str(num)+" "+string)
	else:
		$Label.set_text(string)
	
func executa(delta):
	executando=true
	var position = get_global_position()
	var movimento = Vector2(0.6,-1) * vel * delta
	var novaPosition = position+movimento
	set_global_position(novaPosition)
	
	if (timer<=0):
		encerrar()
		
	timer -= delta
