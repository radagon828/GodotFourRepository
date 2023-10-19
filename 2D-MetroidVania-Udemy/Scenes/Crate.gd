extends StaticBody2D

var health = 3
@export var anim: AnimationPlayer

func _on_hitbox_area_entered(area):
	if area.name == "SwordHitbox":
		anim.play("Hurt")
		await anim.animation_finished
		anim.play("Active")
		health -= 1
	if health <= 0:
		anim.play("Destroyed")
		await anim.animation_finished
		queue_free()
