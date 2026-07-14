#!/usr/bin/env python3
"""Create or update GitHub issues M01-M36 with standard template body."""

import json
import subprocess
import sys
import tempfile
from pathlib import Path

REPO = "tommy040797/Frucht-Kombinierer"
BASE = Path(__file__).resolve().parent.parent

ISSUES = [
    {
        "num": "M01", "title": "Godot-Projekt-Scaffold", "phase": "Foundation",
        "beschreibung": "Godot-4-Projekt im Repo anlegen: project.godot, Ordnerstruktur laut TDD §20, Portrait 9:16, Physics 60 Hz, Mobile Renderer, leere boot.tscn als Main Scene.",
        "ziel": "Fundament für alle weiteren Milestones. Ohne lauffähiges Projekt kann kein Code geschrieben werden.",
        "tech": ["Godot 4.x 2D Core Template", "Ordner: scenes/, scripts/, resources/, assets/, tests/", "Display: Portrait, stretch canvas_items", "physics_ticks_per_second = 60", "Renderer: Mobile"],
        "akzeptanz": ["Projekt öffnet fehlerfrei im Godot Editor", "Portrait 9:16, Physics 60 Hz aktiv", "Ordnerstruktur laut TDD §20 vorhanden", "Main Scene boot.tscn gesetzt"],
        "tests": "Projekt startet ohne Errors im Output-Panel",
        "benoetigt": ["Godot 4.x installiert (SETUP.md)"],
        "blockiert": ["M02 Autoloads Core", "M03 Custom Resources", "M04 Test-Framework", "M05 Container"],
        "perf": False, "docs": True,
    },
    {
        "num": "M02", "title": "Autoloads Core", "phase": "Foundation",
        "beschreibung": "Globale Services als Autoloads: EventBus (emit/subscribe), FeatureFlags (MVP-Defaults), SaveService (Stub).",
        "ziel": "Zentrale Entkopplung aller Systeme — Basis für State Machine, Save, Audio und Events laut TDD §7.",
        "tech": ["scripts/autoload/event_bus.gd", "scripts/autoload/feature_flags.gd", "scripts/autoload/save_service.gd (Stub)", "Registrierung in project.godot"],
        "akzeptanz": ["Autoloads in Project Settings sichtbar", "EventBus.emit/subscribe funktioniert", "FeatureFlags.is_enabled() liefert MVP-Defaults"],
        "tests": "Manuell: Test-Script subscribed auf Event, emit löst Callback aus",
        "benoetigt": ["M01 Godot-Projekt-Scaffold"],
        "blockiert": ["M16 Game State Machine", "M26 Save und Highscore", "M29 Audio SFX"],
        "perf": False, "docs": False,
    },
    {
        "num": "M03", "title": "Custom Resources und Config", "phase": "Foundation",
        "beschreibung": "Custom Resources: FruitDefinition, FruitDatabase, SpawnConfig, ScoreConfig, PhysicsConfig als .tres mit PRD-Werten.",
        "ziel": "Data-driven Balancing — Designer können Werte im Editor ändern ohne Code-Recompile (TDD §1).",
        "tech": ["class_name FruitDefinition extends Resource", "Spawn-Gewichte 35/28/20/12/5 %", "Score-Tabelle PRD §8.1", "PhysicsConfig: friction 0.4, bounce 0.3"],
        "akzeptanz": ["Tier 1–2 als Resources vorhanden", "Spawn-Gewichte korrekt", "Score-Werte PRD §8.1", "Werte im Inspector editierbar"],
        "tests": "Resources laden per preload() ohne Fehler",
        "benoetigt": ["M01 Godot-Projekt-Scaffold"],
        "blockiert": ["M05 Container", "M06 FruitBody", "M09 ScoreService", "M11 SpawnService"],
        "perf": False, "docs": True,
    },
    {
        "num": "M04", "title": "Test-Framework-Setup", "phase": "Foundation",
        "beschreibung": "GdUnit4 als Addon installieren; tests/unit/ mit Dummy-Test anlegen.",
        "ziel": "Automatisierte Tests für Merge, Score und Spawn ab M08 — Qualitätssicherung von Anfang an.",
        "tech": ["GdUnit4 Addon", "tests/unit/test_dummy.gd", "Godot Test-Runner konfiguriert"],
        "akzeptanz": ["tests/unit/ vorhanden", "Dummy-Test läuft grün", "Test-Runner startet ohne Fehler"],
        "tests": "test_dummy.gd: assert_that(true).is_true()",
        "benoetigt": ["M01 Godot-Projekt-Scaffold"],
        "blockiert": ["Alle Unit-Test-Milestones ab M06"],
        "perf": False, "docs": True,
    },
    {
        "num": "M05", "title": "Container und Physik-Grenzen", "phase": "Foundation",
        "beschreibung": "Obstkorb-Szene: StaticBody2D-Wände, Boden (bounce 0.3), Danger-Line als Area2D bei ~85 % Höhe.",
        "ziel": "Spielfeld gemäß PRD §5.1 — Container mit physikalisch korrekten Grenzen für Drop und Danger Zone.",
        "tech": ["scenes/game/container.tscn", "StaticBody2D + CollisionPolygon2D", "Area2D DangerLine", "PhysicsConfig angewendet"],
        "akzeptanz": ["Container sichtbar (Placeholder ok)", "Boden bounce ~0.3", "Wände reflektierend", "Danger-Line bei ~85 % Höhe"],
        "tests": "RigidBody2D fällt in Container, prallt an Wänden",
        "benoetigt": ["M01 Godot-Projekt-Scaffold", "M03 Custom Resources"],
        "blockiert": ["M06 FruitBody", "M07 Input und Drop", "M14 Danger Zone"],
        "perf": False, "docs": False,
    },
    {
        "num": "M06", "title": "FruitBody und Object Pool", "phase": "Vertical Slice",
        "beschreibung": "FruitBody (RigidBody2D) mit Tier-Daten aus FruitDefinition; FruitPool mit acquire/release.",
        "ziel": "Performante Frucht-Instanzen ohne GC-Spikes — Pooling für max. 40 Bodies (PRD §10.2).",
        "tech": ["scenes/fruits/fruit_body.tscn", "contact_monitor=true, continuous_cd=2", "scripts/physics/fruit_pool.gd", "release() statt queue_free()"],
        "akzeptanz": ["Pool liefert Tier-1-Frucht", "contact_monitor aktiv", "continuous_cd gesetzt", "Release gibt Body zurück"],
        "tests": "Unit: Pool acquire 5x, release 5x, Size stabil",
        "benoetigt": ["M03 Custom Resources", "M05 Container"],
        "blockiert": ["M07 Input", "M08 MergeService", "M14 Danger Zone"],
        "perf": True, "docs": False,
    },
    {
        "num": "M07", "title": "Input und Drop-Preview", "phase": "Vertical Slice",
        "beschreibung": "Touch-Drag horizontal, Ghost-Silhouette, Drop bei Release über Container-Oberkante.",
        "ziel": "Kernsteuerung PRD §6 — Ein-Daumen-spielbar mit visueller Drop-Vorschau.",
        "tech": ["scripts/input/input_handler.gd", "scripts/input/drop_preview.gd", "scripts/gameplay/drop_controller.gd", "Screen-zu-World Koordinaten-Mapping"],
        "akzeptanz": ["Drag bewegt Preview entlang Oberkante", "Ghost zeigt Landeposition", "Release spawnt Frucht"],
        "tests": "Manuell: 10 Drops links/rechts/mitte landen korrekt",
        "benoetigt": ["M05 Container", "M06 FruitBody"],
        "blockiert": ["M09 Score Integration", "M10 Vertical Slice", "M11 SpawnService"],
        "perf": False, "docs": False,
    },
    {
        "num": "M08", "title": "MergeService Tier 1 zu 2", "phase": "Vertical Slice",
        "beschreibung": "Gleich-Tier-Kollision → Merge zur nächsten Stufe am Kontaktpunkt. is_merging-Lock, EventBus-Events.",
        "ziel": "Kernmechanik PRD §5.4 — ohne Merge kein Spiel.",
        "tech": ["scripts/gameplay/merge_service.gd", "scripts/physics/fruit_collision_handler.gd", "Merge-Queue pro Physics-Tick", "Events: merge_started, merge_completed"],
        "akzeptanz": ["Kirsche + Kirsche = Erdbeere", "is_merging verhindert Doppel-Merge", "merge_started/completed Events feuern"],
        "tests": "Unit: can_merge(same,same)=true; can_merge(diff)=false; try_merge erzeugt tier+1",
        "benoetigt": ["M06 FruitBody"],
        "blockiert": ["M09 ScoreService", "M10 Vertical Slice", "M12 Merge-Kette", "M29 Audio", "M31 Juice"],
        "perf": False, "docs": False,
    },
    {
        "num": "M09", "title": "ScoreService Basis", "phase": "Vertical Slice",
        "beschreibung": "Punkte bei Merge gemäß ScoreConfig; current_score; Event mit Score + Position.",
        "ziel": "Scoring PRD §8.1 — Spieler-Feedback und Highscore-Grundlage.",
        "tech": ["scripts/gameplay/score_service.gd", "ScoreConfig.tres Werte", "EventBus: score_updated"],
        "akzeptanz": ["Merge 1→2 = 10 Punkte", "current_score steigt", "Event enthält Score + Position"],
        "tests": "Unit: add_merge_score(1) → +10; add_merge_score(5) → +100",
        "benoetigt": ["M03 Custom Resources", "M08 MergeService"],
        "blockiert": ["M10 Vertical Slice", "M13 Combo", "M17 RunSession", "M20 Game HUD"],
        "perf": False, "docs": False,
    },
    {
        "num": "M10", "title": "Vertical Slice Integration", "phase": "Vertical Slice",
        "beschreibung": "End-to-end Kernloop in game.tscn: Drop → Physik → Merge 1→2 → Score.",
        "ziel": "Erster spielbarer Proof-of-Concept — validiert Architektur und Physik-Stack.",
        "tech": ["scenes/game/game.tscn", "Integration Drop+Merge+Score", "Debug-Overlay optional"],
        "akzeptanz": ["5 Min. spielbar ohne Crash", "Drop, Kollision, Merge, Score end-to-end", "Mind. 1 Merge in 20 Drops erreichbar"],
        "tests": "Playtest: 20 Drops, mind. 1 Merge, Score > 0",
        "benoetigt": ["M07 Input", "M08 MergeService", "M09 ScoreService"],
        "blockiert": ["M11 SpawnService", "M18 Game Bootstrap"],
        "perf": True, "docs": False,
    },
    {
        "num": "M11", "title": "SpawnService RNG", "phase": "Vertical Slice",
        "beschreibung": "Gewichtetes RNG für Tier 1–5 (35/28/20/12/5 %); Single-Preview; Integration in DropController.",
        "ziel": "Spawn-Queue PRD §5.5 — zufällige aber faire Frucht-Vorschau.",
        "tech": ["scripts/gameplay/spawn_service.gd", "SpawnConfig.tres", "roll_next() nach Drop"],
        "akzeptanz": ["Nur Tier 1–5", "1000 Rolls ±5 % um Zielgewichte", "current_fruit für Drop verfügbar"],
        "tests": "Unit: 10.000 Rolls, Verteilung innerhalb Toleranz",
        "benoetigt": ["M03 Custom Resources", "M07 Input"],
        "blockiert": ["M12 Merge-Kette 11 Tiers"],
        "perf": False, "docs": False,
    },
    {
        "num": "M12", "title": "Merge-Kette 11 Tiers", "phase": "Vertical Slice",
        "beschreibung": "Alle 11 FruitDefinitions; Merge bis Goldene Frucht; Kettenreaktionen (Chain-Queue max. 10/Tick).",
        "ziel": "Vollständige Frucht-Hierarchie PRD §5.2 — Spielkern komplett.",
        "tech": ["11x FruitDefinition.tres", "Placeholder-Sprites assets/fruits/", "Chain-Queue in MergeService", "Mass/Radius aus Config"],
        "akzeptanz": ["Jeder Tier-Übergang funktioniert", "Gold (Tier 11) erzeugbar", "Chain-Queue max. 10/Tick"],
        "tests": "Unit: Merge 10→11 erzeugt Gold; Chain von 3 Merges in einem Tick",
        "benoetigt": ["M08 MergeService", "M11 SpawnService"],
        "blockiert": ["M13 Combo", "M17 RunSession", "M25 Placeholder Art", "M27 Katalog"],
        "perf": False, "docs": False,
    },
    {
        "num": "M13", "title": "Combo-System", "phase": "Core Gameplay",
        "beschreibung": "ComboTracker: 1,5 s Fenster, +10 % Multiplikator pro Merge, max ×2,0; Combo-Break-Event.",
        "ziel": "Scoring-Tiefe PRD §8.2 — Belohnung für schnelle Ketten.",
        "tech": ["scripts/gameplay/combo_tracker.gd", "ScoreService nutzt Multiplikator", "Events: combo_increased, combo_broken"],
        "akzeptanz": ["2 Merges < 1,5 s → ×1,1", "Cap ×2,0", "Combo-Break-Event bei Timeout"],
        "tests": "Unit: 2 Merges in 1 s → 1.1; Merge nach 2 s → reset",
        "benoetigt": ["M09 ScoreService", "M12 Merge-Kette"],
        "blockiert": ["M20 Game HUD"],
        "perf": False, "docs": False,
    },
    {
        "num": "M14", "title": "Danger Zone", "phase": "Core Gameplay",
        "beschreibung": "DangerZoneService: Frucht > 2,0 s über Warnlinie → game_over_triggered; Danger-Progress 0–1.",
        "ziel": "Niederlage-Bedingung PRD §5.7 — fairer 2-Sekunden-Puffer.",
        "tech": ["scripts/gameplay/danger_zone_service.gd", "Nur settled bodies zählen", "Danger-Line Puls (Basis)"],
        "akzeptanz": ["< 2 s Überschreitung: kein Game Over", "> 2 s kontinuierlich: Event", "Danger-Progress 0–1", "Exit resettet Timer"],
        "tests": "Unit: Timer 1,9 s → kein GO; 2,1 s → GO",
        "benoetigt": ["M05 Container", "M06 FruitBody"],
        "blockiert": ["M15 Game-Over-Logik"],
        "perf": False, "docs": False,
    },
    {
        "num": "M15", "title": "Game-Over-Logik", "phase": "Core Gameplay",
        "beschreibung": "Run-Ende: Physik stoppen, RunStats sammeln, run_ended Event an UI.",
        "ziel": "Sauberer Run-Abschluss PRD §7.3 — Daten für Game-Over-Screen und Save.",
        "tech": ["Physik freeze bei Game Over", "RunStats: Score, HighestTier, Merges, Duration", "EventBus: run_ended"],
        "akzeptanz": ["Physik eingefroren bei Game Over", "RunStats vollständig", "run_ended Event feuert"],
        "tests": "Manuell: Game Over mit 5 aktiven Früchten → kein Crash",
        "benoetigt": ["M14 Danger Zone", "M17 RunSession"],
        "blockiert": ["M22 Game Over Screen", "M26 Save und Highscore"],
        "perf": False, "docs": False,
    },
    {
        "num": "M16", "title": "Game State Machine", "phase": "Core Gameplay",
        "beschreibung": "States: Boot, Splash, MainMenu, Playing, Paused, GameOver; valide Transitions; Physik-Toggle.",
        "ziel": "Spiel-Flow PRD §11.1 — kontrollierte Zustandswechsel statt Scene-Chaos.",
        "tech": ["scripts/core/game_state_machine.gd (Autoload)", "6 State-Klassen", "Transition-Tabelle", "Event: game_state_changed"],
        "akzeptanz": ["Ungültige Transitions blockiert", "Playing/Paused toggelt Physik", "game_state_changed Event"],
        "tests": "Unit: Playing→Paused ok; Boot→GameOver rejected",
        "benoetigt": ["M02 Autoloads Core"],
        "blockiert": ["M18 Bootstrap", "M19 Main Menu", "M21 Pause", "M23 Splash", "M30 Musik"],
        "perf": False, "docs": False,
    },
    {
        "num": "M17", "title": "RunSession", "phase": "Core Gameplay",
        "beschreibung": "Laufzeit-Tracking: Score, HighestTier, MergeCount, Duration, RunId; start()/end().",
        "ziel": "Single Source of Truth für Run-Daten — Analytics, UI und Save.",
        "tech": ["scripts/gameplay/run_session.gd", "An Events angebunden", "start() resettet alle Werte"],
        "akzeptanz": ["start() resettet", "end() liefert Stats", "HighestTier bei Merge aktualisiert"],
        "tests": "Unit: 3 Merges → merge_count=3; highest_tier korrekt",
        "benoetigt": ["M09 ScoreService", "M12 Merge-Kette"],
        "blockiert": ["M15 Game-Over", "M18 Bootstrap", "M22 Game Over UI", "M35 Analytics"],
        "perf": False, "docs": False,
    },
    {
        "num": "M18", "title": "Game Bootstrap", "phase": "Core Gameplay",
        "beschreibung": "GameBootstrap orchestriert Services; Playing-State startet frischen Run.",
        "ziel": "Saubere Initialisierung — kein State-Leak zwischen Runs.",
        "tech": ["scripts/core/game_bootstrap.gd", "Explizite _ready-Reihenfolge", "Service-Reset bei Run-Start"],
        "akzeptanz": ["Spielen startet frischen Run", "Alle Services resetted", "game.tscn lädt korrekt"],
        "tests": "Manuell: 3 aufeinanderfolgende Runs ohne State-Leak",
        "benoetigt": ["M16 State Machine", "M17 RunSession", "M10 Vertical Slice"],
        "blockiert": ["M19 Main Menu", "M20 Game HUD", "M33 Android Export"],
        "perf": False, "docs": False,
    },
    {
        "num": "M19", "title": "Main Menu", "phase": "UI",
        "beschreibung": "main_menu.tscn: Logo, Spielen, Katalog, Einstellungen, Highscore-Anzeige.",
        "ziel": "Einstiegspunkt PRD §11.2 — Time-to-Fun < 15 s.",
        "tech": ["scenes/ui/main_menu.tscn", "Spielen → Playing State", "Highscore aus SaveService (Mock bis M26 ok)"],
        "akzeptanz": ["PRD §11.2 Layout", "Spielen → Playing", "Highscore sichtbar (0 wenn leer)", "Buttons reagieren"],
        "tests": "Manuell: alle Buttons; Safe Area auf 720x1280",
        "benoetigt": ["M16 State Machine", "M26 Save (Mock ok)"],
        "blockiert": ["M23 Splash", "M24 UI Theme", "M32 Lokalisierung"],
        "perf": False, "docs": False,
    },
    {
        "num": "M20", "title": "Game HUD", "phase": "UI",
        "beschreibung": "game_hud.tscn: Score, Rekord-Ghost, Pause-Button (44x44 dp), Combo-Meter.",
        "ziel": "Ingame-Info PRD §11.3 — Score und Combo immer sichtbar.",
        "tech": ["scenes/ui/game_hud.tscn", "EventBus Subscriptions", "mouse_filter=IGNORE auf Hintergrund"],
        "akzeptanz": ["Score live", "Combo bei > x1.0", "Pause-Button >= 44x44 dp", "HUD blockiert Touch nicht"],
        "tests": "Manuell: Score steigt; Combo-Meter reagiert",
        "benoetigt": ["M09 ScoreService", "M13 Combo", "M18 Bootstrap"],
        "blockiert": ["M21 Pause", "M24 UI Theme"],
        "perf": False, "docs": False,
    },
    {
        "num": "M21", "title": "Pause und Android Back", "phase": "UI",
        "beschreibung": "pause_overlay.tscn: Resume/Menu; NOTIFICATION_WM_GO_BACK_REQUEST; Physik-Freeze.",
        "ziel": "Pausieren PRD §6.1 + Android-konformes Back-Verhalten.",
        "tech": ["scenes/ui/pause_overlay.tscn", "Paused State", "OS.has_feature(mobile) Check"],
        "akzeptanz": ["Pause friert Physik", "Back öffnet Pause", "Resume setzt fort"],
        "tests": "Manuell: Pause 10 s → Resume → Physik weiter",
        "benoetigt": ["M16 State Machine", "M20 Game HUD"],
        "blockiert": ["M24 UI Theme"],
        "perf": False, "docs": False,
    },
    {
        "num": "M22", "title": "Game Over Screen", "phase": "UI",
        "beschreibung": "game_over.tscn: Score, Highest Fruit, Merges, Duration; CTAs Nochmal/Menu; 0,8 s Freeze.",
        "ziel": "Run-Ende PRD §7.3 — klarer Abschluss mit Wiederholungsmotivation.",
        "tech": ["scenes/ui/game_over.tscn", "await für 0,8 s Freeze", "Nochmal → neuer Run"],
        "akzeptanz": ["Stats korrekt", "0,8 s Freeze vor Overlay", "Nochmal → Score 0", "Menu → MainMenu"],
        "tests": "Manuell: Game Over → Stats; Nochmal → neuer Run",
        "benoetigt": ["M15 Game-Over-Logik", "M17 RunSession"],
        "blockiert": ["M24 UI Theme", "M26 Save"],
        "perf": False, "docs": False,
    },
    {
        "num": "M23", "title": "Splash und Boot Flow", "phase": "UI",
        "beschreibung": "boot.tscn + splash.tscn: Asset-Preload, min. Splash-Anzeige, Übergang MainMenu.",
        "ziel": "Cold Start PRD §15 — < 3 s bis Main Menu.",
        "tech": ["scenes/boot/boot.tscn als Entry Scene", "Preload Tier 1-5, Core-SFX", "BootState → SplashState → MainMenu"],
        "akzeptanz": ["Cold Start < 3 s bis Menu", "Keine Preload-Errors", "Boot ist Entry Scene"],
        "tests": "Manuell: Zeit messen Boot → Menu",
        "benoetigt": ["M16 State Machine", "M19 Main Menu"],
        "blockiert": ["MVP Release Flow"],
        "perf": True, "docs": False,
    },
    {
        "num": "M24", "title": "UI Theme und Safe Area", "phase": "UI",
        "beschreibung": "theme.tres: warme Palette, Nunito-Font, 12 px Radius; SafeAreaMargin für Notch.",
        "ziel": "Visuelles Design System PRD §11.4 — konsistentes Look & Feel.",
        "tech": ["resources/theme.tres", "Nunito OFL Font", "SafeAreaMargin Container", "Alle Screens migriert"],
        "akzeptanz": ["PRD §11.4 Palette", "Alle Screens nutzen Theme", "Safe Area auf Root Canvas"],
        "tests": "Visuell: 720p, 1080p, 1440p",
        "benoetigt": ["M19 Main Menu", "M20 Game HUD", "M21 Pause", "M22 Game Over"],
        "blockiert": ["MVP Polish"],
        "perf": False, "docs": False,
    },
    {
        "num": "M25", "title": "Placeholder-Art Pass", "phase": "UI",
        "beschreibung": "11 unterscheidbare Placeholder-Sprites für Früchte + Container-Grafik.",
        "ziel": "Visuelle Unterscheidbarkeit aller Tiers — Playtests und Katalog möglich.",
        "tech": ["assets/fruits/ 11 Sprites", "Farbe + Größe pro Tier", "Sprite-Anchor zentriert"],
        "akzeptanz": ["Jede Stufe visuell unterscheidbar", "Silhouette erkennbar", "Container Placeholder"],
        "tests": "Visuell: alle 11 Tiers im Katalog unterscheidbar",
        "benoetigt": ["M12 Merge-Kette"],
        "blockiert": ["MVP Visual Polish"],
        "perf": False, "docs": False,
    },
    {
        "num": "M26", "title": "Save und Highscore", "phase": "Meta und Polish",
        "beschreibung": "SaveService vollständig: JSON nach user://save.json, Atomic Write, Highscore bei Game Over.",
        "ziel": "Persistenz PRD §9.1 — Fortschritt überlebt App-Neustart.",
        "tech": ["user://save.json versioniert", "Atomic write (tmp + rename)", "SaveService Stub ersetzen"],
        "akzeptanz": ["Highscore überlebt Neustart", "Atomic Write", "Schema versioniert", "Nur neuer Highscore wenn höher"],
        "tests": "Unit: save/load roundtrip; Highscore-Logik",
        "benoetigt": ["M02 Autoloads", "M15 Game-Over", "M22 Game Over UI"],
        "blockiert": ["M19 Main Menu (echter Highscore)", "M27 Katalog", "M28 Einstellungen"],
        "perf": False, "docs": True,
    },
    {
        "num": "M27", "title": "Frucht-Katalog", "phase": "Meta und Polish",
        "beschreibung": "catalog.tscn: 11 Einträge, Silhouette bis Entdeckung, Tap-Detail, CatalogRepository.",
        "ziel": "Meta-Progression PRD §9.2 — Sammlungsmotivation.",
        "tech": ["scenes/ui/catalog.tscn", "CatalogRepository", "Event: fruit_discovered", "Persistenz via SaveService"],
        "akzeptanz": ["11 Einträge", "Silhouette bis discovered", "Count inkrementiert", "Tap zeigt Detail"],
        "tests": "Unit: discover(3) → catalog enthält 3; persistiert",
        "benoetigt": ["M12 Merge-Kette", "M26 Save"],
        "blockiert": ["M32 Lokalisierung"],
        "perf": False, "docs": False,
    },
    {
        "num": "M28", "title": "Einstellungen", "phase": "Meta und Polish",
        "beschreibung": "settings.tscn: Master/SFX/Music-Slider, Vibration-Toggle, sofort persistiert.",
        "ziel": "Spieler-Kontrolle PRD §12.3 — Audio und Haptics anpassbar.",
        "tech": ["scenes/ui/settings.tscn", "SaveService Settings-Teil", "AudioService Bus-Volumes live"],
        "akzeptanz": ["PRD §12.3", "Settings überleben Neustart", "Audio reagiert live"],
        "tests": "Manuell: Music auf 0 → stumm; Neustart → Wert erhalten",
        "benoetigt": ["M26 Save", "M29 Audio SFX"],
        "blockiert": ["M32 Lokalisierung"],
        "perf": False, "docs": False,
    },
    {
        "num": "M29", "title": "Audio SFX", "phase": "Meta und Polish",
        "beschreibung": "AudioService + SfxPool: Drop, Merge S/M/L, UI-Tap, Danger-Tick, Game Over.",
        "ziel": "Auditives Feedback PRD §12.1 — befriedigendes Merge-Gefühl.",
        "tech": ["scripts/autoload/audio_service.gd", "SfxPool max 16 Sources", "Placeholder-SFX .ogg", "Bus-Routing SFX/UI"],
        "akzeptanz": ["PRD §12.1 Events abgedeckt", "Pool ohne Lag", "Bus-Routing korrekt"],
        "tests": "Manuell: 10 schnelle Merges → kein Crackle",
        "benoetigt": ["M02 Autoloads", "M08 MergeService"],
        "blockiert": ["M28 Einstellungen", "M30 Musik", "M31 Juice"],
        "perf": False, "docs": False,
    },
    {
        "num": "M30", "title": "Musik", "phase": "Meta und Polish",
        "beschreibung": "Menü-Loop + Ingame-Ambient; Crossfade bei State-Wechsel; Game-Over-Fade 1 s.",
        "ziel": "Atmosphäre PRD §12.2 — entspanntes Spielgefühl.",
        "tech": ["2x Musik-Loops .ogg", "MusicController Crossfade", "Game Over Fade 1 s"],
        "akzeptanz": ["Menu→Playing Crossfade", "Game Over Fade 1 s", "Kein Pop bei Wechsel"],
        "tests": "Manuell: State-Wechsel ohne Audio-Pop",
        "benoetigt": ["M16 State Machine", "M29 Audio SFX"],
        "blockiert": ["MVP Audio Complete"],
        "perf": False, "docs": False,
    },
    {
        "num": "M31", "title": "Juice Basis", "phase": "Meta und Polish",
        "beschreibung": "JuiceController: Partikel Drop/Merge, Screen-Shake, Haptics (8 ms / 25 ms).",
        "ziel": "Juice PRD §14 — befriedigendes sensorisches Feedback.",
        "tech": ["scripts/presentation/juice_controller.gd", "GPUParticles2D max 200", "Camera2D Shake max 4 px", "Input.vibrate_handheld"],
        "akzeptanz": ["PRD §14.1 Drop + Merge S/M", "Max 200 Partikel", "Shake max 4 px", "Haptics Drop 8 ms, Merge 25 ms"],
        "tests": "Manuell: 40 Früchte + Partikel → FPS >= 55",
        "benoetigt": ["M08 MergeService", "M29 Audio SFX"],
        "blockiert": ["M34 Performance-Tuning"],
        "perf": True, "docs": False,
    },
    {
        "num": "M32", "title": "Lokalisierung DE/EN", "phase": "Meta und Polish",
        "beschreibung": "CSV-Translations; alle UI-Strings via tr(); Sprachwahl in Settings.",
        "ziel": "MVP-Lokalisierung PRD §16 — DACH + EN Markt.",
        "tech": ["assets/localization/strings.de.csv", "assets/localization/strings.en.csv", "TranslationServer", "Settings-Sprachwahl"],
        "akzeptanz": ["DE + EN vollständig", "tr() in allen UI-Screens", "Umschaltung funktioniert"],
        "tests": "Manuell: EN→DE alle Screens",
        "benoetigt": ["M19-M22 UI Screens", "M27 Katalog", "M28 Einstellungen"],
        "blockiert": ["M33 Android Export"],
        "perf": False, "docs": True,
    },
    {
        "num": "M33", "title": "Android Export", "phase": "Ship MVP",
        "beschreibung": "Android Export Preset: AAB, Package Name, Min SDK 26, Target SDK 35, Portrait locked.",
        "ziel": "Deploybarer Android-Build PRD §16 — Test auf echten Geräten.",
        "tech": ["export_presets.cfg", "Android AAB Build", "Portrait only", "SETUP.md Build-Anleitung"],
        "akzeptanz": ["AAB baut fehlerfrei", "App startet auf Gerät", "Portrait locked", "5 Min. ohne Crash"],
        "tests": "Install auf Mid-Tier-Gerät; Smoke Test",
        "benoetigt": ["M18 Bootstrap", "Android SDK (SETUP.md)"],
        "blockiert": ["M34 Performance", "M35 Analytics", "M36 Release Candidate"],
        "perf": False, "docs": True,
    },
    {
        "num": "M34", "title": "Performance-Tuning", "phase": "Ship MVP",
        "beschreibung": "60 FPS Ziel Galaxy A54 / Redmi Note 12; Soft Cap 40 Bodies; Profiler-Report.",
        "ziel": "Performance PRD §15 — 60 FPS Ziel, >= 55 FPS Mid-Tier.",
        "tech": ["Godot Profiler 15 Min. Session", "Sleep-Threshold tuning", "CCD nur große Tiers", "docs/performance-report.md"],
        "akzeptanz": [">= 55 FPS Mid-Tier", "Frame-Spikes < 5% über 33 ms", "Soft Cap 40 Bodies aktiv"],
        "tests": "Profiler 15 Min.; FPS-Overlay; Galaxy A54 / Redmi",
        "benoetigt": ["M31 Juice", "M33 Android Export"],
        "blockiert": ["M36 Release Candidate"],
        "perf": True, "docs": True,
    },
    {
        "num": "M35", "title": "Firebase Analytics", "phase": "Ship MVP",
        "beschreibung": "AnalyticsService: session_start, run_end, fruit_discovered; GDPR-konform, keine PII.",
        "ziel": "Retention-Messung PRD §19.2 — D1-Tracking für MVP-Validierung.",
        "tech": ["scripts/infrastructure/analytics_service.gd", "Events: run_end, fruit_discovered", "Firebase DebugView", "Privacy-Hinweis docs/"],
        "akzeptanz": ["Events in DebugView sichtbar", "run_end mit score, duration, highest_tier", "Keine PII"],
        "tests": "DebugView: run_end Event mit korrekten Parametern",
        "benoetigt": ["M17 RunSession", "M33 Android Export"],
        "blockiert": ["M36 Release Candidate"],
        "perf": False, "docs": True,
    },
    {
        "num": "M36", "title": "MVP Release Candidate", "phase": "Ship MVP",
        "beschreibung": "MVP DoD PRD §19.4: 60 FPS A54, Crash-Free 99%, 10 Playtests, Store-Listing-Entwurf, Tag v0.1.0-mvp.",
        "ziel": "Shippable MVP — Closed Testing auf Google Play (50 Tester).",
        "tech": ["Regression Smoke Test", "10 Playtest-Checkliste", "Tag v0.1.0-mvp", "Known Issues dokumentiert"],
        "akzeptanz": ["60 FPS Galaxy A54", "Crash-Free intern >= 99%", "10 Playtests ohne Blocker", "Store-Listing DE/EN Entwurf", "Closed Track bereit"],
        "tests": "10 interne Playtests; Regression; Performance auf Test-Matrix PRD §15",
        "benoetigt": ["M01-M35 alle abgeschlossen"],
        "blockiert": ["Release v1.0 Features"],
        "perf": True, "docs": True,
    },
]


def build_body(issue: dict, issue_refs: dict) -> str:
  def ref_line(dep: str) -> str:
    for title, num in issue_refs.items():
      if dep.startswith(title.split(" - ")[0]) or title.endswith(dep.split(" ", 1)[-1] if " " in dep else dep):
        return f"- #{num} {dep}"
    return f"- {dep}"

  tech = "\n".join(f"- {t}" for t in issue["tech"])
  akzeptanz = "\n".join(f"- [ ] {a}" for a in issue["akzeptanz"])
  benoetigt = "\n".join(ref_line(d) for d in issue["benoetigt"])
  blockiert = "\n".join(f"- {d}" for d in issue["blockiert"])
  perf = "- [ ] Performance geprüft" if issue["perf"] else "- [ ] Performance geprüft *(N/A — kein Performance-Schwerpunkt)*"
  docs = "- [ ] Dokumentation aktualisiert" if issue["docs"] else "- [ ] Dokumentation aktualisiert *(N/A)*"

  return f"""## Beschreibung

{issue["beschreibung"]}

---

## Ziel

{issue["ziel"]}

**Phase:** {issue["phase"]}

---

## Technische Anforderungen

{tech}

---

## Akzeptanzkriterien

{akzeptanz}

- [ ] Feature funktioniert (Definition of Done erfüllt)
- [ ] Tests vorhanden und bestanden ({issue["tests"]})
{docs}
{perf}

---

## Abhängigkeiten

Benötigt:

{benoetigt}

Blockiert:

{blockiert}

---

_Spec: [docs/MILESTONES.md](https://github.com/{REPO}/blob/main/docs/MILESTONES.md) · {issue["num"]}_
"""


def run_gh(args: list[str]) -> subprocess.CompletedProcess:
  return subprocess.run(["gh", *args], capture_output=True, text=True, encoding="utf-8")


def main() -> int:
  result = run_gh(["auth", "status"])
  if result.returncode != 0:
    print("Nicht bei GitHub angemeldet. Bitte: gh auth login", file=sys.stderr)
    return 1

  existing: dict[str, int] = {}
  list_result = run_gh(["issue", "list", "--repo", REPO, "--state", "all", "--limit", "100", "--json", "number,title"])
  if list_result.returncode == 0:
    for item in json.loads(list_result.stdout):
      existing[item["title"]] = item["number"]

  issue_refs: dict[str, int] = dict(existing)
  created = updated = 0

  for issue in ISSUES:
    title = f'{issue["num"]} - {issue["title"]}'
    body = build_body(issue, issue_refs)

    with tempfile.NamedTemporaryFile(mode="w", suffix=".md", delete=False, encoding="utf-8") as f:
      f.write(body)
      body_path = f.name

    try:
      if title in existing:
        num = existing[title]
        r = run_gh(["issue", "edit", str(num), "--repo", REPO, "--title", title, "--body-file", body_path, "--milestone", title])
        if r.returncode == 0:
          print(f"  UPDATE: #{num} {title}")
          updated += 1
        else:
          print(f"  FAIL UPDATE: {title}\n{r.stderr}", file=sys.stderr)
      else:
        r = run_gh(["issue", "create", "--repo", REPO, "--title", title, "--body-file", body_path, "--milestone", title])
        if r.returncode == 0:
          url = r.stdout.strip()
          num = int(url.rsplit("/", 1)[-1])
          existing[title] = num
          issue_refs[title] = num
          print(f"  CREATE: #{num} {title}")
          created += 1
        else:
          print(f"  FAIL CREATE: {title}\n{r.stderr}", file=sys.stderr)
    finally:
      Path(body_path).unlink(missing_ok=True)

  if created > 0 or updated > 0:
    print("\nAktualisiere Abhängigkeits-Links ...")
    for issue in ISSUES:
      title = f'{issue["num"]} - {issue["title"]}'
      if title not in existing:
        continue
      body = build_body(issue, issue_refs)
      with tempfile.NamedTemporaryFile(mode="w", suffix=".md", delete=False, encoding="utf-8") as f:
        f.write(body)
        body_path = f.name
      try:
        run_gh(["issue", "edit", str(existing[title]), "--repo", REPO, "--body-file", body_path])
      finally:
        Path(body_path).unlink(missing_ok=True)

  print(f"\nFertig: {created} erstellt, {updated} aktualisiert.")
  print(f"Issues: https://github.com/{REPO}/issues")
  return 0


if __name__ == "__main__":
  sys.exit(main())
