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

GdUnit4 v6.2 blockiert `--headless` standardmäßig. Vor dem ersten Lauf einmal importieren, dann Tests mit `--ignoreHeadlessMode` starten:

```powershell
# Einmalig: Projekt importieren (baut Class-Cache für GdUnit4)
Godot --headless --path . --import

# Unit-Tests ausführen
Godot --headless --path . -s addons/gdUnit4/bin/GdUnitCmdTool.gd -a tests/unit --ignoreHeadlessMode
```

Alternativ ohne `--headless` (wie `addons/gdUnit4/runtest.cmd`):

```powershell
Godot --path . -s addons/gdUnit4/bin/GdUnitCmdTool.gd -a tests/unit
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

---

## M03 — Custom Resources & Config

Editierbare Spielkonfiguration als Godot Custom Resources (`.tres`). Werte sind im Inspector anpassbar; Runtime lädt per `preload()` oder `load()`.

### Resource-Skripte (`scripts/resources/`)

| Klasse | Datei | Zweck |
|--------|-------|-------|
| `FruitDefinition` | `fruit_definition.gd` | Tier, Name, Radius, Masse, Reibung, Sprite, SFX/Juice-Stubs |
| `FruitDatabase` | `fruit_database.gd` | Array aller Definitionen; `get_by_tier()`, `get_max_tier()` |
| `SpawnConfig` | `spawn_config.gd` | Spawn-Gewichte Tier 1–5; `get_weight()`, `get_total_weight()` |
| `ScoreConfig` | `score_config.gd` | Punkte pro Merge (PRD §8.1); `get_score_for_merge(source_tier)` |
| `PhysicsConfig` | `physics_config.gd` | Schwerkraft, Reibung, Boden-Bounce, Body-Limit, Sleep (PRD §10.2) |

### `.tres`-Dateien (`resources/`)

| Pfad | Inhalt |
|------|--------|
| `resources/fruits/fruit_01_cherry.tres` | Tier 1 — Kirsche (radius 18, mass 1.0) |
| `resources/fruits/fruit_02_strawberry.tres` | Tier 2 — Erdbeere (radius 26, mass 1.4) |
| `resources/fruit_database.tres` | Verweist auf Tier 1–2 Definitionen |
| `resources/spawn_config.tres` | Gewichte: 35 / 28 / 20 / 12 / 5 (PRD §5.5) |
| `resources/score_config.tres` | Merge-Punkte: 10, 25, 50, 100, 200, 400, 800, 1600, 3200, 7500 |
| `resources/physics_config.tres` | gravity 980, friction 0.4, bounce_floor 0.3, max_bodies 40 |

### Spawn-Gewichte (PRD §5.5)

| Tier | Gewicht |
|------|---------|
| 1 | 35 |
| 2 | 28 |
| 3 | 20 |
| 4 | 12 |
| 5 | 5 |

`get_total_weight()` = 100.

### Score-Tabelle (PRD §8.1)

| Merge | Punkte |
|-------|--------|
| 1→2 | 10 |
| 2→3 | 25 |
| 3→4 | 50 |
| 4→5 | 100 |
| 5→6 | 200 |
| 6→7 | 400 |
| 7→8 | 800 |
| 8→9 | 1600 |
| 9→10 | 3200 |
| 10→11 | 7500 |

`get_score_for_merge(source_tier)` liefert die Punkte für `source_tier → source_tier + 1`.

### Physics-Defaults (PRD §10.2)

| Feld | Wert |
|------|------|
| `gravity` | 980 |
| `friction` | 0.4 |
| `bounce_floor` | 0.3 |
| `max_bodies` | 40 |
| `sleep_threshold` | 0.1 |
| `physics_ticks_per_second` | 60 (Referenz; Anwendung ab M05) |

### Smoke-Test (Boot)

`scenes/boot/boot.gd` preloaded und assertiert:

- `FruitDatabase.get_by_tier(1).tier == 1`
- `SpawnConfig.get_weight(1) == 35`
- `ScoreConfig.get_score_for_merge(1) == 10`
- `PhysicsConfig.bounce_floor == 0.3`

Headless-Verifikation:

```powershell
Godot --headless --path . --quit-after 1
```
