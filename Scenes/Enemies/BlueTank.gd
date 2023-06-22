extends PathFollow2D

var speed = 150
var hp = 50
signal base_damage(damageAmt)
signal on_death
var damage = 21

@onready var health_bar = get_node("HealthBar")

func _ready():
	health_bar.max_value = hp
	health_bar.value = hp
	#health_bar.set_as_toplevel(true)

# Called when the node enters the scene tree for the first time.
func move(delta):
	set_progress(get_progress() + speed * delta)
	#health_bar.set_position(position - Vector2(30, 30))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if get_progress_ratio() == 1.0:
		print("do damage")
		base_damage.emit(damage)
		on_destroy()
	move(delta)
	
func on_hit(damage):
	hp -= damage
	health_bar.value = hp
	if hp <= 0:
		on_death.emit()
		on_destroy()
		
func on_destroy():
	self.queue_free()

