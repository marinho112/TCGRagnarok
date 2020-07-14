extends Area2D

var palavraChave
var pai 
var preInfo = preload("res://cenas/elementos/infoCarta.tscn")

func _ready():
	set_process(true)

func ativar(pai):
	self.pai = pai
	self.pai.add_child(self)
	
func _process(delta):
	if (pai != null):
		if(pai.ativado):
			if Input.is_action_just_pressed("clicar"):
				var lista = get_overlapping_areas()
				
				for area in lista:
					if area.is_in_group(Constante.GRUPO_MOUSE):
						
						var info = preInfo.instance()
						pai.add_child(info)
						pai.ativado=false
						var posicao = get_position()
						if(posicao.x < 0):
							posicao.x = 0
						if(posicao.x > 150):
							posicao.x = 150
						if(posicao.y < -100):
							posicao.y = -100
						if(posicao.y > 300):
							posicao.y = 300
						info.set_position(posicao)
						
						
						var texto = Ferramentas.receberTexto("palavrasChave",palavraChave.id,1)
						if(palavraChave.efeito != null):
							texto +=" " + Ferramentas.receberTexto("efeitos",palavraChave.efeito.id)
						info.setTexto(texto)

func atualizaPalavraChave(palavra):
	palavraChave=palavra
	$texto.set_text(Ferramentas.receberTexto("palavrasChave",palavra.id))

