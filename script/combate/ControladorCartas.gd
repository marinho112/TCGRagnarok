extends Node2D

#listas

var listaCartas = []
var listaTimes =[]
var listaJogadores =[]

var cartaSelecionada
var cursorMouse 
var cursorMousePosition
var duploClick = false

func _ready():
	set_process(true)

func _process(delta):
	
	if((cursorMouse!=null) and (cartaSelecionada==null)):
		if(Input.is_action_pressed("clicar")):
			var passa= false
			for area in cursorMouse.get_overlapping_areas():
				if(area.is_in_group(Constante.GRUPO_CARTA)):
					if(duploClick):
						area.setZoom(!area.zoom)
						duploClick=false
					else:	
						if(!area.zoom):
							cartaSelecionada = area
							cursorMousePosition = cursorMouse.get_global_position()
				
		
		
			
	if(Input.is_action_just_released("clicar")):
		duploClick = true
		$Timer.start()
		if(cartaSelecionada!=null):
			cartaSelecionada=null
	else:
		if(cartaSelecionada!=null):
			var posicaoCarta = cartaSelecionada.get_global_position()
			var novaPosicao = cursorMouse.get_global_position()
			cartaSelecionada.set_global_position(posicaoCarta-cursorMousePosition+novaPosicao)
			cursorMousePosition=novaPosicao
			
	
	


func _on_Timer_timeout():
	duploClick=false
