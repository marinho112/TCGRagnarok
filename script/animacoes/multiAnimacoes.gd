extends "res://script/animacoes/animacao.gd"

func play(dono,listaAlvos = [],pause = null,velo = 1.0,sequencia=null):
	.play(dono,listaAlvos,pause,velo,sequencia)

func executa(delta):
	#print(listaAlvos)
	var terminos = 0
	for item in listaAlvos:
		if(!item.executado):
			item.executa(delta)
		else:
			terminos+=1
	if(terminos>=listaAlvos.size()):
		for item in listaAlvos:
			item.queue_free()
		encerrar()	
