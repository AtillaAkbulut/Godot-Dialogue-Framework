<h1>Godot Dialogue Framework - Architecture Vision</h1>

<p>
This document describes the long-term vision of the framework. It contains ideas that are intentionally postponed until the architecture is mature enough.
</p>

<hr>

<h2>Core Principles</h2>

<ul>
  <li>Dialogue manages dialogue, not gameplay.</li>
  <li>Systems should be loosely coupled.</li>
  <li>Components should have a single responsibility.</li>
  <li>Public APIs should remain small and easy to understand.</li>
  <li>New features should extend the framework instead of modifying existing behavior whenever possible.</li>
</ul>

<hr>

<h2>Current Architecture</h2>

<pre><code>JSON
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
    └── DialogueCommand
    │
    ▼
DialogueManager
    │
    ├── DialogueUI
    ├── DialogueComponent
    ├── Events
    └── Commands</code></pre>

<hr>

<h2>Planned Architecture Improvements</h2>

<h3>DialogueCommandProcessor</h3>

<p>
Current implementation executes commands inside the UI. In the future, commands should be processed by a dedicated command processor.
</p>

<pre><code>DialogueManager
        │
        ▼
DialogueCommandProcessor
        │
        ├── wait
        ├── set_text_speed
        ├── reset_text_speed
        └── ...</code></pre>

<ul>
  <li>Cleaner DialogueUI</li>
  <li>Easier extension</li>
  <li>Better separation of responsibilities</li>
</ul>

<h3>Multi-Speaker Support</h3>

<p>
Current architecture supports a single speaker per dialogue file. Future versions should allow each node to reference its own speaker.
</p>

<pre><code>DialogueNode
    └── speaker</code></pre>

<ul>
  <li>NPC conversations</li>
  <li>Cutscenes</li>
  <li>Party dialogue</li>
  <li>Player dialogue</li>
  <li>Multiple portraits</li>
</ul>

<h3>Dialogue Variables</h3>

<pre><code>{player_name}
{quest_name}
{gold}</code></pre>

<p>
Variables should be resolved before displaying dialogue.
</p>

<h3>Dialogue Conditions</h3>

<pre><code>if player_has_key
if quest_completed
if relationship &gt; 50</code></pre>

<p>
Conditions should determine available dialogue branches.
</p>

<h3>Dialogue Commands</h3>

<ul>
  <li>wait</li>
  <li>set_text_speed</li>
  <li>reset_text_speed</li>
  <li>pause_input</li>
  <li>resume_input</li>
</ul>

<p>
Commands should affect only dialogue presentation and dialogue flow. Gameplay actions should remain outside the framework.
</p>

<h3>Dialogue Events</h3>

<p>
Events should remain the primary communication method with gameplay systems.
</p>

<ul>
  <li>QuestManager</li>
  <li>InventoryManager</li>
  <li>AnimationManager</li>
  <li>CameraManager</li>
  <li>AchievementManager</li>
  <li>Analytics</li>
</ul>

<p>
The dialogue framework should never directly call gameplay systems.
</p>

<h3>Localization</h3>

<p>
Support multiple languages without changing dialogue logic.
</p>

<ul>
  <li>JSON</li>
  <li>CSV</li>
  <li>TranslationServer</li>
  <li>Godot Resources</li>
</ul>

<h3>Asset Library Plugin</h3>

<pre><code>addons/
    godot_dialogue_framework/</code></pre>

<p>
The framework should eventually become a reusable Godot plugin.
</p>

<h3>Demo Project</h3>

<p>
The repository should always include a small playable demo demonstrating:
</p>

<ul>
  <li>Basic dialogue</li>
  <li>Portraits</li>
  <li>Choices</li>
  <li>Events</li>
  <li>Commands</li>
  <li>Future features</li>
</ul>

<hr>

<h2>Version Roadmap</h2>

<h3>v0.3</h3>

<ul>
  <li>DialogueLoader</li>
  <li>DialogueData</li>
  <li>DialogueSpeaker</li>
  <li>DialogueNode</li>
  <li>DialogueChoice</li>
  <li>DialogueCommand</li>
  <li>Multiple Events</li>
  <li>Text Speed Command</li>
  <li>Wait Command</li>
  <li>API cleanup</li>
  <li>Documentation improvements</li>
</ul>

<h3>v0.4</h3>

<ul>
  <li>DialogueCommandProcessor</li>
  <li>RichTextLabel support</li>
  <li>Dialogue variables</li>
  <li>Dialogue conditions</li>
  <li>Portrait animation</li>
  <li>Typewriter sounds</li>
  <li>Localization foundation</li>
</ul>

<h3>v0.5</h3>

<ul>
  <li>Quest integration example</li>
  <li>Camera event example</li>
  <li>Animation event example</li>
  <li>Audio event example</li>
  <li>Save/Load example</li>
  <li>Performance improvements</li>
</ul>

<h3>v1.0</h3>

<ul>
  <li>Godot Editor Plugin</li>
  <li>Asset Library release</li>
  <li>Stable API</li>
  <li>Complete documentation</li>
  <li>Sample game</li>
  <li>Production-ready architecture</li>
</ul>

<hr>

<h2>Philosophy</h2>

<blockquote>
  Does this belong inside a dialogue framework, or should it remain a gameplay system?
</blockquote>

<p>
If it belongs to gameplay, communicate through events.
</p>

<p>
If it belongs to dialogue presentation or dialogue flow, implement it through commands.
</p>

<p>
Keeping this distinction clear is the foundation of the framework's architecture.
</p>
