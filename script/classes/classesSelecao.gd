extends Node

class selecaoCampoItemPilha extends Classes.ItemPilha:
	
	var selecionaProprioAtaque=false
	var selecionaPropriaDefesa=false
	var selecionaOponenteAtaque=false
	var selecionaOponenteDefesa=false
	var numAlvos
	var proximoItemPilha
	var tipoDeSelecao
	var enviado = false
	var listaRetorno=[]
	var listaCartasCriar
	var listaCartas = []
	
	func _init(combate,jogador,proximoItemPilha,tipoDeSelecao,modo=3,numAlvos=1,listaCartasCriar=[]).(combate,jogador):
		self.numAlvos=numAlvos
		self.proximoItemPilha=proximoItemPilha
		self.tipoDeSelecao=tipoDeSelecao
		self.listaCartasCriar=listaCartasCriar
		if((modo|14)==15):
			selecionaProprioAtaque=true
		if((modo|13)==15):
			selecionaPropriaDefesa=true
		if((modo|11)==15):
			selecionaOponenteAtaque=true
		if((modo|7)==15):
			selecionaOponenteDefesa=true
			
	
	func preExecucao(delta):
		ativar()
		
	func main(delta):
		definirBtns(delta)
		if(!enviado):
			if(combate.inputAtual!=null):
				if(combate.inputAtual.jogador == combate.get_node("controladorDeFases").retornaJogador()):
					match combate.inputAtual.tipo:
						Constante.INPUT_BTN_VERMELHO_CANCEL:
							print("Vermelho")
							cancelar()
						Constante.INPUT_BTN_AZUL_ENVIAR:
							enviar()
						Constante.INPUT_BTN_AZUL_PRONTO:
							enviar()
			
			#Definir tipo de seleção
			match tipoDeSelecao:
				Constante.TIPO_SELECAO_CAMPO:
					selecao(delta,Constante.GRUPO_CARTA_EM_CAMPO,jogador)
				Constante.TIPO_SELECAO_MONSTRO_CAMPO:
					selecao(delta,Constante.GRUPO_CARTA_REDUZIDA,jogador)
				Constante.TIPO_SELECAO_MAO:
					selecao(delta,Constante.GRUPO_CARTA_NA_MAO,jogador)
				Constante.TIPO_SELECAO_AREA_FLUTUANTE:
					selecao(delta,Constante.GRUPO_CARTA_FLUTUANTE,jogador)
		else:
			desativar()
			
	
	func cancelar():
		desativar()
	
	func enviar():
		if(listaRetorno.size()>0):
			var novaLista=[]
			for item in listaRetorno:
				novaLista.append(item.carta)
			proximoItemPilha.listaSelecionados=novaLista
			combate.get_node("controladorPilha").adicionarTopoDaPilha(proximoItemPilha)
			enviado=true

	func definirBtns(delta):
		combate.get_node("controladorCampo/btnVermelho").mudaEstado(Constante.INPUT_BTN_VERMELHO_CANCEL)
		var btnAzul=combate.get_node("controladorCampo/btnAzul")
		
		if(listaRetorno.size()==0):
			btnAzul.mudaEstado(Constante.INPUT_BTN_DESATIVADO)
		elif(listaRetorno.size()<numAlvos):
			btnAzul.mudaEstado(Constante.INPUT_BTN_AZUL_ENVIAR)
		else:
			btnAzul.mudaEstado(Constante.INPUT_BTN_AZUL_PRONTO)
		
	func selecao(delta,tipo,jogador):
		if Input.is_action_just_pressed("clicar"):
			var area = receberAreaMaisRelevante(combate.cursorMouse,tipo,jogador)
			if(area!=null):
				var posiArea = listaRetorno.find(area)
				if(posiArea==-1):
					if(listaRetorno.size()<numAlvos):
						listaRetorno.append(area)
						area.defineBrilho(true)
				else:
					listaRetorno.remove(posiArea)
					area.defineBrilho(false)
				
				
	func receberAreaMaisRelevante(cartaSelecionada,tipo,jogador):
		var lista = cartaSelecionada.get_overlapping_areas()
		var menorArea = null
		var menorDiferenca
		#controlar cartas no campo.
		for area in lista:
			print(jogador)
			if(area.is_in_group(tipo)):
				if((jogador!=null)and area.carta.dono == jogador):
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
		combate.get_node("controladorCampo/ControladorCartas").ativado = false
		combate.get_node("controladorMao/mao").ativado = false
		combate.get_node("controladorMao/maoOponente").ativado = false
		
	func desativar():
		
		for item in listaRetorno:
			item.get_node("brilho").set_visible(false)
				
		for carta in listaCartas:
			carta.queue_free()
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
					var animacao = item.instance()
					animacao.definirPai(combate)
					animacao.play(dono,[selsecionado],pause,velo)
			Constante.OBJ_EFEITO:
				item.ativar(carta,alvo)
		executado=true
	
