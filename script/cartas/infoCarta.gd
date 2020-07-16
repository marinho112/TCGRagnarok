extends Area2D

var efeito

func _ready():
	set_process(true)
	
func _process(delta):
	var valido = false
	if Input.is_action_just_pressed("clicar"):
		valido = true
		var lista = get_overlapping_areas()
		for area in lista:
			if area.is_in_group(Constante.GRUPO_MOUSE):
				valido = false
	if valido:
		get_parent().ativado = true
		queue_free()

func setTexto(texto):
	
	if(efeito!=null):
		if(efeito.listaPalavras != []):
			$texto.bbcode_enabled = true
			
			for palavra in efeito.listaPalavras:
				var url = '[url=function'+str(palavra.id)+']'
				url += Ferramentas.receberTexto("palavrasChave",palavra.id)
				url+='[/url]'
				
				texto = texto.replace("#"+str(palavra.id),url)
				
				url = '[url=function'+str(palavra.id)+']'
				url += Ferramentas.receberTexto("palavrasChave",palavra.id,2)
				url+='[/url]'
				texto = texto.replace("@"+str(palavra.id),url)
				
			
			
			$texto.bbcode_text = texto
			return
		
	$texto.set_text(texto)
	


func _on_texto_meta_clicked(meta):
	
	for item in efeito.listaPalavras:
		if(("function"+str(item.id))==meta):
			
			efeito=item.efeito
			var texto = Ferramentas.receberTexto("palavrasChave",item.id,1)
			if(item.efeito != null):
				texto +=" " + Ferramentas.receberTexto("efeitos",item.efeito.id)
			setTexto(texto)
