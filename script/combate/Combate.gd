extends Node2D

#listas

var listaTimes =[]
var listaJogadores =[Classes.jogador.new(),Classes.jogador.new()]
var listaPausa=[false,false,false,false,false]


var ativado = true
var cursorMouse 

var fase = -2
var subFase = 0
var rodada=0
var turno = 0
var jogador 
var oponente
var CARTAS_INICIAIS=5

var confrontarAtaques1 = 0
var confrontarAtaques2 = 0


func _ready():
	cursorMouse= get_parent().get_node("Mouse")
	$btnAzul.set_text(0,false)
	$btnVermelho.set_text(0,false,false)
	for x in 2:
		for i in 60:
			listaJogadores[x].listaBaralho.append(ControlaDados.carregaCartaAleatoria())
			
	listaJogadores[0].time = 0
	listaJogadores[1].time = 1
	
	listaJogadores[0].ativado=true
	jogador = listaJogadores[0]
	oponente = listaJogadores[1]
	$ControladorCartas.jogador=listaJogadores[0]
	$mao.definirJogador(listaJogadores[0])
	$maoOponente.definirJogador(listaJogadores[1])
	$Personagem.atualizarPersonagem(ControlaDados.carregaPersonagemPorID((randi()%18+8)))
	$Oponente.atualizarPersonagem(ControlaDados.carregaPersonagemPorID((randi()%18)+8))
	$Personagem.carta.revelada=true
	$Oponente.carta.revelada=true
	set_process(true)

func _process(delta):
	
	if ativado:
		if((fase==-2)and(turno==0)):
			if(comecarJogo()):
				fase = -1
				subFase = 0
				
		elif((fase==-1)and(turno==0)):
			if(inicioPartida()):
				fase = 0
				subFase = 0
				
		elif((jogador==listaJogadores[0])and(fase>=0)):
		
			match(fase):
				
				0:
					#Inicio do fase
					if(faseInicial()):
						fase = 1
						subFase = 0
				1:
					#Comprar Carta
					if(inicioFaseDeCompra()):
						fase = 2
						subFase = 0
				2:
					#Main fase 1
					if(faseDeCompra()):
						fase = 3
						subFase = 0
				3:
					#Main fase 1
					if(inicioFasePrincipal1()):
						fase = 4
						subFase = 0
				4:
					#Main fase 1
					if(fasePrincipal1()):
						fase = 5
						subFase = 0
						
				5:
					#Ataque
					if(inicioFaseCombate()):
						fase = 6
						subFase = 0
				6:
					#Ataque
					if(faseCombate()):
						fase = 7
						subFase = 0
				7:
					if(realizarAtaque()):
						fase = 8
						subFase = 0
				8:
					#Main fase 2
					if(inicioFasePrincipal2()):
						fase = 9
						subFase = 0
				9:
					#Main fase 2
					if(fasePrincipal2()):
						fase = 10
						subFase = 0
				10:
					#Encerrar fase
					if(inicioFaseFinal()):
						fase = 11
						subFase = 0
				11:
					#Encerrar fase
					if(faseFinal()):
						fase = 12
						subFase = 0
				12:
					fimTurno()
	
		else:
			#chamar AI!
			fimTurno()
		
		
func fimTurno():
	print ("ACABOU O TURNO "+str(turno))
	fase = 0
	subFase = 0
	if(turno == (listaJogadores.size()-1)):
		rodada+=1
	turno+=1
	var aux = jogador
	jogador = oponente
	oponente = aux
	
func resolveHabilidades(listaJogador,listaOponente):
	var qtdJogador = listaJogador.size() 
	var qtdOponente = listaOponente.size()
	if((qtdJogador+qtdOponente)<subFase):
		if(subFase<qtdJogador):
			listaJogador[subFase].ativar()
		else:
			listaOponente[subFase-qtdJogador].ativar()
		return false
	else:
		return true
	
func comecarJogo():
	if(subFase==0):
		pausar(2)
	if(subFase< (CARTAS_INICIAIS*2)):
		if(subFase< CARTAS_INICIAIS):
			comprarCarta(jogador)
		elif((subFase>= CARTAS_INICIAIS)and(subFase<= (CARTAS_INICIAIS*2))):
			comprarCarta(oponente)
	else:
		pausar(0)
		return true
			
	subFase+=1
	return false
	
	
func inicioPartida():
	if(resolveHabilidades(jogador.listaInicioPartida,oponente.listaInicioPartida)):
		return true
	else:
		return false
	

func faseInicial():
	if(resolveHabilidades(jogador.listaFaseInicial,oponente.listaFaseInicial)):
		return true
	else:
		return false
	
func inicioFaseDeCompra():
	if(resolveHabilidades(jogador.listaFaseCompra,oponente.listaFaseCompra)):
		return true
	else:
		return false

func faseDeCompra():
	comprarCarta(jogador)
	return true

func fasePrincipal():
	
	var tipJogador= jogador.time+1
	var tipOponente = oponente.time+1
	var areaAtk= retornaListaAreas(tipJogador,1,true)
	var areaDef= retornaListaAreas(tipOponente,2,true)
	if((areaAtk.size()>0)):
		$btnAzul.set_text(1,true)
		$btnAzul.estado=1
	else:
		$btnAzul.set_text(0,false)
		$btnAzul.estado=0
		
	if(subFase==0):
		
		$btnVermelho.set_text(2,true,true)
		$btnVermelho.estado = 1
		controlarDestaque(0)
		subFase=1
		return false
	elif(subFase==1):
		return false
	else:
		return true
func inicioFasePrincipal1():
	if(resolveHabilidades(jogador.listaFasePrincipal1,oponente.listaFasePrincipal1)):
		return true
	else:
		return false

func fasePrincipal1():
	return fasePrincipal()

func inicioFaseCombate():
	if(resolveHabilidades(jogador.listaFaseCombate,oponente.listaFaseCombate)):
		return true
	else:
		return false
		
func faseCombate():
	
	match subFase:
		0:
			var tipJogador= jogador.time+1
			var tipOponente = oponente.time+1
			var areaAtk= retornaListaAreas(tipJogador,1,true)
			var areaDef= retornaListaAreas(tipOponente,2,true)
			if(oponente.listaCampoMonstro.size()==0):
				subFase=3
			controlarDestaque(tipJogador)
		1: 
			#aguardar Oponente
			$btnAzul.estado=0
			$btnAzul.set_text(0,false)
		2: 
			#aguardar Oponente
			$btnAzul.estado=1
			$btnAzul.set_text(1,false)
		3:
			#Confirmar Ataque
			$btnAzul.estado=1
			$btnAzul.set_text(5,true)
			$btnVermelho.set_text(0,false,false)
		4:
			$btnAzul.estado=0
			$btnAzul.set_text(0,false)
			return true
	return false


func realizarAtaque():
	if(subFase <6):
		var tipJogador= jogador.time+1
		var tipOponente = oponente.time+1
		var areaAtk= retornaListaAreas(tipJogador,1)
		var retorno = true
		if(areaAtk[subFase].carta != null):
			var areaDef= retornaListaAreas(tipOponente,2)
			if(areaDef[subFase].carta != null):
				retorno=confrontar(areaAtk[subFase].carta,areaDef[subFase].carta)
			elif(oponente.time == 0):
				retorno=confrontar(areaAtk[subFase].carta,$Personagem,false)
			else:
				retorno=confrontar(areaAtk[subFase].carta,$Oponente,false)
		if (retorno):
			subFase+=1
		
		return false
	else:
		return true
	return false
func inicioFasePrincipal2():
	if(resolveHabilidades(jogador.listaFasePrincipal2,oponente.listaFasePrincipal2)):
		return true
	else:
		return false

func fasePrincipal2():
	return fasePrincipal()

func inicioFaseFinal():
	if(resolveHabilidades(jogador.listaFaseFinal,oponente.listaFaseFinal)):
		return true
	else:
		return false
	
func faseFinal():
	$btnAzul.estado=0
	$btnAzul.set_text(0,false)
	$btnVermelho.set_text(0,false,false)
	return true
	
func comprarCarta(jogadorr):
	if(jogadorr.listaBaralho.size()>0):
		if(jogadorr.listaMao.size()<10):
			var animacao=load("res://cenas/animacoes/animacaoComprar.tscn").instance()
			animacao.definirPai(self)
			animacao.play(jogadorr)
		else:
			#DESCARTAR CARTA COMPRADA
			pass
	else:
		print("Perdeu!")
		
func executarCompra(jogadorr):
	#jogadorr.listaMao.append(jogadorr.listaBaralho[0])
	var carta = jogadorr.listaBaralho[0]
	if(jogadorr.time==0):
		carta.revelada = true
		$mao.adicionaCartaMao(carta)
	else:
		$maoOponente.adicionaCartaMao(carta)
	jogadorr.listaBaralho.remove(0)
	
func retornaListaAreas(jogador,tipo,cartas = false):
	var alvo
	match jogador:
		1:
			match tipo:
				1:
					alvo=$Container/Jogador1Ataque
				2:
					alvo=$Container/Jogador1Defesa
		2:
			match tipo:
				1:
					alvo=$Container/Jogador2Ataque
				2:
					alvo=$Container/Jogador2Defesa
	
	var lista = []
	for item in alvo.get_children():
		if item.is_in_group(Constante.GRUPO_AREA_CARTA):
			if cartas:
				var carta = item.carta
				if carta != null:
					lista.append(carta)
			else:
				lista.append(item)
	
	return lista

func pausar(intensidade):
	if(intensidade == 0):
		$ControladorCartas.ativado = $ControladorCartas.ativado or listaPausa[0]
		ativado = ativado or listaPausa[1]
		$mao.ativado = $mao.ativado or listaPausa[2]
		$maoOponente.ativado = $maoOponente.ativado or listaPausa[2]
		$Personagem.ativado = $Personagem.ativado or listaPausa[2]
		$Oponente.ativado = $Oponente.ativado or listaPausa[2]
		$Personagem.ativado = $Personagem.ativado or listaPausa[2]
		for item in listaPausa:
			item = false
			
	if(intensidade > 0):
		$ControladorCartas.ativado = false
		listaPausa[0] = true
	if(intensidade > 1):
		ativado = false
		listaPausa[1]=true
	if(intensidade >2):
		$mao.ativado = false
		$Personagem.ativado = false
		$Oponente.ativado = false
		$maoOponente.ativado = false
		$Personagem.ativado = false
		listaPausa[2]=true
		

func controlarDestaque(atacante):
	var vector = [$Container/Jogador1Ataque,$Container/Jogador1Defesa,$Container/Jogador2Ataque,$Container/Jogador2Defesa]
	match atacante:
		0:
			defEscala(vector[0],Vector2(1,0.65))
			defEscala(vector[1],Vector2(1,0.8))
			defEscala(vector[2],Vector2(1,0.65))
			defEscala(vector[3],Vector2(1,0.8))
			
		1:
			defEscala(vector[0],Vector2(1,0.8))
			defEscala(vector[1],Vector2(1,0.65))
			defEscala(vector[2],Vector2(1,0.65))
			defEscala(vector[3],Vector2(1,0.8))
			
		2:
			defEscala(vector[0],Vector2(1,0.65))
			defEscala(vector[1],Vector2(1,0.8))
			defEscala(vector[2],Vector2(1,0.8))
			defEscala(vector[3],Vector2(1,0.65))

func defEscala(area,escala):
	area.set_scale(escala)
	for item in area.get_children():
		if item.is_in_group(Constante.GRUPO_AREA_CARTA):
			var carta = item.carta
			if carta != null:
				$ControladorCartas.positionAreaCarta(item,carta)
				

func confrontar(golpeador,alvo,val = true):
	if((confrontarAtaques1+confrontarAtaques2) == 0):
		confrontarAtaques1 = 1
		confrontarAtaques2 = 1
		
		if(golpeador.carta.temPalavraChave(15)):
			confrontarAtaques1 +=1
		if(alvo.carta.temPalavraChave(15)):
			confrontarAtaques2 +=1
			
		if(golpeador.carta.temPalavraChave(1)):
			confrontarAtaques2=0
		if(alvo.carta.temPalavraChave(12) and val):
			confrontarAtaques1=0
		

	var iniciativa = [golpeador.carta.temPalavraChave(2),alvo.carta.temPalavraChave(2)]
	if((iniciativa[0]and(confrontarAtaques1>0)) or (iniciativa[1] and (confrontarAtaques2>0))):
		if(iniciativa[0] and (confrontarAtaques1>0)):
			golpear(golpeador,alvo)
			confrontarAtaques1 -= 1
		if(iniciativa[1] and (confrontarAtaques2 > 0)):
			golpear(alvo,golpeador)
			confrontarAtaques2 -=1
		return finalizaConfronto()
	if(confrontarAtaques1>0):
		golpear(golpeador,alvo)
		confrontarAtaques1 -= 1
	if(confrontarAtaques2 > 0):
		golpear(alvo,golpeador)
		confrontarAtaques2 -=1
	return finalizaConfronto()
	
func finalizaConfronto():
	if((confrontarAtaques1+confrontarAtaques2) == 0):
		confrontarAtaques1 = 0
		confrontarAtaques2 = 0
		return true
	else:
		return false
		
func golpear(golpeador,alvo):
	var animacao = load("res://cenas/animacoes/animacaoGolpear.tscn").instance()
	animacao.definirPai(self)
	animacao.set_global_position(golpeador.get_global_position())
	animacao.play(golpeador,[alvo])
	#var retorno = golpeador.carta.golpear(alvo.carta)
	#print(retorno)
	
	
