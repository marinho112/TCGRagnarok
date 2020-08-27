extends Node


func getRaiz():
	return get_node("/root/main/Combate/")

func criarXY(eliminado,lista):
	var xy = eliminarXdeY.new()
	xy.definirXY(eliminado,lista)
	return xy
	
func criarAtivadorDono(efeito,lista):
	var novoAtivador = ativadorDono.new()
	var XY = criarXY(novoAtivador,lista)
	novoAtivador.iniciar(efeito,XY)
	return novoAtivador

func criarContador(limite,efeito,lista,loop):
	var novoContador = contador.new()
	var XY = criarXY(novoContador,lista)
	var combate = getRaiz()
	novoContador.iniciar(limite,efeito,XY,combate,loop)
	return novoContador
		
func getEfeito(id,pai,palavraPai):
	var retorno 	
	match id:
		1:
			retorno = MaisXAtaque.new()
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
		11:
			retorno = transformar.new()
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
	
	func ativar(carta=null,alvo=null):
		pass
	
	func recebeDescricao():
		return Ferramentas.receberTexto("efeitos",id)

class eliminarXdeY extends efeito: 
	var x
	var y
	
	func definirXY(eliminado,lista):
		self.x=eliminado
		self.y=lista
	
	func ativar(carta=null,alvo=null):
		y.remove(y.find(x))

class contador extends efeito: 
	var limite
	var cont
	var efeito
	var loop
	var xy
	var combate
	
	func _init():
		id=Constante.EFEITO_CONTADOR
	
	func iniciar(limite,efeito,xy,combate,loop):
		self.limite=limite
		self.efeito=efeito
		self.loop=loop
		self.cont=0
		self.xy=xy
		self.combate=combate
	
	func ativar(carta=null,alvo=null):
		if(efeito.pai.dono==combate.jogador):
			cont+=1
		if(cont>=limite):
			efeito.ativar(carta)
			if(loop):
				cont=0
			else:
				xy.ativar()

class ativadorDono extends efeito: 

	var efeito
	var xy
	
	func _init():
		id=Constante.EFEITO_ATIVADOR_DONO
	
	func iniciar(efeito,xy):
		
		self.efeito=efeito
	
	func ativar(carta=null,alvo=null):
		if(efeito.pai==carta.carta):
			efeito.ativar()

class MaisXAtaque extends efeito:
	
	func _init():
		id=1
	
	func ativar(carta=null,alvo=null):
		if(carta==null):
			pai.poderBonusEfemero += palavraPai.val1
			alerta(pai.obj)
		else:
			carta.poderBonusEfemero+=palavraPai.val1
			alerta(carta)
			
	func alerta(local):
		var loadAnimacaoBonus=load("res://cenas/animacoes/animacaoAlertaBonus.tscn")
		var animacao=loadAnimacaoBonus.instance()
		animacao.setTexto(palavraPai.val1,"Poder")
		animacao.set_global_position(local.get_global_position())
		animacao.definirPai(local.get_parent())
		animacao.play(local,[])
		
	func recebeDescricao():
		var texto = .recebeDescricao()
		texto = texto.replace("&1",str(palavraPai.val1))
		
		return texto
	
class Coletar1 extends efeito:
	
	func _init():
		id=2
	
	func ativar(carta=null,alvo=null):
		print("COLETADO!")
		pass

class CriarBalaNaMao extends efeito:
	
	func _init():
		id=3
	
	func ativar(carta=null,alvo=null):
		print("BALA CRIADA NA MÂO")
		pass

class Mais1DefPoring extends efeito:
	
	func _init():
		id=4
		
	func ativar(carta=null,alvo=null):
		if(carta!=null):
			if(carta.carta.dono == pai.dono):
				if(carta.carta.subRaca==Constante.SUB_RACA_PORING):
					carta.carta.defesaBonus+=1

class Mais1AtaquePoring extends efeito:
	
	func _init():
		id=5
	
	func ativar(carta=null,alvo=null):
		if(carta!=null):
			if(carta.carta.dono == pai.dono):
				if(carta.carta.subRaca==Constante.SUB_RACA_PORING):
					carta.carta.poderBonus+=1

class DevolveArmaInimigo extends efeito:
	
	func _init():
		id=6
	
	func ativar(carta=null,alvo=null):
		print("ARMA DEVOLVIDA PARA MÂO DO INIMIGO")
		pass
		
	func recebeDescricao():
		var texto = .recebeDescricao()
		texto = texto.replace("&1",Ferramentas.receberTexto("palavrasChave",palavraPai.id,2))
		
		return texto

class Mais1AtaqueAmorfo extends efeito:
	
	func _init():
		id=7
	
	func ativar(carta=null,alvo=null):
		if(carta!=null):
			if(carta.carta.dono == pai.dono):
				if(carta.carta.raca==Constante.RACA_AMORFO):
					carta.carta.poderBonus+=1
		
class CriePoringDef extends efeito:
	
	func _init():
		id=8
	
	func ativar(carta=null,alvo=null):
		pass
		
class CureSeusPoringsEm3 extends efeito:
	
	func _init():
		id=9
	
	func ativar(carta=null,alvo=null):
		pass
	
		
class DarProtecao4Elementos extends efeito:
	
	func _init():
		id=10
	
	func ativar(carta=null,alvo=null):
		pass
		
class transformar extends efeito:
	
	func _init():
		id=11
	
	func ativar(carta=null,alvo=null):
		pass
	
	func recebeDescricao():
		var texto = .recebeDescricao()
		texto = texto.replace("&1",Ferramentas.receberTexto("carta",palavraPai.val1,0))
	
