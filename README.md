# Frucht Kombinierer

Casual Physics Merge-Spiel für Android — inspiriert von Fruit Merge / Suika, eigenständiges Setting und Balancing.

## Tech Stack

Godot **4.3+** (getestet mit 4.7) · GDScript · Android · RigidBody2D

## Projekt starten

1. [Godot 4.3+](https://godotengine.org/download) installieren (z. B. `winget install GodotEngine.GodotEngine`)
2. Godot Editor öffnen → **Import** → Repo-Root `Frucht Kombinierer` wählen
3. **F5** drücken — `boot.tscn` startet im Portrait-Modus (720×1280)

Erwartung: Fenster mit Titel „Frucht Kombinierer“, keine Errors im Output-Panel.

## Projektstruktur

```
scenes/       # Godot-Szenen (boot, game, fruits, ui)
scripts/      # GDScript (autoload, core, gameplay, …)
resources/    # Custom Resources (.tres)
assets/       # Sprites, Audio, Fonts
tests/unit/   # GdUnit4-Tests (ab M04)
tooling/      # GitHub Milestone/Issue-Skripte
docs/         # PRD, TDD, Milestones
```

## Dokumentation

Siehe [`docs/`](./docs/README.md):

- [PRD](./docs/PRD.md) — Product Requirements (Approved)
- [TDD](./docs/TDD.md) — Softwarearchitektur Godot 4 (Approved)
- [SETUP](./docs/SETUP.md) — Implementierungs-Readiness
- [MILESTONES](./docs/MILESTONES.md) — 36 Tages-Milestones (MVP)
