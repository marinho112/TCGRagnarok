extends Node

func criarXY(eliminado,lista):
	var xy = eliminarXdeY.new()
	xy.definirXY(eliminado,lista)
	return xy
	
func getEfeito(id,pai,palavraPai):
	var retorno 	
	match id:
		1:
			retorno = Mais1Ataque.new()
		2:
			retorno = Coletar1.new()
		3: 
			retorno = CriarBalaNaMao.new()
		4:
			retorno = Mais1DefPoring.new()
		5:
			retorno = Mais1AtaquePoring.new()
		6:
			retorno = DevolveArmaInimigo.new()
		7:
			retorno = Mais1AtaqueAmorfo.new()
		8:
			retorno = CriePoringDef.new()
		9:
			retorno = CureSeusPoringsEm3.new()
		10:
			retorno = DarProtecao4Elementos.new()
		_: 
			return null
	
	retorno.pai=pai
	retorno.palavraPai = palavraPai
	ControlaDados.recebePalavrasPorEfeito(retorno)
	return retorno
	
class efeito:
	
	var id
	var pai
	var palavraPai
	var listaPalavras = []
	
	func ativar(carta=null):
		pass
	
	func recebeDescricao():
		return Ferramentas.receberTexto("efeitos",id)

class eliminarXdeY extends efeito: 
	var x
	var y
	
	func definirXY(eliminado,lista):
		self.x=eliminado
		self.y=lista
	
	func ativar(carta=null):
		y.remove(y.find(x))

class Mais1Ataque extends efeito:
	
	func _init():
		id=1
	
	func ativar(carta=null):
		if(carta==null):
			pai.poderBonusEfemero += 1
		else:
			carta.poderBonusEfemero+=1
			
class Coletar1 extends efeito:
	
	func _init():
		id=2
	
	func ativar(carta=null):
		pass

class CriarBalaNaMao extends efeito:
	
	func _init():
		id=3
	
	func ativar(carta=null):
		pass

class Mais1DefPoring extends efeito:
	
	func _init():
		id=4
		
	func ativar(carta=null):
		if(carta!=null):
			if(carta.carta.dono == pai.dono):
				if(carta.carta.subRaca==Constante.SUB_RACA_PORING):
					carta.carta.defesaBonus+=1

class Mais1AtaquePoring extends efeito:
	
	func _init():
		id=5
	
	func ativar(carta=null):
		pass

class DevolveArmaInimigo extends efeito:
	
	func _init():
		id=6
	
	func ativar(carta=null):
		pass
		
	func recebeDescricao():
		var texto = .recebeDescricao()
		texto = texto.replace("&1",Ferramentas.receberTexto("palavrasChave",palavraPai.id,2))
		
		return texto

class Mais1AtaqueAmorfo extends efeito:
	
	func _init():
		id=7
	
	func ativar(carta=null):
		pass
		
class CriePoringDef extends efeito:
	
	func _init():
		id=8
	
	func ativar(carta=null):
		pass
		
class CureSeusPoringsEm3 extends efeito:
	
	func _init():
		id=9
	
	func ativar(carta=null):
		pass
	
		
class DarProtecao4Elementos extends efeito:
	
	func _init():
		id=10
	
	func ativar(carta=null):
		pass
