<h1>Godot Dialogue Framework Demo</h1>

<p>
This demo demonstrates how the Godot Dialogue Framework can be integrated into a small narrative game.
</p>

<hr>

<h2>Features Demonstrated</h2>

<ul>
  <li>NPC interaction</li>
  <li>Typewriter dialogue text</li>
  <li>Keyboard choice navigation</li>
  <li>Portrait support</li>
  <li>Dialogue variables</li>
  <li>Conditional dialogue choices</li>
  <li>Conditional start nodes</li>
  <li>NPC dialogue memory</li>
  <li>Quest integration</li>
  <li>Dialogue events</li>
  <li>Save and load integration</li>
</ul>

<hr>

<h2>Controls</h2>

<ul>
  <li><strong>Movement:</strong> WASD or Arrow Keys</li>
  <li><strong>Interact:</strong> E</li>
  <li><strong>Advance Dialogue:</strong> Space or Enter</li>
  <li><strong>Select Choice:</strong> Up / Down</li>
  <li><strong>Receive Test Key:</strong> K</li>
  <li><strong>Save:</strong> P</li>
  <li><strong>Load:</strong> O</li>
  <li><strong>Delete Save:</strong> Delete</li>
</ul>

<hr>

<h2>Demo Flow</h2>

<ol>
  <li>Talk to the Old Man for the first time.</li>
  <li>Talk to him again to receive the key quest.</li>
  <li>Press <code>K</code> to simulate receiving the old key.</li>
  <li>Return to the Old Man and give him the key.</li>
  <li>Talk to him again to see the completed quest dialogue.</li>
  <li>Use the save and load controls to test persistent dialogue state.</li>
</ol>

<hr>

<h2>Architecture</h2>

<pre><code>Dialogue JSON
	│
	▼
Dialogue Framework
	│
	├── Dialogue Events
	├── Variable Requests
	└── Condition Requests
			│
			▼
		DemoScene
		├── GameState
		├── QuestExample
		└── SaveExample</code></pre>

<hr>

<h2>Important Note</h2>

<p>
The quest, game state, and save systems included in this demo are reference implementations.
They are not required parts of the dialogue framework.
</p>

<p>
Projects can replace them with their own quest, inventory, relationship, or save systems by connecting providers and listening to dialogue events.
</p>
