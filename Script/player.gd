extends Area2D # Player

signal danneggiato(scudo_rimanente : int)
signal perso()
signal collezionata_chiave()

@export_category("Movimento")
@export var dimensione_celle : int = 80
@export var tempo_spostamento : float = 0.1
@export var angolo_rotazione : int = 90
@export var tempo_rotazione : float = 0.1

@export_category("Propietà Player")
@export var scudo : int = 3
@export var tempo_invulnerabilita : float = 2.0

@onready var animated_sprite = $AnimatedSprite as AnimatedSprite2D
@onready var indicatore_direzione = $AnimatedSprite/Direction as PointLight2D
# controlla se avvengono collisioni con muri o oggetti non attraversabili
@onready var area_controllo = $Area2D as Area2D
@onready var collision_shape_player = $CollisionShape2D as CollisionShape2D

var direzioni : Array = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]
var indice_direzione : int = 0

var puo_ruotare : bool = true
var puo_muovere : bool = true
var collide_con_muro : bool = false


func _ready() -> void:
	area_controllo.get_node("CollisionShape2D").position.x += dimensione_celle


func ruota_player() -> void:
	if Input.is_action_just_pressed("destra"):
		if puo_ruotare:
			indice_direzione += 1
			indice_direzione = wrapi(indice_direzione, 0, 4)
			var tween : Tween = get_tree().create_tween()
			tween.tween_property(indicatore_direzione, "rotation", indicatore_direzione.rotation + deg_to_rad(angolo_rotazione), tempo_rotazione).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
			tween.connect("finished", rotazione_finita)
			puo_ruotare = false
			
			# -ruota area_controllo-
			area_controllo.rotation_degrees = wrapi(area_controllo.rotation_degrees + 90, 0, 360)
			
	elif Input.is_action_just_pressed("sinistra"):
		if puo_ruotare:
			indice_direzione -= 1
			indice_direzione = wrapi(indice_direzione, 0, 4)
			var tween : Tween = get_tree().create_tween()
			tween.tween_property(indicatore_direzione, "rotation", indicatore_direzione.rotation - deg_to_rad(angolo_rotazione), tempo_rotazione).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
			tween.connect("finished", rotazione_finita)
			puo_ruotare = false
			
			# -ruota area_controllo-
			area_controllo.rotation_degrees = wrapi(area_controllo.rotation_degrees - 90, 0, 360)


func sposta_player() -> void:
	if Input.is_action_just_pressed("avanza"):
		if puo_muovere:
			var tween : Tween = get_tree().create_tween()
			tween.tween_property(self, "position", position + direzioni[indice_direzione] * dimensione_celle, tempo_spostamento).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
			tween.connect("finished", movimento_finito)
			puo_muovere = false
			
			animated_sprite.speed_scale = 0.625 / tempo_spostamento + 0.1 # fotogrammi / fps = 0.625, 0.1 offset
			animated_sprite.play("movimento")


func _process(delta : float) -> void:
	ruota_player()
	
	if not collide_con_muro:
		sposta_player()


func rotazione_finita() -> void:
	puo_ruotare = true


func movimento_finito() -> void:
	puo_muovere = true


func _on_area_2d_body_entered(body: Node2D) -> void:
	collide_con_muro = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	collide_con_muro = false


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("danneggia"):
		var paletto : Paletto = area
		
		scudo -= paletto.danno
		
		if scudo < 0:
			emit_signal("perso")
			
		emit_signal("danneggiato", scudo)
		
		# invulnerabilità player: sposta il collision_mask a 2 per non vedere la 
		# collisione del paletto che ha collision_layer in 1, ma vede la collisione della
		# chiave che ha collision_layer in 1 e 2
		collision_mask = 2
		# TODO play scudo in
		await get_tree().create_timer(tempo_invulnerabilita).timeout
		# TODO play scudo out
		collision_mask = 1
		
	elif area.is_in_group("chiave"):
		var chiave : Chiave = area
		
		emit_signal("collezionata_chiave")
		chiave.prendi_chiave()

