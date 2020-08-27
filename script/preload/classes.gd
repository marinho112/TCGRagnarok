extends Node


class jogador:
	
	var personagem
	var time
	var ai
	
	var listaBaralho=[]
	var listaMao=[]
	var listaCampoMonstro=[]
	var listaEquipamento=[]
	var listaCemiterio=[]
	
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
	
	
	var areaMao
	var areaMiniatura
	var areaZenys
	var areaAtaque
	var areaDefesa
	
	var zeny = 1
	var maxZeny = 1
	
	var ativado = false
	
	func definirAreas(mao,miniatura,zeny,ataque,defesa):
		
		areaMao =mao
		mao.definirJogador(self)
		areaMiniatura=miniatura
		miniatura.jogador = self
		areaZenys=zeny
		zeny.setJogador(self)
		areaAtaque=ataque
		areaDefesa=defesa
