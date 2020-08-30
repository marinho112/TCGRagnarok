extends Node


func getRaiz():
	return get_node("/root/main/Combate/")

func criarXY(eliminado,lista,alertaMsg=null):
	var xy = eliminarXdeY.new()
	xy.definirXY(eliminado,lista,alertaMsg)
	return xy
	
func alerta(local,texto,val=null):
	var loadAnimacaoBonus=load("res://cenas/animacoes/animacaoAlertaBonus.tscn")
	var animacao=loadAnimacaoBonus.instance()
	animacao.setTexto(val,texto)
	animacao.set_global_position(local.get_global_position())
	animacao.definirPai(local.get_parent())
	animacao.play(local,[])
		
func criarAtivadorDono(efeito,lista):
	var novoAtivador = ativadorDono.new()
	var XY = criarXY(novoAtivador,lista)
	novoAtivador.iniciar(efeito,XY)
	return novoAtivador

func criarAtivadorDano(efeito,lista):
	var novoAtivador = ativadorDano.new()
	var XY = criarXY(novoAtivador,lista)
	novoAtivador.iniciar(efeito,XY)
	return novoAtivador

func criarContador(limite,efeito,lista,loop):
	var novoContador = contador.new()
	var XY = criarXY(novoContador,lista)
	var combate = getRaiz()
	novoContador.iniciar(limite,efeito,XY,combate,loop)
	return novoContador
		
		
func adicionaPalavraChave(carta,novaPalavra,listaRemocao=null,alertaMsg=null):
	var nTem=true
	var lista = carta.listaPalavraChave
	for palavra in lista:
		if(palavra.id==novaPalavra.id):
			nTem=false
	if(nTem):	
		lista.append(novaPalavra)
		if(listaRemocao!= null):
			listaRemocao.append(Efeitos.criarXY(novaPalavra,lista,alertaMsg))
			
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
			retorno = CureSeusPoringsEmX.new()
		10:
			retorno = DarProtecao4Elementos.new()
		11:
			retorno = transformar.new()
		12:
			retorno = recebeAtaqueMultiplo.new()
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
	var alertaMsg = null
	var usado=false
	
	func definirXY(eliminado,lista,alertaMsg=null):
		id=Constante.EFEITO_XY
		self.x=eliminado
		self.y=lista
		self.alertaMsg=alertaMsg
	
	func ativar(carta=null,alvo=null):
		y.remove(y.find(x))
		usado=true
		if(alertaMsg!=null):
			Efeitos.alerta(self.x.pai.obj,alertaMsg)
		

class contador extends efeito: 
	var limite
	var cont
	var efeito
	var loop
	var xy
	var combate
	var usado = false
	
	func _init():
		id=Constante.EFEITO_CONTADOR
	
	func iniciar(limite,efeito,xy,combate,loop):
		self.limite=limite
		self.efeito=efeito
		self.pai=efeito.pai
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
				usado=true
		efeito.palavraPai.turnos=cont

class ativadorDono extends efeito: 

	var efeito
	var xy
	
	func _init():
		id=Constante.EFEITO_ATIVADOR_DONO
	
	func iniciar(efeito,xy):
		self.pai=efeito.pai
		self.efeito=efeito
		self.xy=xy
	
	func ativar(carta=null,alvo=null):
		if(efeito.pai==carta.carta):
			efeito.ativar()
			
class ativadorDano extends efeito: 

	var efeito
	var xy
	
	func _init():
		id=Constante.EFEITO_ATIVADOR_DANO
	
	func iniciar(efeito,xy):
		self.pai=efeito.pai
		self.efeito=efeito
		self.xy=xy
	
	func ativar(carta=null,alvo=null):
		if(efeito.pai==carta.carta):
			if(efeito.pai.retornaVida()>0):
				efeito.ativar()

class MaisXAtaque extends efeito:
	
	func _init():
		id=1
	
	func ativar(carta=null,alvo=null):
		if(carta==null):
			pai.poderBonusEfemero += palavraPai.val1
			Efeitos.alerta(pai.obj,"Poder",palavraPai.val1)
		else:
			carta.poderBonusEfemero+=palavraPai.val1
			Efeitos.alerta(carta,"Poder",palavraPai.val1)
			

		
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
		var combate = pai.obj.get_parent()
		var area = combate.get_node("ControladorCartas").retornarArea(pai.dono,0)
		if(area!=null):
			var cartaNova=ControladorCartas.criarCartaDoZero(1,pai.dono,combate,Vector2(0,0),true)
			cartaNova.add_to_group(Constante.GRUPO_CARTA_EM_CAMPO)
			combate.get_node("ControladorCartas").positionAreaCarta(area,cartaNova)
			Efeitos.alerta(cartaNova,"Carta Criada!")
		
class CureSeusPoringsEmX extends efeito:
	
	func _init():
		id=9
	
	func ativar(carta=null,alvo=null):
		var combate = pai.obj.get_parent()
		if(combate.jogador==pai.dono):
			var lista = combate.retornarTodasAsCartasEmCampo()
			for item in lista:
				if(item.carta.dono == pai.dono):
					if(item.carta.subRaca==Constante.SUB_RACA_PORING):
						item.curar(palavraPai.val1)
		
class DarProtecao4Elementos extends efeito:
	
	var listaProtecoes 
	
	func _init():
		id=10
		var agua=PalavrasChave.getPalavraChave(11,null,pai,Constante.PROPRIEDADE_AGUA,null)
		var fogo=PalavrasChave.getPalavraChave(11,null,pai,Constante.PROPRIEDADE_FOGO,null)
		var terra=PalavrasChave.getPalavraChave(11,null,pai,Constante.PROPRIEDADE_TERRA,null)
		var vento=PalavrasChave.getPalavraChave(11,null,pai,Constante.PROPRIEDADE_VENTO,null)
		listaProtecoes = [agua,fogo,terra,vento]
		
	func ativar(carta=null,alvo=null):
		if(carta!=null):
			if(carta.carta.dono == pai.dono):
				if(carta.carta.subRaca==Constante.SUB_RACA_PORING):
					var lista=carta.carta.listaPalavraChave
					for item in listaProtecoes:
						var nTem = true
						for elemento in lista:
							if((elemento.id==item.id)and(elemento.val1==item.val1)):
								nTem=false
						if(nTem):	
							lista.append(item)
							carta.carta.listaEfeitoSairJogo.append(Efeitos.criarXY(item,lista))
		
class transformar extends efeito:
	var valor
	func _init():
		id=11
		
	
	func ativar(carta=null,alvo=null):
		var efeito = load("res://cenas/animacoes/animacaoTransformar.tscn").instance()
		efeito.definirPai(pai.obj.get_parent())
		efeito.transformarCarta(pai.obj,palavraPai.val2)
	
		
	func recebeDescricao():
		var texto = .recebeDescricao()
		var carta = ControlaDados.carregaCartaPorID(palavraPai.val2,pai.dono)
		texto = texto.replace("&1",Ferramentas.receberTexto("cartas",carta.nome,0))
		return texto
		
class recebeAtaqueMultiplo extends efeito:

	func _init():
		id=12
	
	func ativar(carta=null,alvo=null):
		var novaPalavra=PalavrasChave.getPalavraChave(17,null,pai,null,null)
		Efeitos.alerta(pai.obj,"Recebeu Palavra chaver!")
		var alertaFim= "Perdeu Palavra Chave"
		Efeitos.adicionaPalavraChave(pai,novaPalavra,pai.dono.listaFaseFinal,alertaFim)
		
