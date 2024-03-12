extends Area2D # chiave

class_name Chiave


func elimina_chiave() -> void:
	visible = false
	$CollisionShape2D.set_deferred("disabled", true)
	
	$AudioStreamPlayer.play()
	await $AudioStreamPlayer.finished
	
	queue_free()
