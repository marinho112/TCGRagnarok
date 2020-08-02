extends Area2D

var personagem

func _ready():
	pass # Replace with function body.

func atualizarPersonagem(personagemNovo=null):
	if(personagemNovo!= null):
		personagem=personagemNovo
	if(personagem!=null):
		atualizarAtaque(personagem.poder)
		atualizarDefesa(personagem.defesa)
		atualizarVida(personagem.vida)
		
func atualizarVida(vida):
	$lblVida.set_text(str(vida))
	
func atualizarAtaque(ataque):
	$lblAtaque.set_text(str(ataque))
	
func atualizarDefesa(defesa):
	$lblDefesa.set_text(str(defesa))
