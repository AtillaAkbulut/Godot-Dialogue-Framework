<h1 align="center">Godot Dialogue Framework</h1>

<p align="center">
A modular, data-driven dialogue framework for Godot 4, designed for narrative games, prototypes, and game jams.
</p>

<p align="center">
  <strong>Current Version:</strong> v0.5.0-alpha
</p>

<hr>

<h2>Overview</h2>

<p>
Godot Dialogue Framework is a reusable dialogue system built around clean architecture, loose coupling, and data-driven narrative design.
</p>

<p>
The framework handles dialogue flow, branching choices, conditions, variables, portraits, events, commands, and interaction behavior without directly depending on gameplay systems such as quests, inventory, relationships, achievements, or saving.
</p>

<blockquote>
Dialogue manages dialogue, not gameplay.
</blockquote>

<p>
Gameplay systems communicate with the framework through providers, signals, conditions, variables, and dialogue events.
</p>

<hr>

<h2>Features</h2>

<h3>Dialogue Flow</h3>

<ul>
  <li>JSON-based dialogue files</li>
  <li>Node-based dialogue progression</li>
  <li>Branching dialogue choices</li>
  <li>Keyboard choice navigation</li>
  <li>Dialogue state management</li>
  <li>Conditional start nodes</li>
  <li>Conditional dialogue choices</li>
</ul>

<h3>Presentation</h3>

<ul>
  <li>Typewriter text effect</li>
  <li>Typewriter skip support</li>
  <li>Speaker names</li>
  <li>Portrait support</li>
  <li>Configurable text speed commands</li>
  <li>Movement locking during dialogue</li>
  <li>Dialogue closing when leaving an interaction area</li>
</ul>

<h3>Narrative Integration</h3>

<ul>
  <li>Dialogue variables such as <code>{player_name}</code> and <code>{gold}</code></li>
  <li>Boolean condition provider system</li>
  <li>Negated conditions using the <code>!</code> prefix</li>
  <li>Multiple events per node or choice</li>
  <li>NPC dialogue memory reference example</li>
  <li>Quest integration reference example</li>
  <li>Save and load reference example</li>
  <li>Gamejam-ready narrative demo</li>
</ul>

<h3>Architecture</h3>

<ul>
  <li>Separated data, runtime, presentation, and integration layers</li>
  <li>DialogueLoader data parsing layer</li>
  <li>DialogueData, DialogueNode, DialogueChoice, DialogueSpeaker, and DialogueCommand models</li>
  <li>Variable and condition providers</li>
  <li>Signal-based gameplay communication</li>
  <li>Framework-independent quest and save examples</li>
</ul>

<hr>

<h2>Architecture</h2>

<pre><code>Dialogue JSON
	  │
	  ▼
DialogueLoader
	  │
	  ▼
DialogueData
	  │
	  ├── DialogueSpeaker
	  ├── DialogueNode
	  ├── DialogueChoice
	  ├── DialogueCommand
	  └── DialogueStartRule
	  │
	  ▼
DialogueManager
	  │
	  ├── DialogueUI
	  ├── DialogueComponent
	  ├── Dialogue Events
	  ├── Dialogue Commands
	  ├── Variable Resolver
	  └── Condition Resolver
			   │
			   ▼
		Gameplay Systems
		├── GameState
		├── Quest System
		├── Inventory
		├── Relationships
		└── Save System</code></pre>

<h3>Responsibility Summary</h3>

<ul>
  <li><strong>Dialogue JSON:</strong> Stores dialogue content, branches, conditions, events, and commands.</li>
  <li><strong>DialogueLoader:</strong> Converts JSON data into framework models.</li>
  <li><strong>DialogueManager:</strong> Controls dialogue runtime flow and state.</li>
  <li><strong>DialogueUI:</strong> Displays text, portraits, and choices.</li>
  <li><strong>DialogueComponent:</strong> Connects an NPC or interactable object to a dialogue file.</li>
  <li><strong>Variable Resolver:</strong> Requests dynamic values from the game.</li>
  <li><strong>Condition Resolver:</strong> Requests boolean state from the game.</li>
  <li><strong>Gameplay Systems:</strong> React to dialogue events and manage actual game state.</li>
</ul>

<hr>

<h2>Installation</h2>

<ol>
  <li>Copy the framework files into your Godot project.</li>
  <li>Add <code>dialogue_manager.gd</code> as an Autoload named <code>DialogueManager</code>.</li>
  <li>Add <code>DialogueUI.tscn</code> to your main scene.</li>
  <li>Create a dialogue JSON file.</li>
  <li>Add a <code>DialogueComponent</code> node to an NPC or interactable object.</li>
  <li>Assign the JSON file through the Inspector.</li>
  <li>Connect your variable and condition providers.</li>
  <li>Listen to dialogue events from your gameplay systems.</li>
</ol>

<hr>

<h2>Provider Setup</h2>

<h3>Variable Provider</h3>

<pre><code>DialogueVariableResolver.set_provider(
	Callable(GameState, "get_variable")
)</code></pre>

<p>
The provider should accept a variable name and a default value.
</p>

<pre><code>func get_variable(variable_name: String, default_value = ""):
	return variables.get(variable_name, default_value)</code></pre>

<h3>Condition Provider</h3>

<pre><code>DialogueConditionResolver.set_provider(
	Callable(GameState, "has_flag")
)</code></pre>

<p>
The provider should accept a condition ID and return a boolean value.
</p>

<pre><code>func has_flag(flag_name: String) -&gt; bool:
	return flags.get(flag_name, false)</code></pre>

<hr>

<h2>Basic Dialogue Example</h2>

<pre><code>{
  "speaker": {
	"name": "Old Man",
	"portrait": "res://portraits/old_man.png"
  },

  "start": "first_meeting",

  "start_rules": [
	{
	  "conditions": [
        "old_key_quest_completed"
	  ],
	  "start": "quest_completed_intro"
	},
	{
	  "conditions": [
		"old_key_quest_active",
        "has_old_key"
	  ],
	  "start": "key_found_intro"
	}
  ],

  "nodes": {
	"first_meeting": {
	  "text": "Hello, {player_name}.",
	  "choices": [
		{
		  "text": "Who are you?",
		  "next": "introduction"
		},
		{
		  "text": "Leave.",
		  "next": "leave"
		}
	  ]
	},

	"introduction": {
	  "text": "I have been waiting for someone to help me.",
	  "events": [
        "old_man_met_player"
	  ],
	  "end": true
	},

	"leave": {
	  "text": "Take care.",
	  "end": true
	}
  }
}</code></pre>

<p>
See <code>DIALOGUE_FORMAT.md</code> for the complete dialogue data format.
</p>

<hr>

<h2>Dialogue Events</h2>

<p>
Dialogue events allow the framework to notify gameplay systems without directly depending on them.
</p>

<pre><code>"events": [
  "old_key_given",
  "old_key_quest_completed"
]</code></pre>

<p>
Gameplay code can listen to those events:
</p>

<pre><code>DialogueManager.dialogue_event_triggered.connect(
	_on_dialogue_event_triggered
)

func _on_dialogue_event_triggered(event_id: String) -&gt; void:
	match event_id:
		"old_key_given":
			inventory.remove_item("old_key")

		"old_key_quest_completed":
			quest_manager.complete_quest("old_key_quest")</code></pre>

<hr>

<h2>Dialogue Variables</h2>

<pre><code>"text": "Hello, {player_name}. You have {gold} coins."</code></pre>

<p>
Variables are resolved through the configured variable provider before the text is displayed.
</p>

<hr>

<h2>Dialogue Conditions</h2>

<h3>Single Condition</h3>

<pre><code>"condition": "has_old_key"</code></pre>

<h3>Multiple Conditions</h3>

<pre><code>"conditions": [
  "old_key_quest_active",
  "has_old_key",
  "!key_already_given"
]</code></pre>

<p>
All listed conditions must be true. The <code>!</code> prefix negates a condition.
</p>

<hr>

<h2>Commands</h2>

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

<p>
Commands are reserved for dialogue presentation and flow. Gameplay actions such as quests, animations, sounds, achievements, and camera effects should normally use dialogue events.
</p>

<hr>

<h2>Demo</h2>

<p>
The included narrative demo demonstrates:
</p>

<ul>
  <li>NPC interaction</li>
  <li>NPC dialogue memory</li>
  <li>Dialogue variables</li>
  <li>Conditional choices</li>
  <li>Conditional start nodes</li>
  <li>Quest acceptance and completion</li>
  <li>Persistent save and load state</li>
  <li>Game state debugging</li>
</ul>

<h3>Demo Controls</h3>

<ul>
  <li><strong>Movement:</strong> WASD or Arrow Keys</li>
  <li><strong>Interact:</strong> E</li>
  <li><strong>Advance / Confirm:</strong> Space or Enter</li>
  <li><strong>Choice Selection:</strong> Up / Down</li>
  <li><strong>Receive Test Key:</strong> K</li>
  <li><strong>Save:</strong> P</li>
  <li><strong>Load:</strong> O</li>
  <li><strong>Delete Save:</strong> Delete</li>
</ul>

<p>
Quest, game state, and save scripts inside the demo are reference implementations. They are not required framework dependencies.
</p>

<hr>

<h2>Documentation</h2>

<ul>
  <li><code>README.md</code> — Project overview and setup</li>
  <li><code>API.md</code> — Public API reference</li>
  <li><code>DIALOGUE_FORMAT.md</code> — JSON dialogue format reference</li>
  <li><code>ARCHITECTURE.md</code> — Long-term architecture vision</li>
  <li><code>TODO</code> — Current development roadmap</li>
  <li><code>demo/README.md</code> — Demo controls and flow</li>
</ul>

<hr>

<h2>Roadmap</h2>

<h3>v0.5 — Reference Implementations</h3>

<ul>
  <li>✅ NPC dialogue memory example</li>
  <li>✅ Quest integration reference example</li>
  <li>✅ Save and load reference example</li>
  <li>✅ Gamejam-ready narrative demo</li>
</ul>

<h3>v0.6 — Advanced Narrative Data</h3>

<ul>
  <li>Comparison-based conditions</li>
  <li>Numeric variable conditions</li>
  <li>Choice IDs</li>
  <li>Dialogue metadata</li>
  <li>Node tags</li>
  <li>Relationship integration example</li>
</ul>

<h3>Future</h3>

<ul>
  <li>Multi-speaker dialogue files</li>
  <li>Active speaker portrait presentation</li>
  <li>Wait command</li>
  <li>Rich text support</li>
  <li>Typewriter sounds</li>
  <li>Localization</li>
  <li>Dialogue command processor</li>
  <li>Godot editor plugin</li>
  <li>Asset Library release</li>
  <li>Stable v1.0 public API</li>
</ul>

<hr>

<h2>Project Status</h2>

<p>
The framework is currently in alpha development.
</p>

<p>
The current release is suitable for prototypes, game jams, portfolio projects, and small narrative games. The public API and data format may still change before v1.0.
</p>

<hr>

<h2>Contributing</h2>

<p>
Suggestions, issues, bug reports, and improvements are welcome.
</p>

<p>
Please keep proposed changes consistent with the central architecture rule:
</p>

<blockquote>
Dialogue manages dialogue, not gameplay.
</blockquote>

<hr>

<h2>License</h2>

<p>
This project is licensed under the MIT License.
</p>
