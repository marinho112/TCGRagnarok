extends Node

var contId=0

class jogador:
	
	var personagem
	var time
	var ai
	
	var listaBaralho=[]
	var listaMao=[]
	var listaCampoMonstro=[]
	var listaEquipamento=[]
	var listaPilhaDescarte=[]
	
	var listaInicioPartida = []
	var listaFaseInicial = []
	var listaFaseCompra = []
	var listaAoComprar = []
	var listaFasePrincipal1 = []
	var listaFasePrincipal2 = []
	var listaAoJogarCarta = []
	var listaAoEntrarEmJogo = []
	var listaFaseCombate = []
	var listaAoAtacar = []
	var listaAoSerAtacado = []
	var listaAoBloquear = []
	var listaAoGolpear = []
	var listaAoSerGolpeado = []
	var listaAoReceberDano = []
	var listaAoMorrer = []
	var listaAoSairDeJogo = []
	var listaHabilidadesPassivas = []
	
	
	var listaFaseFinal = []
	
	var controlador
	var areaMao
	var areaMiniatura
	var areaZenys
	var areaAtaque
	var areaDefesa
	
	var zeny = 1
	var maxZeny = 1
	
	var ativado = false
	
	func definirAreas(controlador,mao,miniatura,zeny,ataque,defesa):
		
		self.controlador=controlador
		areaMao =mao
		mao.definirJogador(self)
		areaMiniatura=miniatura
		miniatura.jogador = self
		areaZenys=zeny
		zeny.setJogador(self)
		areaAtaque=ataque
		areaDefesa=defesa

class fasesJogador:
	var jogador
	var turnoAtual=0
	var inicio
	var compra
	var principal1
	var escolherAtaque
	var escolherDefesa
	var dano
	var principal2
	var final
	
	var listaFases = [inicio,compra,principal1,escolherAtaque,escolherDefesa,dano,principal2,final] 
	
	func _init():
		inicio= Fases.faseInicial.new()
		compra= Fases.faseCompra.new()
		principal1= Fases.fasePrincipal1.new()
		escolherAtaque= Fases.faseAtaque.new()
		escolherDefesa= Fases.faseBloqueio.new()
		dano= Fases.faseDano.new()
		principal2= Fases.fasePrincipal2.new()
		final= Fases.faseFinal.new()
		listaFases = [inicio,compra,principal1,escolherAtaque,escolherDefesa,dano,principal2,final] 
		for item in listaFases:
			item.jogador=self
	
class ItemPilha:
	
	var id
	var jogador
	var combate
	var executado=false;
	var executando=false;
	
	func _init(combate,jogador):
		id=Classes.contId
		Classes.contId+=1
		self.combate=combate
		self.jogador=jogador
		
	func executa(delta):
		if(!executando):
			preExecucao(delta)
			executando= true
		main(delta)
		
		
	func preExecucao(delta):
		pass
		
	func main(delta):
		executado=true
		 
class InputUsuario:
	var jogador
	var tipo
	var obj
	
	func _init(jogador,tipo,obj=null):
		self.jogador=jogador
		self.tipo=tipo
		self.obj=obj
