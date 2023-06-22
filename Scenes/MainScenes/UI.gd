extends CanvasLayer

@onready var hp_bar = get_node("HUD/InfoBar/HBoxContainer/TextureProgressBar")
@onready var wave_counter = get_node("HUD/InfoBar/HBoxContainer/Counter")
@onready var money_counter = get_node("HUD/InfoBar/HBoxContainer/Money")

func set_tower_preview(tower_type, mouse_position):
	var drag_tower = load("res://Scenes/Towers/"+ tower_type + ".tscn").instantiate()
	drag_tower.set_name("DragTower")
	drag_tower.modulate = Color("ad54ff3c")
	
	var range_texture = Sprite2D.new()
	range_texture.position = Vector2(0, 0)
	var scaling = GameData.tower_data[tower_type]["range"] / 600.0
	range_texture.scale = Vector2(scaling, scaling)
	var texture = load("res://Assets/UI/range_overlay.png")
	range_texture.texture = texture
	range_texture.modulate = Color("ad54ff3c")
	
	var control = Control.new()
	control.add_child(drag_tower, true)
	control.add_child(range_texture, true)
	control.global_position = mouse_position
	control.set_name("TowerPreview")
	add_child(control, true)
	move_child(get_node("TowerPreview"), 0)


func update_tower_preview(new_position, color):
	get_node("TowerPreview").global_position = new_position
	if get_node("TowerPreview/DragTower").modulate != Color(color):
		get_node("TowerPreview/DragTower").modulate = Color(color)
		get_node("TowerPreview/Sprite2D").modulate = Color(color)
	
func update_money(money):
	money_counter.text = str(money)
	check_can_build(money)
	
## BEGIN GAME CONTROL
	
func _on_play_pause_pressed():
	if get_parent().build_mode:
		get_parent().cancel_build_mode()
	if get_tree().is_paused():
		get_tree().paused = false
	elif get_parent().current_wave == 0:
		get_parent().current_wave += 1
		get_parent().start_next_wave()
	else:
		get_tree().paused = true
		


func _on_speed_pressed():
	if get_parent().build_mode:
		get_parent().cancel_build_mode()
	if Engine.get_time_scale() == 2.0:
		Engine.set_time_scale(1.0)
	else:
		Engine.set_time_scale(2.0)
		
func update_health_bar(base_health):
	hp_bar.value = base_health
	if base_health > 60:
		hp_bar.set_tint_progress("4eff15")
	elif base_health <= 60 and base_health >= 30:
		hp_bar.set_tint_progress("e1be32")
	else:
		hp_bar.set_tint_progress("e11e1e")
		
func update_wave_counter(current_wave):
	if current_wave < 6:
		wave_counter.text = str(current_wave) + "/5"
	
func check_can_build(money):
	if money >= GameData.tower_data["GunT1"].cost:
		get_tree().get_nodes_in_group("Build_Buttons")[0].modulate = Color("ffffffff")
	else:
		get_tree().get_nodes_in_group("Build_Buttons")[0].modulate = Color("ff54adaa")
		
	if money >= GameData.tower_data["MissileT1"].cost:
		get_tree().get_nodes_in_group("Build_Buttons")[1].modulate = Color("ffffffff")
	else:
		get_tree().get_nodes_in_group("Build_Buttons")[1].modulate= Color("ff54adaa")
