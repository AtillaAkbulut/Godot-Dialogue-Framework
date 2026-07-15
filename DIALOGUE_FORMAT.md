<h1>Godot Dialogue Framework — Dialogue Format Reference</h1>

<p>
This document describes the JSON dialogue format supported by the Godot Dialogue Framework.
</p>

<hr>

<h2>Complete Structure</h2>

<pre><code>{
  "speaker": {
	"name": "Old Man",
	"portrait": "res://portraits/old_man.png"
  },

  "start": "default_intro",

  "start_rules": [
	{
	  "conditions": [
        "quest_completed"
	  ],
	  "start": "completed_intro"
	}
  ],

  "nodes": {
	"default_intro": {
	  "text": "Hello, {player_name}.",
	  "next": "question"
	},

	"question": {
	  "text": "What do you want to do?",
	  "commands": [
		{
		  "type": "set_text_speed",
		  "value": 30
		}
	  ],
	  "choices": [
		{
		  "text": "Accept the quest.",
		  "next": "accept",
		  "conditions": [
			"!quest_active",
            "!quest_completed"
		  ],
		  "events": [
            "quest_accepted"
		  ]
		},
		{
		  "text": "Leave.",
		  "next": "leave"
		}
	  ]
	},

	"accept": {
	  "text": "Thank you.",
	  "events": [
        "quest_started"
	  ],
	  "end": true
	},

	"completed_intro": {
	  "text": "Thank you for your help.",
	  "end": true
	},

	"leave": {
	  "text": "Take care.",
	  "end": true
	}
  }
}</code></pre>

<hr>

<h2>Root Properties</h2>

<h3><code>speaker</code></h3>

<p>
Defines the default speaker used by every node in the dialogue file.
</p>

<pre><code>"speaker": {
  "name": "Old Man",
  "portrait": "res://portraits/old_man.png"
}</code></pre>

<ul>
  <li><code>name</code>: Speaker name displayed by the dialogue UI.</li>
  <li><code>portrait</code>: Godot resource path to the speaker portrait.</li>
</ul>

<p>
The current data format uses one default speaker per dialogue file.
</p>

<h3><code>start</code></h3>

<p>
Defines the fallback node used when no conditional start rule succeeds.
</p>

<pre><code>"start": "default_intro"</code></pre>

<p>
The value must match an ID inside the <code>nodes</code> object.
</p>

<h3><code>start_rules</code></h3>

<p>
Defines condition-based start node selection.
</p>

<pre><code>"start_rules": [
  {
	"conditions": [
      "quest_completed"
	],
	"start": "completed_intro"
  },
  {
	"conditions": [
	  "quest_active",
      "has_quest_item"
	],
	"start": "item_found_intro"
  }
]</code></pre>

<p>
Rules are evaluated from top to bottom. The first successful rule is used.
</p>

<p>
Place the most specific rules before more general rules.
</p>

<h3><code>nodes</code></h3>

<p>
Contains all dialogue nodes, indexed by unique string IDs.
</p>

<pre><code>"nodes": {
  "intro": {
	"text": "Hello.",
	"next": "question"
  }
}</code></pre>

<hr>

<h2>Node Properties</h2>

<h3><code>text</code></h3>

<p>
The text displayed when the node becomes active.
</p>

<pre><code>"text": "Hello, {player_name}."</code></pre>

<p>
Text may contain variable placeholders.
</p>

<h3><code>next</code></h3>

<p>
Defines the next node used when the player advances.
</p>

<pre><code>"next": "question"</code></pre>

<p>
If a node contains neither <code>next</code> nor <code>choices</code>, the dialogue ends when advanced.
</p>

<h3><code>end</code></h3>

<p>
Marks the node as the final node of the conversation.
</p>

<pre><code>"end": true</code></pre>

<h3><code>choices</code></h3>

<p>
Defines the choices displayed after the node text has finished typing.
</p>

<pre><code>"choices": [
  {
	"text": "Yes.",
	"next": "accept"
  },
  {
	"text": "No.",
	"next": "decline"
  }
]</code></pre>

<h3><code>events</code></h3>

<p>
Defines one or more gameplay event IDs emitted when the node becomes active.
</p>

<pre><code>"events": [
  "quest_started",
  "achievement_first_quest"
]</code></pre>

<p>
The framework does not interpret event IDs. Gameplay systems decide how to react.
</p>

<h3><code>commands</code></h3>

<p>
Defines dialogue presentation or flow commands executed when the node becomes active.
</p>

<pre><code>"commands": [
  {
	"type": "set_text_speed",
	"value": 20
  }
]</code></pre>

<hr>

<h2>Choice Properties</h2>

<h3><code>text</code></h3>

<p>
The choice text displayed to the player.
</p>

<pre><code>"text": "Give {gold} coins."</code></pre>

<p>
Choice text supports dialogue variables.
</p>

<h3><code>next</code></h3>

<p>
Defines the node opened after the choice is confirmed.
</p>

<pre><code>"next": "payment_confirmed"</code></pre>

<h3><code>condition</code></h3>

<p>
Defines a single boolean condition.
</p>

<pre><code>"condition": "has_old_key"</code></pre>

<h3><code>conditions</code></h3>

<p>
Defines multiple boolean conditions. All conditions must succeed.
</p>

<pre><code>"conditions": [
  "quest_active",
  "has_old_key",
  "!key_already_given"
]</code></pre>

<p>
The <code>!</code> prefix negates a condition.
</p>

<h3><code>events</code></h3>

<p>
Defines events emitted immediately when the choice is confirmed.
</p>

<pre><code>"events": [
  "help_offer_accepted",
  "tutorial_choice_completed"
]</code></pre>

<hr>

<h2>Variables</h2>

<p>
Variables use curly-brace placeholders.
</p>

<pre><code>"text": "Hello, {player_name}. You have {gold} coins."</code></pre>

<p>
The framework requests each value from the configured variable provider.
</p>

<p>
Variables work inside:
</p>

<ul>
  <li>Node text</li>
  <li>Choice text</li>
</ul>

<p>
If a variable cannot be resolved, the original placeholder remains visible.
</p>

<pre><code>Your rank is {player_rank}.</code></pre>

<hr>

<h2>Conditions</h2>

<p>
Conditions are resolved through the configured condition provider.
</p>

<h3>Positive Condition</h3>

<pre><code>"condition": "has_key"</code></pre>

<h3>Negated Condition</h3>

<pre><code>"condition": "!has_key"</code></pre>

<h3>Multiple Conditions</h3>

<pre><code>"conditions": [
  "quest_active",
  "has_key",
  "!door_opened"
]</code></pre>

<p>
The current condition system supports boolean conditions. Numeric comparisons are planned for a future release.
</p>

<hr>

<h2>Events</h2>

<p>
Events are used for gameplay communication.
</p>

<p>
Recommended uses include:
</p>

<ul>
  <li>Starting or completing quests</li>
  <li>Changing inventory</li>
  <li>Updating NPC memory</li>
  <li>Changing relationship values</li>
  <li>Triggering animations</li>
  <li>Triggering camera behavior</li>
  <li>Playing sounds</li>
  <li>Unlocking achievements</li>
</ul>

<p>
Events should describe what happened, not contain gameplay code.
</p>

<pre><code>"events": [
  "old_key_given",
  "old_key_quest_completed"
]</code></pre>

<hr>

<h2>Commands</h2>

<p>
Commands affect dialogue presentation or dialogue flow.
</p>

<h3><code>set_text_speed</code></h3>

<pre><code>"commands": [
  {
	"type": "set_text_speed",
	"value": 15
  }
]</code></pre>

<h3><code>reset_text_speed</code></h3>

<pre><code>"commands": [
  {
	"type": "reset_text_speed"
  }
]</code></pre>

<p>
Gameplay behavior should normally be implemented through events rather than commands.
</p>

<hr>

<h2>Conditional Start Example</h2>

<pre><code>"start": "first_meeting",

"start_rules": [
  {
	"conditions": [
      "quest_completed"
	],
	"start": "completed_intro"
  },
  {
	"conditions": [
	  "quest_active",
      "has_old_key"
	],
	"start": "key_found_intro"
  },
  {
	"conditions": [
      "quest_active"
	],
	"start": "quest_active_intro"
  },
  {
	"conditions": [
      "talked_to_old_man"
	],
	"start": "returning_player"
  }
]</code></pre>

<p>
The most specific state should be listed first.
</p>

<hr>

<h2>Recommended File Organization</h2>

<pre><code>dialogue/
├── characters/
│   ├── old_man_dialogue.json
│   ├── shopkeeper_dialogue.json
│   └── guard_dialogue.json
│
├── story/
│   ├── chapter_01.json
│   └── chapter_02.json
│
└── portraits/
	├── old_man.png
	├── shopkeeper.png
	└── guard.png</code></pre>

<p>
The current format is optimized for one default speaker per file. Multi-speaker support is planned for a future release.
</p>

<hr>

<h2>Validation Recommendations</h2>

<ul>
  <li>Use unique node IDs.</li>
  <li>Ensure every <code>next</code> value references an existing node.</li>
  <li>Ensure every start rule references an existing node.</li>
  <li>Keep event IDs consistent with gameplay listeners.</li>
  <li>Place specific start rules before general ones.</li>
  <li>Always include a fallback <code>start</code> node.</li>
  <li>Provide a fallback path when all conditional choices may be hidden.</li>
</ul>

<hr>

<h2>Planned Format Extensions</h2>

<ul>
  <li>Numeric comparison conditions</li>
  <li>Choice IDs</li>
  <li>Node metadata</li>
  <li>Node tags</li>
  <li>Multi-speaker dialogue files</li>
  <li>Relationship integration</li>
  <li>Wait commands</li>
  <li>Localization identifiers</li>
</ul>
