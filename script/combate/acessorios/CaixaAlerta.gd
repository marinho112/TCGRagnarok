extends Node2D

var listaAlertas=[]
var tempoPadraoPorAlerta = 2

func _ready():
	pass # Replace with function body.

func adicionaAlerta(texto,tempo=null):
	var vazio=false
	if(listaAlertas.size()<=0):
		vazio=true
	for item in listaAlertas:
		if(item[0]==texto):
			return
	listaAlertas.append([texto,tempo])
	if(vazio):
		set_visible(true)
		ativaProximoAlerta()
		
func defineAlerta(texto,tempo=null):
	var timer = tempoPadraoPorAlerta
	if(tempo != null):
		timer = tempo
	$RichTextLabel.set_text(texto)
	$Timer.wait_time=timer
	$Timer.start()
	
func clearAlerta():
	$RichTextLabel.set_text("")
	set_visible(false)
	
func ativaProximoAlerta():
	if(listaAlertas.size()>0):
		defineAlerta(listaAlertas[0][0],listaAlertas[0][1])
	else:
		clearAlerta()
	
func _on_Timer_timeout():
	if(listaAlertas.size()>0):
		listaAlertas.remove(0)
	ativaProximoAlerta()
