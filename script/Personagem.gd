extends "res://script/cartas/MiniaturaMonstro.gd"

#var carta
#var ativado = true
var duploClick = false
var jogador
#var verificadorTipo=Constante.OBJ_JOGADOR
#var pai

func _ready():
	verificadorTipo=Constante.OBJ_JOGADOR
	add_to_group(Constante.GRUPO_PERSONAGEM)
	add_to_group(Constante.GRUPO_CARTA_EM_CAMPO)
	posicaoJogo=self
	set_process(true)
	pai=get_parent().get_parent()

func get_fundo():
	return "fundo"

func _process(delta):
	animacaoBrilho(delta/2)
	if ativado:
		if Input.is_action_just_released("clicar"):
			for area in get_overlapping_areas():
				if area.is_in_group(Constante.GRUPO_MOUSE):
					if duploClick:
						exibirCartas()
						duploClick = false
					else:
						duploClick = true
						$Timer.start()
			
func atualizarPersonagem(personagemNovo=null):
	if(personagemNovo!= null):
		carta=personagemNovo
	if(carta!=null):
		atualizaInfoPersonagem(carta)
		
		var imagem = load("res://sprites/personagem/"+str(carta.imagem)+".png")
		get_node("fundo").set_texture(imagem)
	
func atualizaInfoPersonagem(carta = self.carta):
	atualizarAtaque(carta.retornaPoder())
	atualizarDefesa(carta.retornaDefesa())
	atualizarVida(carta.retornaVida())
	
func atualizarVida(vida):
	$lblVida.set_text(str(vida))
	
func atualizarAtaque(ataque):
	$lblAtaque.set_text(str(ataque))
	
func atualizarDefesa(defesa):
	$lblDefesa.set_text(str(defesa))

func desenhaAtributosMonstro():
	desenhaAtributos()
	

func desenhaAtributos():
	atualizaInfoPersonagem()

func verificaVida(algoz):
	if(carta.retornaVida()<=0):
		print("Jogador "+str(jogador.time)+" MORREU!!!")
		return true
	else:
		return false

func _on_Timer_timeout():
	duploClick = false

func exibirCartas():
	if carta!= null:
		var raiz = get_node("/root/main/ControladorDeTurnos/")
		raiz.pausar(3)
		var listaItens = [carta]
		var lista = raiz.get_node("controladorCampo/listaExibicaoCartas")
		listaItens += carta.listaCartasRelacionadas
		lista.definirListaCartas(listaItens)
	else:
		print("Sem personagem carregado")
