<h1>Godot Dialogue Framework</h1>

<p>
A lightweight, modular dialogue framework for Godot focused on clean architecture,
reusability, and narrative-driven games.
</p>

<p>
This project aims to provide a flexible foundation for dialogue systems while remaining
independent from gameplay systems such as quests, inventory, animations, or save systems.
</p>

<hr>

<h2>Features</h2>

<h3>Current Features</h3>

<ul>
    <li>JSON-based dialogue files</li>
    <li>Single-speaker dialogue format</li>
    <li>Portrait support</li>
    <li>Typewriter text effect</li>
    <li>Skip typewriter animation</li>
    <li>Keyboard dialogue navigation</li>
    <li>Keyboard choice selection</li>
    <li>Configurable movement lock</li>
    <li>Automatic dialogue closing on interaction area exit</li>
    <li>Modular DialogueManager</li>
    <li>Reusable DialogueComponent</li>
    <li>Decoupled DialogueUI</li>
    <li>Dialogue state management</li>
    <li>Demo project included</li>
</ul>

<hr>

<h2>Architecture</h2>

<pre><code>
Player
    │
    ▼
DialogueInteractor
    │
    ▼
DialogueComponent
    │
    ▼
DialogueManager
    │
    ▼
DialogueUI
</code></pre>

<h3>Responsibilities</h3>

<h4>DialogueManager</h4>

<ul>
    <li>Controls dialogue flow</li>
    <li>Manages dialogue state</li>
    <li>Handles dialogue choices</li>
    <li>Controls dialogue progression</li>
</ul>

<h4>DialogueComponent</h4>

<ul>
    <li>Stores dialogue data reference</li>
    <li>Starts dialogue</li>
    <li>Provides dialogue configuration</li>
</ul>

<h4>DialogueUI</h4>

<ul>
    <li>Displays dialogue text</li>
    <li>Displays portraits</li>
    <li>Displays dialogue choices</li>
    <li>Handles the typewriter effect</li>
</ul>

<h4>DialogueInteractor</h4>

<ul>
    <li>Detects interactable NPCs</li>
    <li>Starts conversations</li>
    <li>Ends conversations when required</li>
</ul>

<hr>

<h2>Dialogue File Example</h2>

```json
{
  "speaker": {
    "name": "Old Man",
    "portrait": "res://portraits/old_man.png"
  },
  "start": "intro",
  "nodes": {
    "intro": {
      "text": "Hey. You look lost.",
      "next": "question"
    },
    "question": {
      "text": "Do you need help?",
      "choices": [
        {
          "text": "Yes.",
          "next": "yes"
        },
        {
          "text": "No.",
          "next": "no"
        }
      ]
    }
  }
}
```

<hr>

<h2>Design Philosophy</h2>

<blockquote>
Dialogue should manage dialogue, not gameplay.
</blockquote>

<p>
Gameplay systems such as quests, cutscenes, inventory, combat, or progression should
react to dialogue events rather than being implemented directly inside the dialogue framework.
</p>

<hr>

<h2>Roadmap</h2>

<h3>v0.3</h3>

<ul>
    <li>DialogueLoader</li>
    <li>DialogueNode</li>
    <li>DialogueSpeaker</li>
    <li>Event Trigger System</li>
    <li>Dialogue Events</li>
    <li>Internal API cleanup</li>
    <li>DialogueManager architecture improvements</li>
</ul>

<h3>v0.4</h3>

<ul>
    <li>Portrait animations</li>
    <li>Typewriter sounds</li>
    <li>RichTextLabel support</li>
    <li>Dialogue variables</li>
    <li>Dialogue conditions</li>
    <li>Dialogue commands</li>
</ul>

<h3>v0.5</h3>

<ul>
    <li>Animation events</li>
    <li>Camera events</li>
    <li>Audio events</li>
    <li>Cutscene support</li>
    <li>Save / Load integration example</li>
</ul>

<h3>v1.0</h3>

<ul>
    <li>Godot Editor Plugin</li>
    <li>Dialogue Resources (.tres)</li>
    <li>Localization support</li>
    <li>Full documentation</li>
    <li>Example project</li>
    <li>Stable public API</li>
</ul>

<hr>

<h2>Contributing</h2>

<p>
Suggestions, bug reports, and improvements are always welcome.
</p>

<hr>

<h2>License</h2>

<p>
This project is licensed under the MIT License.
</p>
