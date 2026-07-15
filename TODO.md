<h1>Godot Dialogue Framework — Roadmap</h1>

<p>
This document tracks planned features, architectural improvements, and future releases for the Godot Dialogue Framework.
</p>

<p>
The roadmap may change as the framework is tested in real projects.
</p>

<blockquote>
Dialogue manages dialogue, not gameplay.
</blockquote>

<hr>

<h2>v0.5 — Reference Implementations</h2>

<p>
Status: <strong>Completed</strong>
</p>

<ul>
  <li>✅ Dialogue variables</li>
  <li>✅ Condition provider system</li>
  <li>✅ Conditional dialogue choices</li>
  <li>✅ Conditional start nodes</li>
  <li>✅ NPC dialogue memory example</li>
  <li>✅ Quest integration reference example</li>
  <li>✅ Save and load reference example</li>
  <li>✅ Gamejam-ready narrative demo</li>
  <li>✅ Demo state debugging UI</li>
  <li>✅ API documentation</li>
  <li>✅ Dialogue format documentation</li>
</ul>

<hr>

<h2>v0.6 — Advanced Narrative Data</h2>

<p>
Goal: Expand the dialogue data model for more complex narrative and relationship-driven games.
</p>

<h3>Conditions</h3>

<ul>
  <li>⬜ Comparison-based conditions</li>
  <li>⬜ Numeric variable conditions</li>
  <li>⬜ String comparison conditions</li>
  <li>⬜ Condition operators</li>
</ul>

<p>
Planned operators:
</p>

<pre><code>==
!=
&gt;
&gt;=
&lt;
&lt;=</code></pre>

<p>
Example:
</p>

<pre><code>{
  "variable": "old_man_affection",
  "operator": "&gt;=",
  "value": 50
}</code></pre>

<h3>Dialogue Identity</h3>

<ul>
  <li>⬜ Choice IDs</li>
  <li>⬜ Node metadata</li>
  <li>⬜ Node tags</li>
</ul>

<p>
Example:
</p>

<pre><code>{
  "text": "I trust you.",

  "metadata": {
    "chapter": "chapter_1",
    "emotion": "warm"
  },

  "tags": [
    "relationship",
    "old_man",
    "main_story"
  ]
}</code></pre>

<h3>Relationship Integration</h3>

<ul>
  <li>⬜ Relationship system reference example</li>
  <li>⬜ Affection variable integration example</li>
  <li>⬜ Relationship-based conditional choices</li>
  <li>⬜ Relationship-based conditional start nodes</li>
</ul>

<p>
The relationship system will remain external to the dialogue framework.
</p>

<p>
The framework will communicate with relationship systems through variables, conditions, and dialogue events.
</p>

<hr>

<h2>v0.7 — Dialogue Presentation and Flow</h2>

<p>
Goal: Improve dialogue feel, pacing, and presentation without coupling the framework to gameplay systems.
</p>

<ul>
  <li>⬜ Wait command</li>
  <li>⬜ Rich text support</li>
  <li>⬜ Typewriter sound support</li>
  <li>⬜ Per-node text speed</li>
  <li>⬜ Improved command processing</li>
  <li>⬜ Command validation</li>
</ul>

<h3>Planned Wait Command</h3>

<pre><code>{
  "type": "wait",
  "duration": 0.5
}</code></pre>

<h3>Planned Typewriter Sound Command</h3>

<pre><code>{
  "type": "set_typewriter_sound",
  "sound": "res://audio/dialogue/typewriter.wav"
}</code></pre>

<p>
Animations, camera shake, quest progression, inventory changes, and other gameplay behavior should continue to use dialogue events.
</p>

<hr>

<h2>v0.8 — Multi-Speaker Dialogue</h2>

<p>
Goal: Support conversations involving multiple characters inside a single dialogue file.
</p>

<ul>
  <li>⬜ Multiple speaker definitions per dialogue file</li>
  <li>⬜ Per-node speaker selection</li>
  <li>⬜ Active speaker tracking</li>
  <li>⬜ Active portrait presentation</li>
  <li>⬜ Inactive portrait opacity</li>
  <li>⬜ Speaker switching</li>
</ul>

<p>
Possible format:
</p>

<pre><code>{
  "speakers": {
    "old_man": {
      "name": "Old Man",
      "portrait": "res://portraits/old_man.png"
    },

    "player": {
      "name": "Player",
      "portrait": "res://portraits/player.png"
    }
  },

  "nodes": {
    "intro": {
      "speaker": "old_man",
      "text": "You came back."
    },

    "player_response": {
      "speaker": "player",
      "text": "I said I would."
    }
  }
}</code></pre>

<hr>

<h2>v0.9 — Production Readiness</h2>

<p>
Goal: Prepare the framework for broader project usage and a stable public API.
</p>

<ul>
  <li>⬜ Dialogue data validation</li>
  <li>⬜ Missing node validation</li>
  <li>⬜ Invalid start rule warnings</li>
  <li>⬜ Invalid command warnings</li>
  <li>⬜ Duplicate ID detection</li>
  <li>⬜ Improved error messages</li>
  <li>⬜ Debug logging configuration</li>
  <li>⬜ Example project cleanup</li>
  <li>⬜ Public API review</li>
  <li>⬜ Data format review</li>
</ul>

<hr>

<h2>v1.0 — Stable Dialogue Framework</h2>

<p>
Goal: Provide a stable and documented dialogue framework suitable for production projects.
</p>

<ul>
  <li>⬜ Stable public API</li>
  <li>⬜ Stable dialogue JSON format</li>
  <li>⬜ Complete API documentation</li>
  <li>⬜ Complete dialogue format documentation</li>
  <li>⬜ Installation guide</li>
  <li>⬜ Integration guide</li>
  <li>⬜ Production-ready demo</li>
  <li>⬜ Migration notes</li>
  <li>⬜ Godot Asset Library preparation</li>
</ul>

<hr>

<h2>Future Research</h2>

<p>
These features are not assigned to a release yet.
</p>

<ul>
  <li>Dialogue localization IDs</li>
  <li>External localization table integration</li>
  <li>Dialogue history / backlog</li>
  <li>Auto-advance dialogue</li>
  <li>Timed dialogue choices</li>
  <li>Choice history queries</li>
  <li>Dialogue analytics hooks</li>
  <li>Custom condition evaluators</li>
  <li>Custom command processors</li>
  <li>Dialogue editor plugin</li>
  <li>Visual node editor</li>
  <li>JSON validation tools</li>
  <li>Dialogue graph debugging</li>
</ul>

<hr>

<h2>Out of Scope</h2>

<p>
The following systems should not become direct responsibilities of the dialogue framework:
</p>

<ul>
  <li>Quest management</li>
  <li>Inventory management</li>
  <li>Relationship state management</li>
  <li>Achievement management</li>
  <li>Character animation systems</li>
  <li>Camera systems</li>
  <li>Audio management</li>
  <li>Game save architecture</li>
</ul>

<p>
These systems should integrate with the framework through dialogue events, providers, variables, and conditions.
</p>
