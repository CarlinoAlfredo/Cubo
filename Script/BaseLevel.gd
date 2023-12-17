extends Node #main

@export_category("Propietà")
@export var numero_chiavi_nel_livello : int = 3
@export var prossimo_livello : String = ""

@onready var transition = $"/root/Transition" as CanvasLayer


func _ready() -> void:
	transition.get_node("AnimationTransition").play("Out")
	ScriptGlobale.numero_corrente_di_chiavi = numero_chiavi_nel_livello
	
	if $"2D/ContenitoreChiavi".get_child_count() != numero_chiavi_nel_livello:
		print_debug("il numero totale delle chiavi dichiarete per il corrente livello è diverso dal numero effettivo. Potrebbero verificarsi comportamenti non voluti")


func _on_player_perso() -> void:
	# magari far asperttare che gli effetti e lo shake finiscano
	get_tree().set_pause(true)


func _on_player_cambia_livello() -> void: # one shot
	transition.get_node("AnimationTransition").play("In")
	get_tree().set_pause(true)
	await transition.get_node("AnimationTransition").animation_finished
	
	if prossimo_livello != "":
		var scena = load(prossimo_livello)
		get_tree().set_pause(false)
		get_tree().change_scene_to_packed(scena)
	else:
		print_debug("non c'è un livello successivo")
