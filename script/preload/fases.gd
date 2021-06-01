extends Node

var faseId=0;

class fase:
	
	var id
	var jogador
	var controlador 
	var mao 
	var listaInicioJogador=[]
	var listaFimJogador=[]
	var listaInicioOponente=[]
	var listaFimOponente=[]
	
	func _init():
		id=Fases.faseId;
		Fases.faseId+=1;
		
		
	func inicio(delta):
		definicao(delta)
		controlador.resolveHabilidades(listaInicioJogador,listaInicioOponente)
		return 1
	
	func main(delta):
		return 1
		
	func fim(delta):
		controlador.resolveHabilidades(listaFimJogador,listaFimOponente)
		return 1
		
	func definicao(delta):
		controlador = jogador.jogador.controlador
		mao = controlador.get_node("controladorMao/mao")
	
class inicioDoJogo extends fase:
	var comprado=false
	
	func definicao(delta):
		.definicao(delta)
		print("Jogo Iniciado")
		for i in (Constante.VALOR_CARTAS_INICIAIS*2):
			if(i< Constante.VALOR_CARTAS_INICIAIS):
				controlador.get_node("controladorBaralho").comprarCarta(controlador.jogador)
			elif((i>= Constante.VALOR_CARTAS_INICIAIS)and(i<= (Constante.VALOR_CARTAS_INICIAIS*2))):
				controlador.get_node("controladorBaralho").comprarCarta(controlador.oponente)
		
		listaInicioJogador=jogador.jogador.listaInicioPartida
		#listaFimJogador=jogador.jogador.
		listaInicioOponente=controlador.get_oponente(jogador.jogador).listaInicioPartida
		#listaFimOponente=get_oponente(jogador.jogador).
		
		
	
	func main(delta):
		
		controlador.get_node("controladorDeFases").selecionarFase(Constante.FASE_PRINCIPAL1)
		controlador.get_node("controladorDeFases").inicioDoJogo=null
		return 0
		
	func fim(delta):
		return 1

class faseInicial extends fase:
	
	func definicao(delta):
		.definicao(delta)
		print("Fase Inicial")
		controlador.get_node("controladorCampo/ControladorCartas").defesa = false
		listaInicioJogador=jogador.jogador.listaFaseInicial
		#listaFimJogador=jogador.jogador.
		listaInicioOponente=controlador.get_oponente(jogador.jogador).listaFaseInicial
		#listaFimOponente=get_oponente(jogador.jogador).
		
	
	func main(delta):
		
		if(jogador.jogador.maxZeny < 10):
			jogador.jogador.maxZeny+=1
		jogador.jogador.zeny=jogador.jogador.maxZeny
		jogador.jogador.areaZenys.atualizarZeny()
		
		return 1
		
	func fim(delta):
		return 1
		
class faseCompra extends fase:
	var comprado=false
	
	func definicao(delta):
		.definicao(delta)
		print("Fase Compra")
		listaInicioJogador=jogador.jogador.listaFaseCompra
		#listaFimJogador=jogador.jogador.
		listaInicioOponente=controlador.get_oponente(jogador.jogador).listaFaseCompra
		#listaFimOponente=get_oponente(jogador.jogador).
	
	func main(delta):
		if(comprado):
			comprado=false
			return 1
		controlador.get_node("controladorBaralho").comprarCarta(jogador.jogador)
		comprado=true
		return 0
		
	func fim(delta):
		return 1
		
class fasePrincipal1 extends fase:
	
	var numFasePrincipal=1
	
	func definicao(delta):
		.definicao(delta)
		print("Fase Principal "+str(numFasePrincipal))
		controlador.get_node("controladorCampo/ControladorCartas").podeJogar = true
		if(numFasePrincipal==1):
			listaInicioJogador=jogador.jogador.listaFasePrincipal1
			#listaFimJogador=jogador.jogador.
			listaInicioOponente=controlador.get_oponente(jogador.jogador).listaFasePrincipal1
			#listaFimOponente=get_oponente(jogador.jogador).
		else:
			listaInicioJogador=jogador.jogador.listaFasePrincipal2
			#listaFimJogador=jogador.jogador.
			listaInicioOponente=controlador.get_oponente(jogador.jogador).listaFasePrincipal2
			#listaFimOponente=get_oponente(jogador.jogador).
			
	
	func main(delta):
		var campo=controlador.get_node("controladorCampo")
		var areaAtk= campo.retornaListaAreas(1,1,true)
		if((areaAtk.size()>0) and (numFasePrincipal==1)):
			campo.get_node("btnAzul").mudaEstado(Constante.INPUT_BTN_AZUL_ATAQUE)
		else:
			campo.get_node("btnAzul").mudaEstado(Constante.INPUT_BTN_DESATIVADO)
		campo.get_node("btnVermelho").mudaEstado(Constante.INPUT_BTN_VERMELHO)
		var input= controlador.inputAtual
		if(input==null):
			return 0
		if(input.jogador.jogador != controlador.jogador):
			print("Jogador Errado")
		match input.tipo:
			Constante.INPUT_JOGAR_CARTA:
				var areaRelevante =input.obj[0]
				var cartaSelecionada =input.obj[1] 
				if (areaRelevante != null):
					var card = mao.jogar(cartaSelecionada,areaRelevante)
					if(card != null):
						var lista = card.carta.listaPalavraChave
						for elemento in lista:
							if (elemento.id == 4):
								card.imovel=true
				mao.selecionaCarta(null)
					
			Constante.INPUT_BTN_AZUL_ATAQUE:
				return 1
			Constante.INPUT_BTN_VERMELHO:
				controlador.get_node("controladorDeFases").selecionarFase(Constante.FASE_FINAL)
		return 0
		
	func fim(delta):
		return 1
		
		
		
class faseAtaque extends fase:
	
	func definicao(delta):
		.definicao(delta)
		print("Fase Ataque")
		listaInicioJogador=jogador.jogador.listaFaseCombate
		#listaFimJogador=jogador.jogador.
		listaInicioOponente=controlador.get_oponente(jogador.jogador).listaFaseCombate
		#listaFimOponente=get_oponente(jogador.jogador).
	
	func main(delta):
		controlador.get_node("controladorCampo").get_node("btnVermelho").mudaEstado(Constante.INPUT_BTN_DESATIVADO)
		var tipJogador= jogador.jogador.time+1
		
		var tipOponente = controlador.get_oponente(jogador.jogador).time+1
		
		
		var areaAtk= controlador.get_node("controladorCampo").retornaListaAreas(tipJogador,1,true)
		var areaDef= controlador.get_node("controladorCampo").retornaListaAreas(tipOponente,2,true)
		controlador.get_node("controladorCampo").controlarDestaque(tipJogador)
		return 1
		
	func fim(delta):
		return 1
		
class faseBloqueio extends fase:
	
	func definicao(delta):
		.definicao(delta)
		print("Fase Bloqueio")
		controlador.get_node("controladorCampo/ControladorCartas").defesa = true
		#listaInicioJogador=jogador.jogador.
		#listaFimJogador=jogador.jogador.
		#listaInicioOponente=get_oponente(jogador.jogador).
		#listaFimOponente=get_oponente(jogador.jogador).
	
	func main(delta):
		controlador.get_node("controladorCampo").get_node("btnAzul").mudaEstado(Constante.INPUT_BTN_AZUL_BLOQUEIO)
		controlador.get_node("controladorCampo").get_node("btnVermelho").mudaEstado(Constante.INPUT_BTN_DESATIVADO)
		var input= controlador.inputAtual
		if(input==null):
			return 0
		match input.tipo:
			Constante.INPUT_BTN_AZUL_BLOQUEIO:
				return 1
		return 0
		
	func fim(delta):
		return 1
		
class faseDano extends fase:
	
	var momento
	var area
	var oponente
	var listaCartasVerificandoVida
	
	func definicao(delta):
		.definicao(delta)
		print("Fase Dano")
		momento=0
		area=controlador.get_node("controladorCampo")
		oponente=controlador.get_oponente(jogador.jogador)
		#listaInicioJogador=jogador.jogador.
		#listaFimJogador=jogador.jogador.
		#listaInicioOponente=get_oponente(jogador.jogador).
		#listaFimOponente=get_oponente(jogador.jogador).
	
	func main(delta):
		controlador.get_node("controladorCampo").get_node("btnAzul").mudaEstado(Constante.INPUT_BTN_DESATIVADO)#Constante.INPUT_BTN_AZUL_DANO)
		controlador.get_node("controladorCampo").get_node("btnVermelho").mudaEstado(Constante.INPUT_BTN_DESATIVADO)
		var input= controlador.inputAtual
		match momento:
			0:
				for i in 6:
					var combate = combatePilha.new(controlador,jogador.jogador,oponente,i)
					controlador.get_node("controladorPilha").adicionarFinalDaPilha(combate)
				momento=1
			1:
				var jogAtaq = area.retornaCartasArea(jogador.jogador.areaAtaque)
				var jogDef= area.retornaCartasArea(jogador.jogador.areaDefesa)
				var opoAtaq= area.retornaCartasArea(oponente.areaAtaque)
				var opoDef= area.retornaCartasArea(oponente.areaDefesa)
				listaCartasVerificandoVida= jogAtaq+jogDef+opoAtaq+opoDef
				for vida in listaCartasVerificandoVida:
					controlador.get_node("controladorCampo").verificarMorte(vida)
				momento=2
			2:
				return 1
		return 0
		
	func fim(delta):
		controlador.get_node("controladorCampo").controlarDestaque(0)
		return 1
		
class fasePrincipal2 extends fasePrincipal1:
	
	func _init():
		numFasePrincipal=2
		
		
		
class faseFinal extends fase:
	
	func definicao(delta):
		.definicao(delta)
		print("Fase Final")
		controlador.get_node("controladorCampo/ControladorCartas").podeJogar = false
		listaInicioJogador=jogador.jogador.listaFaseFinal
		#listaFimJogador=jogador.jogador.
		listaInicioOponente=controlador.get_oponente(jogador.jogador).listaFaseFinal
		#listaFimOponente=get_oponente(jogador.jogador).
	
	func main(delta):
		return 1
		
	func fim(delta):
		return 1
		
class combatePilha extends Classes.ItemPilha:
	
	var oponente
	var tipJogador
	var tipOponente
	var campo
	var subFase
	
	func _init(combate,jogador,oponente,subFase).(combate,jogador):
		tipJogador= jogador.time+1
		tipOponente = oponente.time+1
		campo=combate.get_node("controladorCampo")
		self.oponente=oponente
		self.subFase=subFase
		
	func main(delta):
		executado=true
		var areaAtk= campo.retornaListaAreas(tipJogador,1)
		if((areaAtk[subFase].carta != null)):
			var areaDef= campo.retornaListaAreas(tipOponente,2)
			if(areaDef[subFase].carta != null):
				executado=campo.confrontar(areaAtk[subFase].carta,areaDef[subFase].carta)
			elif(oponente.time == 0):
				executado=campo.confrontar(areaAtk[subFase].carta,campo.get_node("Personagem"),false)
			else:
				executado=campo.confrontar(areaAtk[subFase].carta,campo.get_node("Oponente"),false)
		
		
