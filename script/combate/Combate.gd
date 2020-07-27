extends Node2D

#listas

var listaTimes =[]
var listaJogadores =[Classes.jogador.new(),Classes.jogador.new()]


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
