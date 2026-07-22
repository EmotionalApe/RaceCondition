extends PanelContainer

class_name TrackSelector

const DARK : Color = Color("132136")
const LIGHT : Color = Color("182c71ff")

@export var trackInfo : TrackInfo

@onready var texture_rect = $MarginContainer/TextureRect
@onready var track_label = $MarginContainer/TrackLabel
@onready var highlight = $Highlight

# Called when the node enters the scene tree for the first time.
func _ready():
	texture_rect.texture = trackInfo.previewImage
	track_label.text = trackInfo.trackName
	highlight.color = DARK


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_mouse_entered():
	highlight.color = LIGHT


func _on_mouse_exited():
	highlight.color = DARK


func _on_gui_input(event : InputEvent):
	if event.is_action_pressed("select"):
		GameManager.change_to_track(trackInfo)
