extends Area2D

class_name HitboxComponent

@export var collision_shape: CollisionShape2D
@export var health_component: HealthComponent

# take damage
func takeDamage(amount):
	# check if there is a health component assigned
	if health_component:
		health_component.takeDamage(amount)

# heal HP
func healHealth(amount):
	# check if there is a health component assigned
	if health_component:
		health_component.healHealth(amount)


