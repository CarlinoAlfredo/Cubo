extends Area2D #Paletti

class_name Paletto

@export_category("Parametri Animazione")
@export var statico : bool = false
@export var tempo_di_attivazione : float = 1.0
@export var tempo_da_attivato : float = 1.0
@export var tempo_da_disattivato : float = 1.0

# tutti gli oggetti che danneggiano il player tolgono 1
const DANNO : int = 1

@onready var animation_player = $AnimationPlayer as AnimationPlayer

var can_start : bool = true


func _ready() -> void:
	if statico:
		animation_player.play("In")
		
	set_process(not statico)


func start() -> void:
	can_start = false
	
	await get_tree().create_timer(tempo_di_attivazione).timeout
	animation_player.play("In")
	await animation_player.animation_finished
	await get_tree().create_timer(tempo_da_attivato).timeout
	animation_player.play("Out")
	await animation_player.animation_finished
	await get_tree().create_timer(tempo_da_disattivato).timeout
	
	can_start = true


func _process(_delta: float) -> void:
	if can_start:
		start()

