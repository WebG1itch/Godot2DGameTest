extends Node2D
var map_node

var build_mode = false
var build_valid = false
var build_tile
var build_location
var build_type
var base_health = 100

var current_wave = 0
var enemies_in_wave

var money = 50

signal game_finished(victory)

func _ready():
	map_node = get_node("TopDownMap")
	
	get_tree().get_nodes_in_group("Build_Buttons")[0].pressed.connect(initiate_build_mode_gun)
	get_tree().get_nodes_in_group("Build_Buttons")[1].pressed.connect(initiate_build_mode_missile)
	get_node("UI").update_money(money)
	
func _process(delta):
	if build_mode:
		update_tower_preview()
	
func _unhandled_input(event):
	if event.is_action_released("ui_cancel") and build_mode == true:
		cancel_build_mode()
	if event.is_action_released("ui_accept") and build_mode == true:
		verify_and_build()
		cancel_build_mode()
		
## START WAVE FUNCTIONS
	
func start_next_wave():
	get_node("UI").update_wave_counter(current_wave)
	await(get_tree().create_timer(2).timeout)
	if current_wave <= GameData.wave_data.size():
		var wave_data = retrieve_wave_data()
		spawn_enemies(wave_data)
	else: 
		game_finished.emit(true)
	current_wave += 1
	
func retrieve_wave_data():
	var wave_data = GameData.wave_data[current_wave]
	print(wave_data.size())
	enemies_in_wave = wave_data.size()
	return wave_data
	
func spawn_enemies(wave_data):
	for i in wave_data:
		var new_enemy = load("res://Scenes/Enemies/"+ i[0] +".tscn").instantiate()
		new_enemy.connect("base_damage", on_base_damage)
		new_enemy.connect("on_death", kill_enemy)
		map_node.get_node("Path").add_child(new_enemy, true)
		await(get_tree().create_timer(i[1]).timeout)

func kill_enemy():
	money += 20
	get_node("UI").update_money(money)
	enemies_in_wave -= 1
	if enemies_in_wave == 0:
		start_next_wave()

func on_base_damage(damage):
	enemies_in_wave -= 1
	base_health -= damage
	if (base_health <= 0):
		game_finished.emit(false)
	else:
		get_node("UI").update_health_bar(base_health)
		
	if enemies_in_wave == 0:
		start_next_wave()
	
## END WAVE FUNCTIONS
	
## START BUILD FUNCTIONS
	
func initiate_build_mode(tower_type):
	if money >= GameData.tower_data[tower_type + "T1"].cost:
		if (build_mode):
			cancel_build_mode()
		build_type = tower_type + "T1"
		build_mode = true
		get_node("UI").set_tower_preview(build_type, get_global_mouse_position())
	
func update_tower_preview():
	var mouse_position = get_global_mouse_position()
	var current_tile = map_node.get_node("TowerExclusion").local_to_map(mouse_position)
	var tile_position = map_node.get_node("TowerExclusion").map_to_local(current_tile)
	
	if (map_node.get_node("TowerExclusion").get_cell_source_id(0, current_tile) == -1):
		get_node("UI").update_tower_preview(tile_position, "adffadaa")
		build_valid = true
		build_location = tile_position
		build_tile = current_tile
	else:
		get_node("UI").update_tower_preview(tile_position, "ff54adaa")
		build_valid = false

func cancel_build_mode():
	build_mode = false
	build_valid = false
	get_node("UI/TowerPreview").queue_free()
	
func verify_and_build():
	if build_valid:
		if money >= GameData.tower_data[build_type].cost:
			var new_tower = load("res://Scenes/Towers/" + build_type + ".tscn").instantiate()
			new_tower.built = true
			new_tower.type = build_type
			new_tower.position = build_location
			new_tower.category = GameData.tower_data[build_type]["category"]
			map_node.get_node("Turrets").add_child(new_tower, true)
			map_node.get_node("TowerExclusion").set_cell(0, build_location, 4)
			
			money -= GameData.tower_data[build_type].cost
			get_node("UI").update_money(money)

func initiate_build_mode_gun():
	initiate_build_mode("Gun")
	
func initiate_build_mode_missile():
	initiate_build_mode("Missile")
	
## END BUILD FUNCTIONS
