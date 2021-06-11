extends Control

var itemClickado
var cont=0

func _init():
	set_process(true)

	
func _process(delta):
	if(cont > 0):
		cont-=delta
	elif(cont < 0):
		cont=0
		
func set_scale(vector):
	#$Viewport/GuardaCarta.set_scale(vector)
	$Viewport.set_size($Viewport.get_size()*vector)
	set_size(get_size()*vector)


func _on_ItemScrollCards_pressed():
	
	if(cont==0):
		itemClickado=$Viewport/GuardaCarta.get_children()
		cont=0.5
		print(itemClickado[0].carta.recebeNome())
