<h1>Godot Dialogue Framework — API Reference</h1>

<p>
This document describes the public classes, methods, signals, providers, and data models used by the framework.
</p>

<hr>

<h2>DialogueManager</h2>

<p>
The central runtime controller responsible for dialogue flow, node progression, choices, states, commands, and events.
</p>

<h3>Public Methods</h3>

<h4><code>start_dialogue</code></h4>

<pre><code>DialogueManager.start_dialogue(
	data: DialogueData,
	start_node: String = "",
	should_lock_movement: bool = true
)</code></pre>

<p>
Starts a dialogue using loaded <code>DialogueData</code>.
</p>

<ul>
  <li><code>data</code>: Dialogue data returned by <code>DialogueLoader</code>.</li>
  <li><code>start_node</code>: Optional manual start node override.</li>
  <li><code>should_lock_movement</code>: Determines whether player movement should be locked.</li>
</ul>

<h4><code>advance</code></h4>

<pre><code>DialogueManager.advance()</code></pre>

<p>
Advances the current dialogue according to the active dialogue state.
</p>

<h4><code>move_selection_up</code></h4>

<pre><code>DialogueManager.move_selection_up()</code></pre>

<p>
Moves the active choice selection upward.
</p>

<h4><code>move_selection_down</code></h4>

<pre><code>DialogueManager.move_selection_down()</code></pre>

<p>
Moves the active choice selection downward.
</p>

<h4><code>confirm_selection</code></h4>

<pre><code>DialogueManager.confirm_selection()</code></pre>

<p>
Confirms the currently selected dialogue choice.
</p>

<h4><code>end_dialogue</code></h4>

<pre><code>DialogueManager.end_dialogue()</code></pre>

<p>
Ends the active dialogue and resets runtime dialogue state.
</p>

<h4><code>request_choices_after_text_finished</code></h4>

<pre><code>DialogueManager.request_choices_after_text_finished()</code></pre>

<p>
Requests available choices after the typewriter animation has completed.
</p>

<hr>

<h3>Signals</h3>

<h4><code>dialogue_started</code></h4>

<pre><code>signal dialogue_started</code></pre>

<p>
Emitted when a dialogue begins.
</p>

<h4><code>line_changed</code></h4>

<pre><code>signal line_changed(
	dialogue_node: DialogueNode,
	resolved_text: String
)</code></pre>

<p>
Emitted whenever the active dialogue node changes.
</p>

<h4><code>choices_requested</code></h4>

<pre><code>signal choices_requested(
	choices: Array,
	resolved_choice_texts: Array
)</code></pre>

<p>
Emitted when dialogue choices are ready to be displayed.
</p>

<h4><code>choice_selection_changed</code></h4>

<pre><code>signal choice_selection_changed(
	index: int,
	resolved_choice_texts: Array
)</code></pre>

<p>
Emitted whenever the selected dialogue choice changes.
</p>

<h4><code>dialogue_event_triggered</code></h4>

<pre><code>signal dialogue_event_triggered(event_id: String)</code></pre>

<p>
Emitted when a node or choice requests a gameplay event.
</p>

<h4><code>dialogue_command_requested</code></h4>

<pre><code>signal dialogue_command_requested(
	command: DialogueCommand
)</code></pre>

<p>
Emitted when a dialogue command should be processed.
</p>

<h4><code>dialogue_finished</code></h4>

<pre><code>signal dialogue_finished</code></pre>

<p>
Emitted when the active dialogue ends.
</p>

<hr>

<h2>DialogueLoader</h2>

<p>
Loads dialogue JSON files and converts them into framework data models.
</p>

<h3><code>load_dialogue</code></h3>

<pre><code>var dialogue_data: DialogueData = DialogueLoader.load_dialogue(
    "res://dialogue/example.json"
)</code></pre>

<p>
Returns <code>null</code> if the file cannot be loaded or parsed.
</p>

<hr>

<h2>DialogueComponent</h2>

<p>
Attach this component to an NPC or interactable object.
</p>

<h3>Inspector Properties</h3>

<ul>
  <li><code>dialogue_file</code>: Path to the JSON dialogue file.</li>
  <li><code>start_node</code>: Optional start node override.</li>
  <li><code>close_on_area_exit</code>: Ends dialogue when the player leaves the interaction area.</li>
  <li><code>lock_movement</code>: Locks player movement during dialogue.</li>
</ul>

<h3><code>start_dialogue</code></h3>

<pre><code>dialogue_component.start_dialogue()</code></pre>

<p>
Loads the assigned dialogue file and starts the conversation.
</p>

<hr>

<h2>DialogueVariableResolver</h2>

<p>
Resolves placeholders such as <code>{player_name}</code> or <code>{gold}</code>.
</p>

<h3>Provider Setup</h3>

<pre><code>DialogueVariableResolver.set_provider(
	Callable(GameState, "get_variable")
)</code></pre>

<p>
The provider must accept a variable name and default value.
</p>

<pre><code>func get_variable(
	variable_name: String,
	default_value = ""
):
	return variables.get(
		variable_name,
		default_value
	)</code></pre>

<hr>

<h2>DialogueConditionResolver</h2>

<p>
Evaluates boolean dialogue conditions.
</p>

<h3>Provider Setup</h3>

<pre><code>DialogueConditionResolver.set_provider(
	Callable(GameState, "has_flag")
)</code></pre>

<p>
The provider must accept a condition ID and return a boolean.
</p>

<pre><code>func has_flag(flag_name: String) -> bool:
	return flags.get(flag_name, false)</code></pre>

<h3>Condition Formats</h3>

<pre><code>"condition": "has_old_key"</code></pre>

<pre><code>"conditions": [
	"quest_active",
	"has_old_key",
    "!key_already_given"
]</code></pre>

<p>
The <code>!</code> prefix negates a condition.
</p>

<hr>

<h2>Dialogue Events</h2>

<p>
Dialogue events communicate with gameplay systems without creating direct dependencies.
</p>

<pre><code>"events": [
	"old_key_given",
    "old_key_quest_completed"
]</code></pre>

<p>
Listen to events from another system:
</p>

<pre><code>DialogueManager.dialogue_event_triggered.connect(
	_on_dialogue_event_triggered
)

func _on_dialogue_event_triggered(
	event_id: String
) -> void:
	match event_id:
		"old_key_given":
			inventory.remove_item("old_key")</code></pre>

<hr>

<h2>Dialogue Commands</h2>

<p>
Commands affect dialogue presentation or dialogue flow.
</p>

<h3>Set Text Speed</h3>

<pre><code>"commands": [
	{
		"type": "set_text_speed",
		"value": 20
	}
]</code></pre>

<h3>Reset Text Speed</h3>

<pre><code>"commands": [
	{
		"type": "reset_text_speed"
	}
]</code></pre>

<hr>

<h2>Data Models</h2>

<ul>
  <li><code>DialogueData</code>: Complete dialogue file data.</li>
  <li><code>DialogueSpeaker</code>: Speaker name and portrait path.</li>
  <li><code>DialogueNode</code>: Text, next node, choices, commands, and events.</li>
  <li><code>DialogueChoice</code>: Choice text, destination, events, and conditions.</li>
  <li><code>DialogueCommand</code>: Dialogue command type and values.</li>
  <li><code>DialogueStartRule</code>: Conditional dialogue start rule.</li>
</ul>

<hr>

<h2>Architecture Rule</h2>

<blockquote>
Dialogue manages dialogue, not gameplay.
</blockquote>

<p>
Quest, inventory, relationship, achievement, animation, camera, and save systems should communicate with the framework through providers and dialogue events.
</p>
