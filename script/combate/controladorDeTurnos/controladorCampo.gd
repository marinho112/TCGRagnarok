extends Node2D

var confrontarAtaques1=0
var confrontarAtaques2=0
var animacoes=[]

func _ready():
	add_to_group(Constante.GRUPO_AREA_CAMPO_TOTAL)

func retornaCartasArea(alvo,cartas=true):
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
	return retornaCartasArea(alvo,cartas)

func retornarTodasAsCartasEmCampo(jogador=null):
	var lista1=[]
	var lista2=[]
	var lista3=[]
	var lista4=[]
	
	if(jogador!=get_parent().listaJogadores[1]):
		lista1 = retornaCartasArea($Container/Jogador1Ataque)
		lista3 = retornaCartasArea($Container/Jogador1Defesa)
	if(jogador!=get_parent().listaJogadores[0]):
		lista2 = retornaCartasArea($Container/Jogador2Ataque)
		lista4 = retornaCartasArea($Container/Jogador2Defesa)
	return lista1+lista2+lista3+lista4
	

func atualizaTodasCartas():
	var listaCartas = retornarTodasAsCartasEmCampo()
	
	for carta in listaCartas:
		carta.preparaCarta()
		
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
				

func verificarMorte(carta):
	var item = verificaMortePilha.new(get_parent(),carta.carta.dono,carta) 
	get_parent().get_node("controladorPilha").adicionarFinalDaPilha(item)
	
class verificaMortePilha extends Classes.ItemPilha:
	
	var carta
	
	func _init(combate,jogador,carta).(combate,jogador):
		self.carta=carta
		
	func main(delta):
		carta.verificaVida()
		executado=true

func confrontar(golpeador,alvo,val = true):
	if((confrontarAtaques1+confrontarAtaques2) == 0):
		confrontarAtaques1 = 1
		confrontarAtaques2 = 1
		
		
		if(golpeador.carta.temPalavraChave(15)):
			confrontarAtaques1 +=1
		if(alvo.carta.temPalavraChave(15)):
			confrontarAtaques2 +=1
		if(golpeador.carta.temPalavraChave(17)):
			confrontarAtaques1 =3
		if(alvo.carta.temPalavraChave(17)):
			confrontarAtaques2 =3
			
		if(golpeador.carta.temPalavraChave(1)):
			confrontarAtaques2=0
		if(alvo.carta.temPalavraChave(12) and val):
			confrontarAtaques1=0
		
	animacoes=[]
	var iniciativa = [golpeador.carta.temPalavraChave(2),alvo.carta.temPalavraChave(2)]
	if((iniciativa[0]and(confrontarAtaques1>0)) or (iniciativa[1] and (confrontarAtaques2>0))):
		if(iniciativa[0] and (confrontarAtaques1>0)):
			golpear(golpeador,alvo)
			confrontarAtaques1 -= 1
		if(iniciativa[1] and (confrontarAtaques2 > 0)):
			golpear(alvo,golpeador)
			confrontarAtaques2 -=1
		return finalizaConfronto()
	
	if((confrontarAtaques1>0)):
		if(golpeador.carta.retornaVida()>0):
			golpear(golpeador,alvo)
		confrontarAtaques1 -= 1
	if((confrontarAtaques2 > 0)):
		if(alvo.carta.retornaVida()>0):
			golpear(alvo,golpeador)
		confrontarAtaques2 -=1
	var preMulti = preload("res://cenas/animacoes/multiAnimacoes.tscn")
	var animacao = preMulti.instance()
	animacao.definirPai(get_parent())
	animacao.play(golpeador,animacoes,4)
		
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
	animacao.definirPai(get_parent())
	animacao.set_global_position(golpeador.get_global_position())
	animacao.setListaAnimacao(animacoes)
	animacao.play(golpeador,[alvo],null)
	#var retorno = golpeador.carta.golpear(alvo.carta)
	
func adicionaAlerta(texto,tempo=null):
	$CaixaAlerta.adicionaAlerta(texto,tempo)
