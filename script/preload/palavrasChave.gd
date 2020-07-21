extends Node

func getPalavraChave(id,efeito,pai,val1):
	var retorno
	match id:
		1:
			retorno = AtaqueDistancia.new()
		2:
			retorno = Iniciativa.new()
		3:
			retorno = Ofensivo.new()
		4:
			retorno = Imovel.new()
		5:
			retorno = BemVindo.new()
		6:
			retorno = Coletar.new()
		7:
			retorno = Meditar.new()
	if ((efeito != null)and(efeito != 0)):
		retorno.efeito= Efeitos.getEfeito(efeito,pai)
	retorno.pai=pai
	retorno.val1 = val1
	return retorno

class palavraChave:
	
	var id
	var efeito
	var pai
	var val1

	func recebeNome():
		return Ferramentas.receberTexto("palavrasChave",id)
	
	func recebeNomeAlternativo():
		return Ferramentas.receberTexto("palavrasChave",id,2)
	
	func recebeDescricao():
		return Ferramentas.receberTexto("palavrasChave",id,1)

class AtaqueDistancia extends palavraChave:
	
	func _init():
		id=1

class Iniciativa extends palavraChave:
	
	func _init():
		id=2

class Ofensivo extends palavraChave:
	
	func _init():
		id=3
		
class Imovel extends palavraChave:
	
	func _init():
		id=4
		
class BemVindo extends palavraChave:
	
	func _init():
		id=5
		
class Coletar extends palavraChave:
	
	func _init():
		id=6
	
class Meditar extends palavraChave:
	
	func _init():
		id=7
		
	func recebeNome():
		var texto = .recebeNome()
		texto += " "+str(val1) 
		return texto
		
	func recebeDescricao():
		var texto = .recebeDescricao()
		texto = texto.replace("&1",str(val1))
		return texto
	
	
