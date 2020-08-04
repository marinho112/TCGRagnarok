extends Area2D

var carta
var ativado = true
var duploClick = false

func _ready():
	set_process(true)

func _process(delta):
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
		atualizarAtaque(carta.poder)
		atualizarDefesa(carta.defesa)
		atualizarVida(carta.vida)
		var imagem = load("res://sprites/personagem/"+str(carta.imagem)+".png")
		get_node("fundo").set_texture(imagem)
		
func atualizarVida(vida):
	$lblVida.set_text(str(vida))
	
func atualizarAtaque(ataque):
	$lblAtaque.set_text(str(ataque))
	
func atualizarDefesa(defesa):
	$lblDefesa.set_text(str(defesa))


func _on_Timer_timeout():
	duploClick = false

func exibirCartas():
	if carta!= null:
		var raiz = get_node("/root/main/Combate/")
		raiz.pausar(2)
		var listaItens = [carta]
		var lista = raiz.get_node("listaExibicaoCartas")
		listaItens += carta.listaCartasRelacionadas
		lista.definirListaCartas(listaItens)
	else:
		print("Sem personagem carregado")
