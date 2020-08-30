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
	var listaEfeitoSairJogo = []
	
	func migraValor(carta):
		carta.listaMarcadores=listaMarcadores
		carta.dono=dono
		carta.obj=obj
		carta.revelada=revelada
		
	func temPalavraChave(val):
		for palavra in listaPalavraChave:
			if (palavra.id == val):
				return true
		return false
	
	func recebeNome():
		return Ferramentas.receberTexto("cartas",nome)
	
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
	
	
	var mana=0
	var danoRecebido = 0
	
	var vidaBonus = 0
	var poderBonus = 0
	var defesaBonus = 0
	
	var vidaBonusEfemero = 0
	var poderBonusEfemero = 0
	var defesaBonusEfemero = 0
	
	var listaHabilidades = []
	var listaEfeitoMorrer = []
	
	func migraValor(carta):
		.migraValor(carta)
		if((carta.tipo== Constante.CARTA_PERSONAGEM) or (carta.tipo==Constante.CARTA_MONSTRO)):
			carta.mana=mana
			carta.recebeDano(danoRecebido)
			
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
	
	func curar(valor):
		danoRecebido-=valor
		if(danoRecebido<0):
			valor -= danoRecebido
			danoRecebido=0
		return valor
		
	func calculaDano(dano):
		var retorno = dano - retornaDefesa()
		if(retorno<0):
			retorno = 0
		return retorno
	
	func recebeDano(dano,inimigo=null,propriedade= Constante.PROPRIEDADE_NEUTRO):
		
		dano = calcularPropriedadeBonus(dano,inimigo,propriedade)
		danoRecebido += dano
		if(danoRecebido > retornaVidaTotal()):
			dano -= (danoRecebido - retornaVidaTotal())
			danoRecebido= retornaVidaTotal()
		return dano
	
	func recebeDanoComDef(dano,inimigo,propriedade):
		return recebeDano(calculaDano(dano),inimigo,propriedade)
	
	func calcularPropriedadeBonus(dano,inimigo=null,propInimigo= null):
		var novoDano = dano
		var fraco = null
		var forte = null
		
		if (propInimigo==null):
			return dano
		
		match propriedade:
			
			Constante.PROPRIEDADE_NEUTRO:
				fraco=Constante.PROPRIEDADE_FANTASMA
				forte= null
			Constante.PROPRIEDADE_AGUA:
				fraco=Constante.PROPRIEDADE_VENTO
				forte=Constante.PROPRIEDADE_FOGO
			Constante.PROPRIEDADE_FANTASMA:
				fraco=Constante.PROPRIEDADE_FANTASMA
				forte=Constante.PROPRIEDADE_NEUTRO
			Constante.PROPRIEDADE_FOGO:
				fraco=Constante.PROPRIEDADE_AGUA
				forte=Constante.PROPRIEDADE_TERRA
			Constante.PROPRIEDADE_MORTOVIVO:
				fraco=Constante.PROPRIEDADE_SAGRADO
				forte=Constante.PROPRIEDADE_VENENO
			Constante.PROPRIEDADE_SAGRADO:
				fraco=Constante.PROPRIEDADE_SOMBRIO
				forte=Constante.PROPRIEDADE_FANTASMA
			Constante.PROPRIEDADE_SOMBRIO:
				fraco=Constante.PROPRIEDADE_SAGRADO
				forte=Constante.PROPRIEDADE_MORTOVIVO
			Constante.PROPRIEDADE_TERRA:
				fraco=Constante.PROPRIEDADE_FOGO
				forte=Constante.PROPRIEDADE_VENTO
			Constante.PROPRIEDADE_VENENO:
				fraco=null
				forte=Constante.PROPRIEDADE_SOMBRIO
			Constante.PROPRIEDADE_VENTO:
				fraco=Constante.PROPRIEDADE_FOGO
				forte=Constante.PROPRIEDADE_AGUA
		
		if(inimigo!=null):
			for palavra in inimigo.listaPalavraChave:
				if(palavra.id==11):
					if(palavra.val1==self.propriedade):
						novoDano -= nivelPropriedade
			
		if(propInimigo==fraco):
			novoDano += inimigo.nivelPropriedade
		if(propInimigo==forte):
			novoDano -= nivelPropriedade
		
		if(novoDano<0):
			novoDano=0
			
		return novoDano
		
	func golpear(inimigo):
		
		var danoCausado = inimigo.recebeDanoComDef(retornaPoder(),self,self.propriedade)
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
