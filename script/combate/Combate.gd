extends Node2D

#listas

var listaTimes =[]
var listaJogadores =[]


var cursorMouse 


func _ready():
	
	cursorMouse= get_parent().get_node("Mouse")

