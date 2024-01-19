extends Node2D

class_name HealthComponent

# custom signals 
signal took_damage
signal died

# variables related to HealthComponent
@export var health = 50
@export var max_health = 100

# take damage
func takeDamage(amount):
	# emit took_damage signal
	took_damage.emit()
	
	health -= amount
	
	if (health <= 0):
		health = 0
		die()

# heal HP, no overhealing
func healHealth(amount):
	
	if (health < max_health):
		health += amount
		health = min(health, max_health)

# die
# planning to die after death animation finishes
func die():
	# emit the died signal
	died.emit()
