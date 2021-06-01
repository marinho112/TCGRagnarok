extends "res://script/animacoes/animacao.gd"

func executa(delta):
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
