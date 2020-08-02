extends Area2D

var personagem
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
		personagem=personagemNovo
	if(personagem!=null):
		atualizarAtaque(personagem.poder)
		atualizarDefesa(personagem.defesa)
		atualizarVida(personagem.vida)
		var imagem = load("res://sprites/personagem/"+str(personagem.imagem)+".png")
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
	if personagem!= null:
		var raiz = get_node("/root/main/Combate/")
		raiz.pausar(2)
		var listaItens = [personagem]
		var lista = raiz.get_node("listaExibicaoCartas")
		listaItens += personagem.listaCartasRelacionadas
		lista.definirListaCartas(listaItens)
	else:
		print("Sem personagem carregado")
