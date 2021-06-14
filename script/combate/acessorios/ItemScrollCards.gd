extends Control

var itemClickado
var cont=0
var pai

func _init():
	set_process(true)

	
func _process(delta):
	if(pai==null):
		pai=get_parent().get_parent().get_parent().get_parent()
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
		for item in itemClickado:
			if(item.is_in_group(Constante.GRUPO_CARTA_FLUTUANTE)):
				if(pai.btnClicked==null):
					pai.btnClicked=item
					cont=0.5
