extends Node2D

var runner
var it
var duck1_score = 0
var duck2_score = 0

@onready var tile_map = $map
@onready var timer_label = $Timer/Label
@onready var timer = $Timer
@onready var it_duck1_label = $duck1_ui/duck_1_is_it
@onready var it_duck2_label = $duck2_ui/duck_2_is_it
@onready var duck1_score_label = $duck1_ui/duck1_score
@onready var duck2_score_label = $duck2_ui/duck2_score 
@onready var duck1 = $duck1
@onready var duck2 = $duck2

@onready var spawn_coords = tile_map.spawn_coords
var round_ended = false

func _ready() -> void:
	newRound()

func _process(_delta: float) -> void:
	if not round_ended:
		timer_label.text = str(int(timer.time_left))
		
		if (duck1.is_caught or duck2.is_caught) and timer.time_left < 29:
			caught(it)
		
		elif timer.time_left >= 29:
			duck1.is_caught = false
			duck2.is_caught = false

func _on_timer_timeout() -> void:
	caught(runner)

func newRound(who_was_it = null):
	var available_positions = spawn_coords.duplicate()
	available_positions.shuffle()
	
	var location1 = available_positions.pop_back()
	var location2 = available_positions.pop_back()
	
	var local_pos1 = tile_map.map_to_local(location1)
	var local_pos2 = tile_map.map_to_local(location2)
	
	duck1.reset_duck(tile_map.to_global(local_pos1))
	duck2.reset_duck(tile_map.to_global(local_pos2))
	
	duck1.set_physics_process(true)
	duck2.set_physics_process(true)
	
	if not who_was_it:
		match randi_range(0,1):
			0:
				it = "duck1"
				runner = "duck2"
			1:
				it = "duck2"
				runner = "duck1"
	else:
		match who_was_it:
			"duck1":
				it = "duck2"
				runner = "duck1"
			"duck2":
				it = "duck1"
				runner = "duck2"
				
	if it == "duck1":
		it_duck1_label.show()
		it_duck2_label.hide()
	else:
		it_duck1_label.hide()
		it_duck2_label.show()
	
	timer.wait_time = 30
	round_ended = false
	timer.start()

func caught(winner):
	timer.stop()
	round_ended = true
	timer_label.text = winner + " WINS"
	
	if winner == "duck1":
		duck1_score += 1
	else:
		duck2_score += 1
		
	duck1_score_label.text = str(duck1_score)
	duck2_score_label.text = str(duck2_score)
	
	duck1.set_physics_process(false)
	duck2.set_physics_process(false)
	
	await get_tree().create_timer(2).timeout
	newRound(it)
