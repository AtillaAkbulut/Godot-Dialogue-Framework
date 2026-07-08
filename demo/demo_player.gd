extends CharacterBody2D

@export var speed: float = 160.0

var current_dialogue_component: Node = null

@onready var dialogue_interactor: Area2D = $DialogueInteractor

func _ready() -> void:
	dialogue_interactor.area_entered.connect(_on_interactor_area_entered)
	dialogue_interactor.area_exited.connect(_on_interactor_area_exited)

func _physics_process(delta: float) -> void:
	if DialogueManager.is_active and DialogueManager.lock_movement:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	var input_vector := Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	input_vector = input_vector.normalized()
	
	velocity = input_vector * speed
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if current_dialogue_component != null and not DialogueManager.is_active:
			current_dialogue_component.start_dialogue()
			get_viewport().set_input_as_handled()

func _on_interactor_area_entered(area: Area2D) -> void:
	var possible_npc := area.owner
	
	if possible_npc == null:
		return
	
	var component := possible_npc.get_node_or_null("DialogueComponent")
	
	if component != null:
		current_dialogue_component = component

func _on_interactor_area_exited(area: Area2D) -> void:
	var possible_npc := area.owner
	
	if possible_npc == null:
		return
	
	var component := possible_npc.get_node_or_null("DialogueComponent")
	
	if component != null and component == current_dialogue_component:
		if DialogueManager.is_active and component.close_on_area_exit:
			DialogueManager.end_dialogue()
		
		current_dialogue_component = null
