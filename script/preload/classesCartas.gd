
class carta:
	
	var codigo
	var nome
	var tipo
	var custo
	var edicao
	var raridade
	var imagem
	var descricao
	
class objetoDeBatalha extends carta:
	
	var vida
	var poder
	var defesa
	var propriedade
	var nivelPropriedade
	var raca
	var subRaca
	
	var danoRecebido
	
	func retornaPoder():
		return poder
	func retornaVida():
		return vida
	func retornaDefesa():
		return defesa
		
class personagem extends objetoDeBatalha:
		
	var classe
		
	func _init():
		tipo = Constante.CARTA_PERSONAGEM
		propriedade = Constante.PROPRIEDADE_NEUTRO
		nivelPropriedade = 1
		raca = Constante.RACA_HUMANOIDE
		subRaca = Constante.obterSubRaca(Constante.SUB_RACA_HUMANO)
		
class monstro extends objetoDeBatalha:
	
	func _init():
		pass
		

class item extends carta:
	
	var subTipo
	func _init():
		tipo = Constante.CARTA_ITEM
	
class utilizavel extends item:
	
	func _init():
		subTipo = Constante.SUB_TIPO_ITEM_UTILIDADE


class equipamento extends item:
	
	func _init():
		pass
		

class habilidade extends carta:
	
	var subTipo
	
