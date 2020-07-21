extends Node

func receberTexto(arqui,linha,coluna=0):
	var arquivo = File.new()
	#var erro = arquivo.open("res://dados/teste.data",File.WRITE)
	var local = "res://Idiomas/" + VariaveisGlobais.idioma +"/"+arqui+".data"
	
	var erro = arquivo.open(local,File.READ)
	
	if not erro:
		var conteudo = arquivo.get_as_text()
		var cortado = conteudo.split("¶")
		var valor = 2
		if(linha>9):
			valor+=1
		if(linha>99):
			valor+=1
		if(linha>999):
			valor+=1
		var texto = removeInicioInvalido(cortado[linha])
		var temp = removeInicioInvalido(texto.right(valor))
		var cortado2 = temp.split("§")
		return cortado2[coluna]
	
	return "ERROR"
	
func removeInicioInvalido(string):
	while((string!="")and((string[0]==" ") or (string[0]=="	") or (string[0]=="\n"))):
		string = string.right(1)
	return string

func positivo (num):
	
	if(num<0):
		num *= -1
	return num
