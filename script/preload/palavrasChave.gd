extends Node

func getPalavraChave(id,efeito,pai):
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
	if ((efeito != null)and(efeito != 0)):
		retorno.efeito= Efeitos.getEfeito(efeito,pai)
	retorno.pai=pai
	return retorno

class palavraChave:
	
	var id
	var efeito
	var pai

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
	
	
	
	
