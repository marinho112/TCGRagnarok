extends Node2D

#listas

var listaTimes =[]
var listaJogadores =[Classes.jogador.new(),Classes.jogador.new()]
var listaPausa=[false,false,false,false,false]

var verificandoVida = 0
var listaCartasVerificandoVida = []
var ativado = true
var cursorMouse 

var fase = -2
var subFase = 0
var rodada=0
var turno = 0
var jogador 
var oponente
var CARTAS_INICIAIS=Constante.VALOR_CARTAS_INICIAIS
var bloqueado = false
var passeLivre= false
var confrontarAtaques1 = 0
var confrontarAtaques2 = 0

#Novos
var etapaDaFase=0
var inputDoUsuario= []
var inputAtual

func _ready():
	$controladorCampo/zenys.defineZeny(1,1)
	$controladorCampo/zenysOponente.defineZeny(1,1)
	#$zenysOponente.setInvertido(true)
	cursorMouse= get_parent().get_node("Mouse")
	#$btnAzul.set_text(0,false)
	#$btnVermelho.set_text(0,false,false)
	
	for x in 2:
		var sortNum = randi()%1
		var retorno = ControlaDados.carregaDeck("deck00"+str(2+sortNum),listaJogadores[x])
		retorno[1].shuffle()
		listaJogadores[x].listaBaralho = retorno[1]
		listaJogadores[x].personagem = retorno[0]
		#for i in 60:
		#	listaJogadores[x].listaBaralho.append(ControlaDados.carregaCartaAleatoriaIntervalo(1,25,listaJogadores[x]))
			
	listaJogadores[0].time = 0
	listaJogadores[1].time = 1
	listaJogadores[0].ativado=true
	listaJogadores[0].ai = self
	listaJogadores[1].ai = load("res://script/ai/ai.gd").new()
	listaJogadores[1].ai.combate = self
	listaJogadores[0].definirAreas(self,$controladorMao/mao,$controladorCampo/Personagem,$controladorCampo/zenys,$controladorCampo/Container/Jogador1Ataque,$controladorCampo/Container/Jogador1Defesa)
	listaJogadores[1].definirAreas(self,$controladorMao/maoOponente,$controladorCampo/Oponente,$controladorCampo/zenysOponente,$controladorCampo/Container/Jogador2Ataque,$controladorCampo/Container/Jogador2Defesa)
	#listaJogadores[1].ai.definirJogador(listaJogadores[1])
	#print(listaJogadores[0])
	listaJogadores[0].personagem.dono = listaJogadores[0]
	listaJogadores[1].personagem.dono=listaJogadores[1]
	jogador = listaJogadores[0]
	oponente = listaJogadores[1]
	$controladorCampo/ControladorCartas.jogador=listaJogadores[0]
	$controladorMao/mao.definirJogador(listaJogadores[0])
	$controladorMao/maoOponente.definirJogador(listaJogadores[1])
	$controladorCampo/Personagem.atualizarPersonagem(listaJogadores[0].personagem)
	$controladorCampo/Oponente.atualizarPersonagem(listaJogadores[1].personagem)
	listaJogadores[0].personagem.obj=$controladorCampo/Personagem
	listaJogadores[1].personagem.obj=$controladorCampo/Oponente
	$controladorCampo/Personagem.carta.revelada=true
	$controladorCampo/Oponente.carta.revelada=true
	$controladorDeFases.definirJogadores(listaJogadores)
	set_process(true)

func _process(delta):
	if(inputDoUsuario.size()>0):
		inputAtual=inputDoUsuario[0]
	else:
		inputAtual=null
	if($controladorDeAnimacao.executaAnimacoes(delta)):
		if($controladorPilha.resolvePilha(delta)):
			var fase =$controladorDeFases.retornarFaseAtual()
			match etapaDaFase:
				0:
					etapaDaFase+=fase.inicio(delta)
				1:
					etapaDaFase+=fase.main(delta)
				2:
					etapaDaFase+=fase.fim(delta)
				3:
					$controladorDeFases.passaDeFase()
					etapaDaFase=0
				_:
					etapaDaFase=0
	if(inputDoUsuario.size()>0):
		if(inputDoUsuario[0].tipo==Constante.INPUT_JOGAR_CARTA):
			get_node("controladorMao/mao").retornarCarta()
		inputDoUsuario.remove(0)
	
	
#Excluir |TUDO A BAIXO!
func pausar(intensidade):
	if(intensidade == -1):
		return
	if(intensidade == 0):
		$controladorCampo/ControladorCartas.interacaoAvancada = $controladorCampo/ControladorCartas.interacaoAvancada or listaPausa[0]
		$controladorCampo/ControladorCartas.ativado = $controladorCampo/ControladorCartas.ativado or listaPausa[1]
		$controladorMao/mao.ativado = $controladorMao/mao.ativado or listaPausa[2]
		$controladorMao/maoOponente.ativado = $controladorMao/maoOponente.ativado or listaPausa[2]
		$controladorCampo/Personagem.ativado = $controladorCampo/Personagem.ativado or listaPausa[2]
		$controladorCampo/Oponente.ativado = $controladorCampo/Oponente.ativado or listaPausa[2]
		#$controladorCampo/Personagem.ativado = $controladorCampo/Personagem.ativado or listaPausa[2]
		ativado = ativado or listaPausa[3]
		for item in listaPausa:
			item = false
			
	if(intensidade > 0):
		$controladorCampo/ControladorCartas.interacaoAvancada = false
		listaPausa[0] = true
	if(intensidade > 1):
		$controladorCampo/ControladorCartas.ativado = false
		listaPausa[1]=true
	if(intensidade >2):
		$controladorMao/mao.ativado = false
		$controladorCampo/Personagem.ativado = false
		$controladorCampo/Oponente.ativado = false
		$controladorMao/maoOponente.ativado = false
		#$controladorCampo/Personagem.ativado = false
		listaPausa[2]=true
	if(intensidade >3):
		ativado = false
		listaPausa[3]=true
		$controladorCampo/ControladorCartas.ativado = true
	if(intensidade >4):
		$controladorCampo/ControladorCartas.ativado = false

func get_oponente(jogador):
	var oponente= listaJogadores[0]
	if(jogador == oponente):
		oponente= listaJogadores[1]
	return oponente	

func declararVencedor(jogadorVencedor):
	pausar(5)
	if(jogadorVencedor==listaJogadores[0]):
		print("Jogador 1 é o vencedor!")
	else:
		print("Jogador 2 é o vencedor!")

func verificarVencedor():
	if(jogador.personagem.retornaVida()<=0):
		declararVencedor(oponente)
	elif(oponente.personagem.retornaVida()<=0):
		declararVencedor(jogador)

func resolveHabilidades(listaJogador,listaOponente,carta=null,alvo=null):
	var lista= listaJogador+listaOponente
	var listaRemocao=[]
	for habilidade in lista:
		if(habilidade.verificaPai()):
			var itemPilha=habilidadePilha.new(self,$controladorDeFases.retornaJogador().jogador,habilidade,carta,alvo)
			$controladorPilha.adicionarFinalDaPilha(itemPilha)
		else:
			listaJogador.remove(listaJogador.find(habilidade))
			listaOponente.remove(listaOponente.find(habilidade))
	return true
			
class habilidadePilha extends Classes.ItemPilha:
	
	var efeito
	var carta
	var alvo
	
	func _init(combate,jogador,efeito,carta,alvo).(combate,jogador):
		self.efeito=efeito
		self.carta=carta
		self.alvo=alvo
	
	func main(delta):
		efeito.ativar(carta,alvo)
		print("Habilidade Pilha Executado = true")
		executado=true
