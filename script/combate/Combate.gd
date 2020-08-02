extends Node2D

#listas

var listaTimes =[]
var listaJogadores =[Classes.jogador.new(),Classes.jogador.new()]
var listaPausa=[true,true,true,true,true]
var ativado = true
var cursorMouse 

var turno = 0
var jogador =0


func _ready():
	cursorMouse= get_parent().get_node("Mouse")
	$btnAzul.set_text(1)
	listaJogadores[0].ativado=true
	$ControladorCartas.jogador=listaJogadores[0]
	$mao.jogador=listaJogadores[0]
	$maoOponente.jogador=listaJogadores[1]
	$Personagem.atualizarPersonagem(ControlaDados.carregaPersonagemPorID(randi()%7))
	$Oponente.atualizarPersonagem(ControlaDados.carregaPersonagemPorID(randi()%7))
	
	set_process(true)

func _process(delta):
	
	
	match(turno):
		
		0:
			if(true):
				turno = 1
		1:
			
			if(true):
				turno = 2
		2:
			if(true):
				turno = 3
		3:
			if(true):
				turno = 4
		4:
			if(true):
				turno = 5
		5:
			if(true):
				turno = 6
		6:
			if(true):
				turno = 7

func retornaListaAreas(jogador,tipo):
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
			lista.append(item)
	
	return lista

func pausar(intensidade):
	if(intensidade == 0):
		$ControladorCartas.ativado = $ControladorCartas.ativado or listaPausa[0]
		$mao.ativado = $mao.ativado or listaPausa[1]
		$Personagem.ativado = $Personagem.ativado or listaPausa[1]
		for item in listaPausa:
			item = false
			
	if(intensidade > 0):
		$ControladorCartas.ativado = false
		listaPausa[0] = true
	if(intensidade > 1):
		$mao.ativado = false
		$Personagem.ativado = false
		listaPausa[1]=true	
		
