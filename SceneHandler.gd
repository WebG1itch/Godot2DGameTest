extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	load_main_menu(" ")
	get_node("AudioStreamPlayer2D").play()
	
func load_main_menu(win_condition):
	get_node("MainMenu/MarginContainer/VBoxContainer/NewGame").pressed.connect(on_new_game_pressed)
	get_node("MainMenu/MarginContainer/VBoxContainer/Quit").pressed.connect(on_quit_pressed)
	get_node("MainMenu/Background/Victory").text = str(win_condition)
	
	

func on_new_game_pressed():
	get_node("MainMenu").queue_free()
	var game_scene = load("res://Scenes/MainScenes/GameScene.tscn").instantiate()
	game_scene.connect("game_finished", unload_game)
	add_child(game_scene)
	
func on_quit_pressed():
	get_tree().quit()

func unload_game(result):
	get_node("GameScene").queue_free()
	var main_menu = load("res://Scenes/UI/mainMenu.tscn").instantiate()
	add_child(main_menu)
	if result:
		load_main_menu("You Win!")
	else:
		load_main_menu("Try Again!")
