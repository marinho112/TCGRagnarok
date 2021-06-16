extends Node

class selecaoCampoItemPilha extends Classes.ItemPilha:
	
	var listaPosicoes=[]
	var jogadoresAlvo=[]
	var numAlvos
	var proximoItemPilha
	var tipoDeSelecao
	var enviado = false
	var listaRetorno=[]
	var listaCartasCriar
	var listaCartas = []
	var timerSelecao=0
	var oponente
	var scroll
	
	func _init(combate,jogador,proximoItemPilha,tipoDeSelecao,modo=15,numAlvos=1,listaCartasCriar=[]).(combate,jogador):
		self.numAlvos=numAlvos
		self.proximoItemPilha=proximoItemPilha
		self.tipoDeSelecao=tipoDeSelecao
		self.listaCartasCriar=listaCartasCriar
		self.oponente=combate.get_oponente(jogador)
		if((modo|14)==15):
			listaPosicoes.append(Constante.GRUPO_AREA_CARTA_ATAQUE)
			jogadoresAlvo.append(jogador)
		if((modo|13)==15):
			listaPosicoes.append(Constante.GRUPO_AREA_CARTA_DEFESA)
			if(jogadoresAlvo.find(jogador)==-1):
				jogadoresAlvo.append(jogador)
		if((modo|11)==15):
			listaPosicoes.append(Constante.GRUPO_AREA_CARTA_ATAQUE)
			jogadoresAlvo.append(oponente)
		if((modo|7)==15):
			listaPosicoes.append(Constante.GRUPO_AREA_CARTA_DEFESA)
			if(jogadoresAlvo.find(oponente)==-1):
				jogadoresAlvo.append(oponente)
		if(tipoDeSelecao==Constante.TIPO_SELECAO_CAMPO):
			listaPosicoes.append(Constante.GRUPO_PERSONAGEM)
	
	func preExecucao(delta):
		ativar()
		
	func main(delta):
		if(jogador!=combate.jogador):
			jogador.ai.modoSelecao(self)
		definirBtns(delta)
		if(!enviado):
			if(combate.inputAtual!=null):
				if(combate.inputAtual.jogador == combate.get_node("controladorDeFases").retornaJogador()):
					match combate.inputAtual.tipo:
						Constante.INPUT_BTN_VERMELHO_CANCEL:
							cancelar()
						Constante.INPUT_BTN_AZUL_ENVIAR:
							enviar()
						Constante.INPUT_BTN_AZUL_PRONTO:
							enviar()
			#Definir tipo de seleção
			match tipoDeSelecao:
				Constante.TIPO_SELECAO_CAMPO:
					selecao(delta,Constante.GRUPO_CARTA_EM_CAMPO)
				Constante.TIPO_SELECAO_MONSTRO_CAMPO:
					selecao(delta,Constante.GRUPO_CARTA_REDUZIDA)
				Constante.TIPO_SELECAO_MAO:
					selecao(delta,Constante.GRUPO_CARTA_NA_MAO)
				Constante.TIPO_SELECAO_AREA_FLUTUANTE:
					selecao(delta,Constante.GRUPO_CARTA_FLUTUANTE)
		else:
			desativar()
			
	
	func desenhaListaCartas():
		var loadScroll=load("res://cenas/ferramentas/ScrollingCards.tscn")
		scroll=loadScroll.instance()
		combate.add_child(scroll)
		scroll.set_z_index(99)
		scroll.prepara(listaCartas,listaCartasCriar,combate)
		
	func cancelar():
		print("Seleção cancelada!")
		desativar()
	
	func enviar():
		print("Enviada Selecao")
		if(listaRetorno.size()>0):
			var novaLista=[]
			for item in listaRetorno:
				novaLista.append(item.carta)
			proximoItemPilha.listaSelecionados=novaLista
			combate.get_node("controladorPilha").adicionarTopoDaPilha(proximoItemPilha)
			enviado=true
			combate.get_node("controladorCampo/btnAzul").mudaEstado(Constante.INPUT_BTN_DESATIVADO)

	func definirBtns(delta):
		var btnVermelho=combate.get_node("controladorCampo/btnVermelho")
		if(jogador==combate.jogador):
			btnVermelho.mudaEstado(Constante.INPUT_BTN_VERMELHO_CANCEL)
		else:
			btnVermelho.mudaEstado(Constante.INPUT_BTN_DESATIVADO)
		
		var btnAzul=combate.get_node("controladorCampo/btnAzul")
		
		if((listaRetorno.size()==0) or enviado):
			btnAzul.mudaEstado(Constante.INPUT_BTN_DESATIVADO)
		elif(listaRetorno.size()<numAlvos):
			btnAzul.mudaEstado(Constante.INPUT_BTN_AZUL_ENVIAR)
		else:
			btnAzul.mudaEstado(Constante.INPUT_BTN_AZUL_PRONTO)
		
	func selecao(delta,tipo):
		var area
		if (Input.is_action_just_pressed("clicar")and(timerSelecao<=0)and(jogador==combate.jogador)):
			area = receberAreaMaisRelevante(combate.cursorMouse,tipo,oponente)
			timerSelecao=0.5
		else:
			timerSelecao-=delta
		
		if((scroll!=null)and(scroll.btnClicked!=null)):
			area=scroll.btnClicked
			scroll.btnClicked=null
			
		if(area!=null):
			#print(area.carta.recebeNome())
			var posiArea = listaRetorno.find(area)
			if(posiArea==-1):
				if(listaRetorno.size()<numAlvos):
					listaRetorno.append(area)
					area.defineBrilho(true)
			else:
				listaRetorno.remove(posiArea)
				area.defineBrilho(false)
			#print(listaRetorno)
			
	func receberAreaMaisRelevante(cartaSelecionada,tipo,jogador):
		var lista = cartaSelecionada.get_overlapping_areas()
		var menorArea = null
		var menorDiferenca
		#controlar cartas no campo.
		for area in lista:
			if(area.is_in_group(tipo)):
				var entrar=false
				for posicao in listaPosicoes:
					if(area.posicaoJogo.is_in_group(posicao)):
						for item in jogadoresAlvo:
							if(area.carta.dono == item):
								entrar=true
				if((jogador!=null) and entrar):
					if(menorArea==null):
						menorArea=area
						var posicao = area.get_global_position() - cartaSelecionada.get_global_position()
						menorDiferenca = Ferramentas.positivo(posicao.x)+Ferramentas.positivo(posicao.y)
					else:
						var posicao = area.get_global_position() - cartaSelecionada.get_global_position()
						if((Ferramentas.positivo(posicao.x)+Ferramentas.positivo(posicao.y))<menorDiferenca):
		
							menorDiferenca = Ferramentas.positivo(posicao.x)+Ferramentas.positivo(posicao.y)
							menorArea=area
						
		return menorArea
	
	func ativar():
		combate.get_node("controladorMao/mao").ativado = false
		combate.get_node("controladorMao/maoOponente").ativado = false
		if(tipoDeSelecao == Constante.TIPO_SELECAO_AREA_FLUTUANTE):
			desenhaListaCartas()
			combate.get_node("controladorCampo/ControladorCartas").ativado = false
		
		
	func desativar():
		var oponente = combate.get_oponente(combate.get_node("controladorDeFases").retornaJogador().jogador)
		for item in combate.get_node("controladorCampo").retornarTodasAsCartasEmCampo(oponente):
			if(item!=null):
				item.get_node("brilho").set_visible(false)
				
		for carta in listaCartas:
			carta.queue_free()
		if(scroll!=null):
			scroll.queue_free()
		combate.get_node("controladorCampo/ControladorCartas").ativado = true
		combate.get_node("controladorMao/mao").ativado = true
		combate.get_node("controladorMao/maoOponente").ativado = true
		executado=true

class itemSelecaoPilha extends Classes.ItemPilha:
	
	var carta
	var alvo
	var item
	var tipoItem
	var listaSelecionados
	var pause= null
	var velo = 1.0
	var dono
	
	func _init(combate,jogador,item,tipoItem,carta=null,alvo=null).(combate,jogador):
		self.carta=carta
		self.alvo=alvo
		self.item=item
		self.tipoItem=tipoItem
		dono=jogador
		
	func main(delta):
		match tipoItem:
			Constante.OBJ_ANIMACAO:
				for selsecionado in listaSelecionados:
					var animacao = item
					animacao.definirPai(combate)
					var aniDono=dono
					if(carta!=null):
						aniDono=carta
					animacao.play(aniDono,[selsecionado],pause,velo)
			Constante.OBJ_EFEITO:
				item.ativar(carta,alvo)
		executado=true
	
