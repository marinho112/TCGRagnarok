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
	var dono
	var obj
	
	var listaPalavraChave = []
	var listaMarcadores = []
	var listaEfeitos = []
	var listaCartasRelacionadas = []
	
	func temPalavraChave(val):
		for palavra in listaPalavraChave:
			if (palavra.id == val):
				return true
		return false
	
	func zerarBonus():
		pass
	
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
	
	var vidaBonusEfemero = 0
	var poderBonusEfemero = 0
	var defesaBonusEfemero = 0
	
	var listaHabilidades = []
	var listaEfeitoMorrer = []
	
	func zerarBonus():
		reduzirVidaBonus(vidaBonus)
		poderBonus = 0
		defesaBonus = 0
		
	func zerarBonusEfemero():
		reduzirVidaBonusEfemero(vidaBonusEfemero)
		poderBonusEfemero = 0
		defesaBonusEfemero = 0
	
	func reduzirVidaBonus(val):
		if(retornaVida()>0):
			if (val<0):
				val = 0
			vidaBonus-= val
			if (retornaVidaTotal()<=danoRecebido):
				danoRecebido = (vida + vidaBonus) -1
			
	func reduzirVidaBonusEfemero(val):
		if(retornaVida()>0):
			if (val<0):
				val = 0
			vidaBonusEfemero-= val
			if (retornaVidaTotal()<=danoRecebido):
				danoRecebido = retornaVidaTotal() -1
	
	func retornaPoder():
		return poder + poderBonus +poderBonusEfemero
	func retornaVida():
		return retornaVidaTotal() - danoRecebido
	func retornaVidaTotal():
		return vida + vidaBonus +vidaBonusEfemero
	func retornaDefesa():
		return defesa + defesaBonus + defesaBonusEfemero
		
	func calculaDano(dano):
		var retorno = dano - retornaDefesa()
		if(retorno<0):
			retorno = 0
		return retorno
	
	func recebeDano(dano):
		danoRecebido += dano
		if(danoRecebido > retornaVidaTotal()):
			dano -= (danoRecebido - retornaVidaTotal())
			danoRecebido= retornaVidaTotal()
		return dano
	
	func recebeDanoComDef(dano):
		return recebeDano(calculaDano(dano))
		
		
	func golpear(inimigo):
		
		var danoCausado = inimigo.recebeDanoComDef(retornaPoder())
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
