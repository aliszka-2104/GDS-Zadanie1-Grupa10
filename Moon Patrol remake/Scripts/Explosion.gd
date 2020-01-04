extends AnimatedSprite

func _on_Explosion_animation_finished():
	print("koniec")
	queue_free()
