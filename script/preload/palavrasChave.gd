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
		8:
			retorno = Passivo.new()
		9:
			retorno = Golpear.new()
		10:
			retorno = Afinidade.new()
		11:
			retorno = Protecao.new()
		12:
			retorno = Esquivo.new()
		13:
			retorno = Recarregar.new()
		14:
			retorno = InicioDeTurno.new()
			
	if ((efeito != null)and(efeito != 0)):
		retorno.efeito= Efeitos.getEfeito(efeito,pai,retorno)
	retorno.pai=pai
	retorno.val1 = val1
	return retorno

class palavraChave:
	
	var id
	var efeito
	var pai
	var val1
	var incentivoAtaqueDefesa = 0

	func recebeNome():
		return Ferramentas.receberTexto("palavrasChave",id)
	
	func recebeNomeAlternativo():
		return Ferramentas.receberTexto("palavrasChave",id,2)
	
	func recebeDescricao():
		return Ferramentas.receberTexto("palavrasChave",id,1)
		
	func receberIncentivo():
		return incentivoAtaqueDefesa

	func aoJogar():
		pass
	
	func aoComprar():
		pass
	
	func aoDescartar():
		pass
		
class AtaqueDistancia extends palavraChave:
	
	func _init():
		id=1
		incentivoAtaqueDefesa = 20

class Iniciativa extends palavraChave:
	
	func _init():
		id=2

class Ofensivo extends palavraChave:
	
	func _init():
		id=3
		incentivoAtaqueDefesa = 7
		
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
		incentivoAtaqueDefesa = -10
		
	func recebeNome():
		var texto = .recebeNome()
		texto += " "+str(val1) 
		return texto
		
	func recebeDescricao():
		var texto = .recebeDescricao()
		texto = texto.replace("&1",str(val1))
		return texto
	
class Passivo extends palavraChave:
	
	
	func _init():
		id=8
		incentivoAtaqueDefesa = -6
	
	func aoJogar():
		pai.dono.listaHabilidadesPassivas.append(efeito)
		var xy = Efeitos.criarXY(efeito,pai.dono.listaHabilidadesPassivas)
		pai.listaEfeitoMorrer.append(xy)

class Golpear extends palavraChave:
	
	func _init():
		id=9
		incentivoAtaqueDefesa = 5
	
class Afinidade extends palavraChave:

	
	func _init():
		id=10
		
	func recebeNome():
		var strVal1 = str(val1)
		var texto = .recebeNome()
		texto = texto.replace("&1",Ferramentas.receberTexto("subRacas",int(strVal1[0]),int(strVal1.right(1))))
		return texto
		
	func recebeDescricao():
		var strVal1 = str(val1)
		var texto = .recebeDescricao()
		texto = texto.replace("&1",Ferramentas.receberTexto("subRacas",int(strVal1[0]),int(strVal1.right(1))))
		#print(Ferramentas.receberTexto("subRacas",int(val1[0]),int(val1.right(1))))
		return texto

class Protecao extends palavraChave:
	
	func _init():
		id=11
		
class Esquivo extends palavraChave:
	
	func _init():
		id=12
		incentivoAtaqueDefesa = -20
		
class Recarregar extends palavraChave:
	var turnos = 0
	func _init():
		id=13
		incentivoAtaqueDefesa = -8
	func recebeNome():
		var texto = .recebeNome()
		texto +=" "+str(val1) 
		return texto
		
	func recebeDescricao():
		var texto = .recebeDescricao()
		texto = texto.replace("&1","("+str(turnos)+"/"+str(val1)+")")
		return texto

class InicioDeTurno extends palavraChave:
	
	func _init():
		id=14
		incentivoAtaqueDefesa = -10
