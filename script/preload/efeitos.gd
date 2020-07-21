extends Node

func getEfeito(id,pai):
	var retorno 	
	match id:
		1:
			retorno = Mais1Mais0End.new()
		2:
			retorno = Coletar1.new()
		_: 
			return null
	
	retorno.pai=pai
	ControlaDados.recebePalavrasPorEfeito(retorno)
	return retorno
	
class efeito:
	
	var id
	var pai
	var listaPalavras = []
	
	func ativar():
		pass
	
	func recebeDescricao():
		return Ferramentas.receberTexto("efeitos",id)

class Mais1Mais0End extends efeito:
	
	func _init():
		id=1
	
	func ativar():
		pai.poder += 1
		
class Coletar1 extends efeito:
	
	func _init():
		id=2
	
	func ativar():
		pass
		
