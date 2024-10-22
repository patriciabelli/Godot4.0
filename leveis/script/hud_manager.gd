extends Control

@onready var coins_counter: Label = $Container/Coins_container/Coins_counter as Label
@onready var timer_counter: Label = $Container/Timer_container/Timer_counter as Label
@onready var score_counter: Label = $Container/MarginContainer/Score_container/Score_counter
@onready var life_counter: Label = $Container/Life_container/Life_counter as Label
@onready var clock_timer: Timer = $HUD/Clock_timer as Timer

var minutes = 0
var seconds = 0

@export_range(0,5) var defalt_minutes := 1
@export_range(0,59) var defalt_seconds := 0

signal  time_is_up()

func _ready() -> void:
	coins_counter.text = str("%04d" % Globals.coins)
	score_counter.text = str ("%06d" % Globals.score) 
	life_counter.text = str("%02d" % Globals.player_life)
	timer_counter.text = str("%02d" % defalt_minutes) + ":" + str("%02d" % defalt_seconds) 
	reset_clock_timer() 

func _process(delta: float) -> void:
	coins_counter.text = str("%04d" % Globals.coins)
	score_counter.text = str ("%06d" % Globals.score)
	life_counter.text = str("%02d" % Globals.player_life)
	
	if minutes == 0 and seconds == 0:
		emit_signal("time_is_up")

func _on_clock_timer_timeout() -> void:
	if seconds == 0:
		if minutes > 0:
			minutes -= 1
			seconds = 60
	seconds -= 1
		
	timer_counter.text = str("%02d" % minutes) + ":" + str("%02d" % seconds) 

func reset_clock_timer():
	minutes = defalt_minutes
	seconds = defalt_seconds
	
