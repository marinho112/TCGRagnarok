extends Node

func getPalavraChave(id,efeito,pai,val1,val2,val3):
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
			retorno = jogarCarta.new()
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
		15:
			retorno = GolpeDuplo.new()
		16:
			retorno = Resiliente.new()
		17:
			retorno = AtaqueMultiplo.new()
			
	if ((efeito != null)and(efeito != 0)):
		retorno.efeito= Efeitos.getEfeito(efeito,pai,retorno)
	retorno.pai=pai
	retorno.val1 = val1
	retorno.val2 = val2
	retorno.val3 = val3
	return retorno

class palavraChave:
	
	var id
	var efeito
	var pai
	var val1
	var val2
	var val3
	var incentivoAtaqueDefesa = 0

	func recebeNome():
		return Ferramentas.receberTexto("palavrasChave",id)
	
	func recebeNomeAlternativo():
		return Ferramentas.receberTexto("palavrasChave",id,2)
	
	func recebeDescricao():
		return Ferramentas.receberTexto("palavrasChave",id,1)
		
	func receberIncentivo():
		return incentivoAtaqueDefesa
	
	func adicionarEfeitoListaJogador(lista,carta):
		lista.append(efeito)
		var xy = Efeitos.criarXY(efeito,lista)
		carta.listaEfeitoSairJogo.append(xy)
	
	func aoJogar():
		aoMudarDeZona()
	
	func aoMudarDeZona():
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
	
	func aoJogar():
		.aoJogar()
		adicionarEfeitoListaJogador(pai.dono.listaAoAtacar,pai)
		
class Imovel extends palavraChave:
	
	func _init():
		id=4
		
class jogarCarta extends palavraChave:
	
	func _init():
		id=5
		
	func aoJogar():
		.aoJogar()
		efeito.ativar()
		
class Coletar extends palavraChave:
	
	func _init():
		id=6
	
class Meditar extends palavraChave:
	var turnos = 0
	func _init():
		id=7
		incentivoAtaqueDefesa = -10
		
	func recebeNome():
		var texto = .recebeNome()
		var complemento=""
		if(val1-turnos>0):
			complemento=" "+str(val1-turnos)
		texto +=  complemento
		return texto
		
	func aoMudarDeZona():
		turnos = 0
		
	func aoJogar():
		.aoJogar()
		var lista= pai.dono.listaFaseInicial
		var novoEfeito=Efeitos.criarContador(val1,efeito,lista,false)
		lista.append(novoEfeito)
		pai.listaEfeitoSairJogo.append(novoEfeito.xy)
		
	func recebeDescricao():
		var texto = .recebeDescricao()
		texto = texto.replace("&1",str(val1))
		return texto
	
class Passivo extends palavraChave:
	
	
	func _init():
		id=8
		incentivoAtaqueDefesa = -6
	
	func aoJogar():
		.aoJogar()
		adicionarEfeitoListaJogador(pai.dono.listaHabilidadesPassivas,pai)
		

class Golpear extends palavraChave:
	
	func _init():
		id=9
		incentivoAtaqueDefesa = 5
	
	func aoJogar():
		.aoJogar()
		var novoEfeito = Efeitos.criarAtivadorDono(efeito,pai.dono.listaAoGolpear)
		pai.dono.listaAoGolpear.append(novoEfeito)
		pai.listaEfeitoSairJogo.append(novoEfeito.xy)
	
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
		texto +=" "+"("+str(turnos)+"/"+str(val1)+")"
		return texto
		
	func aoMudarDeZona():
		turnos = 0
	
	func recebeDescricao():
		var texto = .recebeDescricao()
		texto = texto.replace("&1","("+str(turnos)+"/"+str(val1)+")")
		return texto
		
	func aoJogar():
		.aoJogar()
		var lista= pai.dono.listaFaseInicial
		var novoEfeito=Efeitos.criarContador(val1,efeito,lista,true)
		lista.append(novoEfeito)
		pai.listaEfeitoSairJogo.append(novoEfeito.xy)

class InicioDeTurno extends palavraChave:
	
	func _init():
		id=14
		incentivoAtaqueDefesa = -10
	
	func aoJogar():
		.aoJogar()
		adicionarEfeitoListaJogador(pai.dono.listaFaseInicial,pai)
	
class GolpeDuplo extends palavraChave:
	
	func _init():
		id=15
		incentivoAtaqueDefesa = 10

class Resiliente extends palavraChave:
	
	func _init():
		id=16
		incentivoAtaqueDefesa = -10
	
	func aoJogar():
		.aoJogar()
		
		var novoEfeito = Efeitos.criarAtivadorDano(efeito,pai.dono.listaAoGolpear)
		pai.dono.listaAoReceberDano.append(novoEfeito)
		pai.listaEfeitoSairJogo.append(novoEfeito.xy)
		
class AtaqueMultiplo extends palavraChave:
	
	func _init():
		id=17
		incentivoAtaqueDefesa = 15
