extends Node2D

var enemy_array = []
var built = false
var enemy
var type
var readyToFire = true
var category

func _physics_process(delta):
	if enemy_array.size() != 0 and built:
		select_enemy()
		turn()
		if readyToFire:
			fire()
	else:
		enemy = null
		
func select_enemy():
	var enemy_progress_array = [] 
	for i in enemy_array:
		enemy_progress_array.append(i.progress)
	var max_offset = enemy_progress_array.max()
	var enemy_index = enemy_progress_array.find(max_offset)
	enemy = enemy_array[enemy_index]

func fire():
	get_node("AudioStreamPlayer2D").play()
	readyToFire = false
	if category == "Hitscan" :
		fire_gun()
	elif category == "Projectile" :
		fire_projectile()
	enemy.on_hit(GameData.tower_data[type]["damage"])
	await(get_tree().create_timer(GameData.tower_data[type]["rof"]).timeout)
	readyToFire = true

func fire_gun():
	get_node("AnimationPlayer").play("Fire")
	
func fire_projectile():
	pass

func _ready():
	if built:
		self.get_node("Range/CollisionShape2D").get_shape().radius = 0.5 * GameData.tower_data[type]["range"]

func turn():
	get_node("Turret").look_at(enemy.position)

func _on_range_body_entered(body):
	enemy_array.append(body.get_parent())

func _on_range_body_exited(body):
	enemy_array.erase(body.get_parent())
