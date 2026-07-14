# Setup & Implementierungs-Readiness

Checkliste vor dem ersten Code-Commit. Basis: [PRD](./PRD.md) + [TDD](./TDD.md) (Approved).

---

## Status-Übersicht

| Bereich | Status | Blockiert Implementierung? |
|---------|--------|----------------------------|
| PRD | ✅ Approved (Godot 4) | Nein |
| TDD / Architektur | ✅ Approved (Godot 4) | Nein |
| Architekturentscheidungen (§24) | ✅ Verbindlich | Nein |
| Godot-Projekt | ✅ M01 Scaffold | Nein |
| Godot 4.x installiert | ✅ 4.7 (winget) | Nein |
| Android Export Templates | ❓ Prüfen | **Ja** (für Device-Tests) |
| GDD | ⏳ Optional | Nein (PRD reicht für Vertical Slice) |
| Production Plan | ⏳ Optional | Nein |
| Game-Art Assets | ⏳ Placeholder ok | Nein |
| GdUnit4 (Tests) | ✅ M04 installiert | Nein |

---

## Verbindliche Tech-Entscheidungen

| Bereich | Wahl |
|---------|------|
| Engine | Godot 4.x (4.3+ empfohlen) |
| Sprache | GDScript |
| Render | Godot 2D (Forward+) |
| Physik | Godot Physics — RigidBody2D |
| DI / Services | Autoload-Singletons |
| UI | Control Nodes (CanvasLayer) |
| Config | Custom Resources (`.tres`) |
| Assets (MVP) | Direkte `res://`-Referenzen in Scenes |
| Async | `await` / Coroutines (built-in) |
| Save | JSON in `user://` |
| Events | Signals + EventBus-Autoload |
| Lokalisierung | TranslationServer + CSV |
| Tests | GdUnit4 |

---

## Was du lokal brauchst (einmalig)

### 1. Godot 4

- [Godot Engine 4.x](https://godotengine.org/download) herunterladen
- **Standard-Build** reicht (kein .NET nötig für GDScript)
- Alternativ: `winget install GodotEngine.GodotEngine` (Windows)

### 2. Android Export

Im Godot-Editor einmalig:

1. **Editor → Manage Export Templates** → Templates für Godot-Version installieren
2. **Editor → Export → Android** → Export-Templates herunterladen
3. **JDK 17** + **Android SDK** konfigurieren (Editor leitet durch)
4. Min SDK: API 26 · Target SDK: API 35 (PRD §16)

### 3. IDE

- **Godot Editor** — Scenes, Inspector, Debugger
- **Cursor / VS Code** — GDScript mit [godot-tools](https://marketplace.visualstudio.com/items?itemName=geequlim.godot-tools) Extension
- Beides parallel: Editor für visuelles Setup, Cursor für Code

### 4. GdUnit4 (Unit Tests)

Das Projekt nutzt **Godot 4.7** — dafür braucht es **GdUnit4 v6.2** (master), nicht v6.1.x (nur bis Godot 4.6).

**Installation:** Das Addon liegt bereits unter `addons/gdUnit4/` (committed). Nach einem frischen Clone einmal den Godot-Editor öffnen, damit der Plugin-Cache neu aufgebaut wird. Das Plugin ist in `project.godot` unter `[editor_plugins]` aktiviert.

**Tests im Editor ausführen:**

1. Godot-Editor öffnen → Projekt importieren
2. Unten den **GdUnit**-Tab öffnen
3. `tests/unit/test_dummy.gd` auswählen → **Run**

**Tests headless (CLI / CI):**

```powershell
Godot --headless --path . -s addons/gdUnit4/bin/GdUnitCmdTool.gd -a tests/unit
```

Godot 4.7 finden (Windows):

```powershell
winget install GodotEngine.GodotEngine   # falls noch nicht installiert
where.exe godot                          # wenn im PATH
```

Falls `where godot` nichts liefert: Godot-Executable aus dem WinGet-Paketordner oder von [godotengine.org/download](https://godotengine.org/download) verwenden.

Neue Tests gehören nach `tests/unit/` und erweitern `GdUnitTestSuite`. Testdateien mit `# GdUnit4Suite` markieren.

---

## Was beim Projekt-Setup passiert (Schritt 1 Implementierung)

1. **Godot-Projekt anlegen** in diesem Repo-Root
2. **Template:** 2D Core
3. **`project.godot` konfigurieren:**
   - Display → Portrait, Stretch Mode `canvas_items`
   - Physics → 2D → FPS: **60**
   - Rendering → Renderer: **Mobile** (Budget-Geräte)
   - Autoloads registrieren (siehe TDD §17)
4. **Ordnerstruktur** anlegen (TDD §20):

   ```
   scenes/
   scripts/
   resources/       # FruitDefinition.tres, Configs
   assets/
   autoload/
   tests/
   ```

5. **Export Preset:** Android AAB, Package Name festlegen

---

## Was schon erledigt ist

- [x] PRD auf Godot 4 umgestellt
- [x] TDD für Godot 4 neu geschrieben
- [x] `.gitignore` für Godot
- [x] Repo-Dokumentation (`docs/`)
- [x] GdUnit4 Test-Framework (`addons/gdUnit4/`, `tests/unit/`)

---

## Optional vor Vertical Slice (nicht blockierend)

| Dokument | Nutzen | Priorität |
|----------|--------|-----------|
| GDD | Feintuning Balancing, Juice-Timing | Mittel — parallel möglich |
| Production Plan | Sprint-Meilensteine | Niedrig — nach Vertical Slice |
| Firebase-Projekt | Analytics MVP | Niedrig — Ende MVP |
| Store Listing | Play Console | Später |

---

## Implementierungs-Reihenfolge (nach Godot-Setup)

```
1. Godot-Projekt + Ordnerstruktur + Autoloads
2. Core: GameBootstrap, EventBus, StateMachine
3. Resources: FruitDefinition, SpawnConfig, ScoreConfig
4. Vertical Slice: Drop → Physik → Merge (Tier 1→2) → Score
5. Danger Zone + Game Over
6. Alle 11 Tiers + Katalog
7. UI: Menu, HUD, Pause, Game Over
8. Save, Audio, Juice, Localization
9. Android Export + Performance-Test (Galaxy A54 Ziel)
```

---

## Nächster Schritt

**Godot 4.7 installieren** → Projekt im Repo-Root importieren (siehe [README](../README.md)) → GdUnit-Tests mit `GdUnitCmdTool` verifizieren → weiter mit **M05 Container & Physik** (nach M03-Merge).

Godot-Projektdateien sind reine Textdateien (`.gd`, `.tscn`, `.tres`) — ideal für Git und Cursor.
