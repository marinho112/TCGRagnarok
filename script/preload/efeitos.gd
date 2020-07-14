extends Node

func getEfeito(id,pai):
	var retorno 
	match id:
		1:
			retorno = Mais1Mais0End.new()
		_: 
			return null
		
	retorno.pai=pai
	return retorno
	
class efeito:
	
	var id
	var pai
	
	func ativar():
		pass

class Mais1Mais0End extends efeito:
	
	func _init():
		id=1
	
	func ativar():
		pai.poder += 1
		
