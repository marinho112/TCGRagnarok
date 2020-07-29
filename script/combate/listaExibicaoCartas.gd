extends Node2D

var listaCartas = []
var listaCartasObjeto = []
var posicao
var ativado = false
var mouse
var duploClick = false
var ajusteX = 100
var ajusteY = 10
var index = 10
var valorR = 2

var tamanhoCartas= Vector2(1.5,1.5)

func _ready():
	mouse = get_parent().get_parent().get_node("Mouse")
	set_process(true)
	
func _process(delta):
	if ativado:
		if Input.is_action_just_released("clicar"):
			var position = mouse.get_global_position()
			if(position.x > 150):
				subirPosicao()
			elif(position.x < -150):
				descerPosicao()
			else:
				if(duploClick):
					duploClick = false
					get_node("/root/main/Combate").pausar(0)
					limparCartas()
				else:
					duploClick = true
					
func definirListaCartas(lista):
	set_visible(true)
	ativado = true
	listaCartas = lista
	posicao = 0
	
	for carta in listaCartas:
		var cartaNova = ControladorCartas.criarCarta(carta,get_parent(),Vector2(0,0))
		listaCartasObjeto.append(cartaNova)
	desenhaCartas()

func limparCartas():
	set_visible(false)
	ativado = false
	listaCartas = []
	for item in listaCartasObjeto:
		item.queue_free()
	listaCartasObjeto=[]

func desenhaCartas():
	var tamanho = listaCartasObjeto.size()
	var posicaoRelativa
	
	
	for x in (posicao):
		posicaoRelativa = x+1
		var carta = listaCartasObjeto[posicao-x-1]
		carta.set_position(Vector2(-(posicaoRelativa*ajusteX),posicaoRelativa*ajusteY))
		carta.set_z_index(index+(tamanho-posicaoRelativa))
		carta.set_rotation(deg2rad(-1*valorR*posicaoRelativa))
		carta.set_scale(tamanhoCartas*(1-(posicaoRelativa*(0.05))))
		carta.ativado=false
	
	for x in (tamanho-posicao):
		posicaoRelativa = (x)
		
	
		var carta = listaCartasObjeto[posicao+x]
		carta.set_position(Vector2((posicaoRelativa*ajusteX),posicaoRelativa*ajusteY))
		carta.set_rotation(deg2rad(valorR*posicaoRelativa))
		carta.set_z_index(index+(tamanho - posicaoRelativa))
		carta.set_scale(tamanhoCartas*(1-(posicaoRelativa*(0.05))))
		carta.ativado=false
	
	
	var carta = listaCartasObjeto[posicao]
	carta.set_position(Vector2(0,0))
	carta.set_z_index(index+tamanho)
	carta.set_rotation(deg2rad(0))
	carta.set_scale(tamanhoCartas)
	carta.ativado=true
	
	
func subirPosicao():
	if(posicao<(listaCartasObjeto.size()-1)):
		posicao+=1
		desenhaCartas()

func descerPosicao():
	if(posicao>0):
		posicao-=1
		desenhaCartas()


func _on_Timer_timeout():
	duploClick = false