extends Node

var idGeral=0

class Bonus : 
	
	var id
	var dono
	var carta
	var origem
	var origemTipo
	var tipo

	func _init(dono,carta,origem):
		self.id=ClasseBonus.idGeral
		ClasseBonus.idGeral+=1
		self.dono=dono
		self.carta=carta
		self.origem=origem
		self.origemTipo=origem.carta.tipo
	
	func atribuirCarta(novaCarta):
		if(carta!=null):
			removerCarta()
		
		carta=novaCarta
		carta.carta.listaMarcadores.append(carta)
		ativar()
		
	
	func removerCarta():
		var lista=carta.carta.listaMarcadores
		lista.remove(lista.find(self))
	
	func ativar():
		pass

	func endOfTurn():
		if(verificarMorte()):
			morre()
		
	func verificarMorte():
		return true
		
	func efeitoAoMorrer():
		pass
		
	func morre():
		efeitoAoMorrer()
		removerCarta()

class AdicionaAtributo extends Bonus:
	
	var dano
	var vida
	var defesa
	var aplicado=false
	var turnos
	var contTurnos
	
	func _init(dono,carta,origem,dano=0,vida=0,defesa=0,turnos=null).(dono,carta,origem):
		self.dano=dano
		self.vida=vida
		self.defesa=defesa
		self.turnos=turnos
		self.tipo=Constante.MARCADOR_ATRIBUTO
	
	func ativar():
		if((origemTipo == Constante.CARTA_PERSONAGEM) or (origemTipo == Constante.CARTA_MONSTRO)):
			carta.carta.vidaBonus +=vida
			carta.carta.poderBonus +=dano
			carta.carta.defesaBonus +=defesa
			aplicado=true

	func efeitoAoMorrer():
		if(aplicado):
			carta.carta.vidaBonus -=vida
			carta.carta.poderBonus -=dano
			carta.carta.defesaBonus -=defesa
			aplicado=false
			
	
	func verificarMorte():
		if(turnos!=null):
			if(contTurnos>=turnos):
				return true
			contTurnos+=1
		return false
		
		
		
		
