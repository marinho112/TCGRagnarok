extends Node


class carta:
	
	var id
	var nome
	var tipo
	var custo
	var edicao
	var raridade
	var imagem
	var descricao
	var posicaoImagem
	var revelada = false
	
	var listaPalavraChave = []
	var listaMarcadores = []
	var listaEfeitos = []
	var listaCartasRelacionadas = []
	
	func temPalavraChave(val):
		for palavra in listaPalavraChave:
			if (palavra.id == val):
				return true
		return false
	
class objetoDeBatalha extends carta:
	
	var vida
	var poder
	var defesa
	var propriedade
	var nivelPropriedade
	var raca
	var subRaca
	
	var danoRecebido = 0
	
	var vidaBonus = 0
	var poderBonus = 0
	var defesaBonus = 0
	
	var listaHabilidades = []
	
	func reduzirVidaBonus(val):
		vidaBonus-= val
		if ((vida + vidaBonus)<=danoRecebido):
			danoRecebido = (vida + vidaBonus) -1
	func retornaPoder():
		return poder
	func retornaVida():
		return vida
	func retornaDefesa():
		return defesa
		
	func calculaDano(dano):
		var retorno = dano - defesa
		if(retorno<0):
			retorno = 0
		return retorno
	
	func recebeDano(dano):
		danoRecebido += dano
		if(danoRecebido > (vida+vidaBonus)):
			dano -= danoRecebido - vida+vidaBonus
			danoRecebido= vida+vidaBonus
		return dano
	
	func recebeDanoComDef(dano):
		return recebeDano(calculaDano(dano))
		
		
	func golpear(inimigo):
		
		var danoCausado = inimigo.recebeDanoComDef(poder)
		var retorno = danoCausado
		return retorno
		
class personagem extends objetoDeBatalha:
		
	var classe

	func _init():
		tipo = Constante.CARTA_PERSONAGEM
		#propriedade = Constante.PROPRIEDADE_NEUTRO
		#nivelPropriedade = 1
		#raca = Constante.RACA_HUMANOIDE
		#subRaca = Constante.SUB_RACA_HUMANO
		
class monstro extends objetoDeBatalha:
	
	
	func _init():
		tipo = Constante.CARTA_MONSTRO
		

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
	
	func _init():
		tipo = Constante.CARTA_HABILIDADE
		
	var subTipo
	
class efeito extends carta:
	
	func _init():
		tipo = Constante.CARTA_EFEITO
		
	var propriedade
