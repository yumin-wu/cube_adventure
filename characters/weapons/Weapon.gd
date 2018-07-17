extends Area2D

signal attack_finished

onready var animation_player = $AnimationPlayer

enum STATES {IDLE, ATTACK}
var current_state = IDLE

export(int) var damage = 1


func _ready():
	set_physics_process(false)


func attack():
	# Called from the character, when it switches to the ATTACK state
	_change_state(ATTACK)
	
	

 
func _change_state(new_state):
	current_state = new_state
	# Initialize the new state
	match current_state:
		IDLE:   
			set_physics_process(false)
		ATTACK:
			set_physics_process(true)
			animation_player.play("attack")


func _physics_process(delta):
	var overlapping_bodies = get_overlapping_bodies()
	if not overlapping_bodies:
		return
		
	for body in overlapping_bodies:
		if not body.is_in_group("character"):
			return
		if is_owner(body):
			return
		body.take_damage(damage)
	set_physics_process(false)
			
	# For each body, check if it's an enemy
	# If so, damage it and stop physics process for this attack
	# Otherwise it damages targets on every tick
	


func is_owner(node):
	return node.weapon_path == get_path()


# Write AnimationPlayer callback when the attack animation ends


func _on_AnimationPlayer_animation_finished(name):
	if name == "attack":
		_change_state(IDLE)
		emit_signal("attack_finished")
