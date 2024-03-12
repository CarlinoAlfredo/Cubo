extends Control # LivelliMenu

@onready var transition = $"/root/Transition" as CanvasLayer
@onready var grid_container = $CenterContainer/PanelContainer/MarginContainer/GridContainer as GridContainer


func _ready() -> void:
	var config : ConfigFile = ScriptGlobale.prendi_config_file("user://CuboSaves/DatiLivelli.cfg")
	
	if config != null:
		ScriptGlobale.ultimo_livello_sbloccato = config.get_value("livello", "id_ultimo_livello_sbloccato", 1)
	
	for indice_bottone_livello : int in range(0, ScriptGlobale.ultimo_livello_sbloccato):
		grid_container.get_child(indice_bottone_livello).disabled = false
		
	transition.get_node("AnimationTransition").play("Out")


func cambia_scena(path : String) -> void:
	transition.get_node("AnimationTransition").play("In")
	await transition.get_node("AnimationTransition").animation_finished
	
	var scena : PackedScene = load(path) as PackedScene
	
	if scena != null:
		get_tree().change_scene_to_packed(scena)
	else:
		print_debug("scena non valida")


func _on_button_livello_1_button_up(extra_arg_0 : String) -> void:
	cambia_scena(extra_arg_0)


func _on_button_livello_2_button_up(extra_arg_0) -> void:
	cambia_scena(extra_arg_0)


func _on_button_livello_3_button_up(extra_arg_0) -> void:
	cambia_scena(extra_arg_0)


func _on_button_main_menu_button_up() -> void:
	transition.get_node("AnimationTransition").play("In")
	await transition.get_node("AnimationTransition").animation_finished
	
	var scena = load("res://Scene/MainMenu.tscn")
	get_tree().change_scene_to_packed(scena)

