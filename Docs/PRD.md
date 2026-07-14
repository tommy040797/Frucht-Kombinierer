# Product Requirements Document (PRD)

| | |
|---|---|
| **Projekt** | Frucht Kombinierer |
| **Plattform** | Android (Mobile) |
| **Genre** | Casual Physics Puzzle / Merge |
| **Version** | 1.0 |
| **Status** | Approved — Empfehlungen übernommen |
| **Autor** | Product & Game Design |
| **Datum** | 14. Juli 2026 |

---

## Inhaltsverzeichnis

1. [Dokumentzweck](#1-dokumentzweck)
2. [Vision](#2-vision)
3. [Zielgruppe](#3-zielgruppe)
4. [Gameplay Loop](#4-gameplay-loop)
5. [Kernmechaniken](#5-kernmechaniken)
6. [Steuerung](#6-steuerung)
7. [Sieg- und Niederlagenbedingungen](#7-sieg--und-niederlagenbedingungen)
8. [Scoring](#8-scoring)
9. [Progression](#9-progression)
10. [Balancing](#10-balancing)
11. [UI](#11-ui)
12. [Audio](#12-audio)
13. [Animationen](#13-animationen)
14. [Juice Effects](#14-juice-effects)
15. [Performanceziele](#15-performanceziele)
16. [Android-Anforderungen](#16-android-anforderungen)
17. [Risiken](#17-risiken)
18. [Zukünftige Features](#18-zukünftige-features)
19. [MVP](#19-mvp)
20. [Release Version](#20-release-version)
21. [Produktentscheidungen](#21-produktentscheidungen)
22. [Glossar](#22-glossar)

---

## 1. Dokumentzweck

Dieses PRD definiert die Produkt-, Design- und technischen Anforderungen für **Frucht Kombinierer** — ein hochwertiges Mobile-Spiel, das vom Merge-Physics-Gameplay populärer Titel wie *Fruit Merge* und *Suika Game* inspiriert ist, jedoch als **eigenständiges Produkt** mit originalem Setting, Balancing, Progression und Markenidentität umgesetzt wird.

**Nicht im Scope:** Implementierung, Code, Asset-Produktion, Marketing-Kampagnen.

---

## 2. Vision

### 2.1 Elevator Pitch

> *Wirf Früchte in deinen Obstkorb, kombiniere sie zu immer größeren Leckereien und halte den Korb so lange wie möglich unter Kontrolle — ein entspannendes, aber fesselndes Physik-Puzzle für kurze Sessions und langfristige Highscore-Jagd.*

### 2.2 Produktvision

Frucht Kombinierer wird das **premium Casual Merge-Erlebnis auf Android**: sofort verständlich, physikalisch befriedigend, visuell charaktervoll und für wiederholtes Spielen optimiert. Das Spiel verbindet den „One more try"-Reiz klassischer Merge-Spiele mit einer warmen, einladenden Obst-Identität und einem klaren Qualitätsanspruch in Animation, Feedback und Performance.

### 2.3 Design Pillars

| Pillar | Beschreibung |
|--------|--------------|
| **Sofort spielbar** | Kein Tutorial-Zwang; Kernloop in unter 10 Sekunden verstanden |
| **Befriedigend** | Jede Fusion fühlt sich wertvoll an — visuell, auditiv, haptisch |
| **Fair & transparent** | Spieler verstehen, warum sie verlieren und wie sie sich verbessern |
| **Hochwertig** | 60 FPS, polierte Juice-Effekte, keine Billig-Casual-Ästhetik |
| **Eigenständig** | Eigene Frucht-Hierarchie, Art Direction, Progression und Markenwelt |

### 2.4 Erfolgskriterien

| Metrik | Ziel |
|--------|------|
| D1 Retention | ≥ 35 % |
| D7 Retention | ≥ 12 % |
| Session-Länge (Median) | 4–8 Minuten |
| Sessions pro DAU | ≥ 2,5 |
| Store-Rating | ≥ 4,3 ★ (nach 500+ Reviews) |
| Crash-Free Sessions | ≥ 99,5 % |

---

## 3. Zielgruppe

### 3.1 Primäre Zielgruppe

- **Alter:** 18–45
- **Plattform:** Android-Smartphone-Nutzer (Mid- bis High-Tier-Geräte)
- **Spielverhalten:** Casual-Gamer, Pendler, kurze Pausen-Spieler
- **Motivation:** Entspannung, Highscore, Flow, kein Zeitdruck
- **Region (Launch):** DACH + EU (UI/Audio DE-first, EN als Sekundärsprache)

### 3.2 Sekundäre Zielgruppe

- Jüngere Spieler (13–17) über familienfreundliches Setting
- Merge-Genre-Fans, die Alternativen zu bestehenden Titeln suchen
- Puzzle-Spieler ohne Hardcore-Anspruch

### 3.3 Spieler-Personas

**Persona A — „Die Pendlerin" (Lisa, 29)**  
Spielt 5–10 Minuten morgens/abends im Zug. Will schnellen Einstieg, keinen Grind, klare Fortschrittsanzeige.

**Persona B — „Der Highscore-Jäger" (Marco, 34)**  
Optimiert Drops, studiert Physik, teilt Screenshots. Braucht präzise Steuerung und faires Scoring.

**Persona C — „Der Gelegenheitsspieler" (Helga, 52)**  
Entdeckt das Spiel über Empfehlung. Braucht große Touch-Targets, lesbare UI, beruhigendes Tempo.

### 3.4 Nicht-Zielgruppe

- Hardcore-Competitive-Gamer mit komplexen Meta-Systemen
- Spieler, die narrative RPG- oder Live-Service-Tiefe erwarten

---

## 4. Gameplay Loop

### 4.1 Core Loop (Mikro)

```
Vorschau-Frucht ansehen → Position wählen → Loslassen (Drop)
    → Physik & Kollision → Gleiche Früchte berühren sich → Fusion
    → Größere Frucht entsteht → Punkte & Feedback → Nächste Vorschau
    → [wiederholen bis Game Over]
```

### 4.2 Session Loop (Makro)

```
App starten → Hauptmenü → Spiel starten (Classic)
    → Spielen bis Niederlage → Ergebnisbildschirm (Score, Rekord, Stats)
    → [Neustart | Menü | optional: Daily Challenge]
```

### 4.3 Langfrist-Loop (Retention)

```
Tägliche Session → Persönlicher Rekord / Daily Best
    → Sammlung größerer Früchte freischalten (Katalog)
    → Kosmetische Belohnungen (Release+)
    → Rückkehr durch „Noch ein Versuch"-Motivation
```

### 4.4 Session-Design-Ziele

| Metrik | Ziel |
|--------|------|
| Time-to-Fun | < 15 Sekunden ab App-Start |
| Erste Fusion | < 30 Sekunden |
| Erste Niederlage (Neuling) | 3–6 Minuten |
| „Aha-Moment" (große Frucht) | innerhalb der ersten 2 Sessions |

---

## 5. Kernmechaniken

### 5.1 Spielfeld

- **Container:** Vertikaler Obstkorb / Holzkiste mit abgerundeten Innenwänden
- **Abmessungen:** Responsive; Seitenverhältnis ca. 9:16, Spielfeld nutzt ~70 % der vertikalen Fläche
- **Game-Over-Linie:** Sichtbare Warnlinie bei ~85 % der Containerhöhe
- **Physik:** 2D-Rigidbody-Simulation mit realistischer Reibung, leichtem Bounce, stabilen Kollisionskanten

### 5.2 Frucht-Hierarchie (11 Stufen)

| Stufe | Name | Rolle |
|-------|------|-------|
| 1 | Kirsche | Einstiegsfrucht, häufig in Queue |
| 2 | Erdbeere | Frühe Kombinationen |
| 3 | Traube | Cluster-Verhalten, leicht rollend |
| 4 | Mandarine | Erste „satisfying" Größe |
| 5 | Apfel | Stabiler Mid-Tier-Anker |
| 6 | Birne | Asymmetrische Kollisionsform |
| 7 | Pfirsich | Größere Merge-Belohnung |
| 8 | Melone | Hoher Score-Sprung |
| 9 | Ananas | Seltene Erreichung, Stolz-Moment |
| 10 | Kürbis | Near-Max; extrem selten |
| 11 | **Goldene Frucht** | End-Tier; einmalig pro Run möglich, Spezial-Effekt |

> Eigene Namen, visuelle Silhouetten, Größenverhältnisse und Spawn-Gewichtung — keine 1:1-Kopie bestehender Frucht-Reihen.

### 5.3 Drop-Mechanik

- Spieler sieht **aktuelle** Frucht (MVP) bzw. **aktuelle + nächste** Frucht (Release)
- Horizontale Positionierung per Touch-Drag entlang der Oberkante
- Drop bei Finger loslassen oder explizitem Drop-Button
- Drop-Höhe: fix über dem Container; keine vertikale Steuerung
- **Drop-Cooldown:** 300–500 ms nach Fusion-Animation

### 5.4 Merge-Mechanik

- Zwei Früchte **gleicher Stufe** berühren sich → verschmelzen zur nächsthöheren Stufe
- Fusion am **Kontaktpunkt** (nicht immer geometrischer Mitte)
- Kettenreaktionen (Combo-Merges) innerhalb eines Physik-Ticks möglich
- Fusion während aktiver Drop-Animation: erlaubt
- Keine Cross-Tier-Merges

### 5.5 Spawn-Queue (RNG)

Spieler erhält nur Früchte der **Stufen 1–5** (Kirsche bis Apfel):

| Stufe | Spawn-Wahrscheinlichkeit |
|-------|--------------------------|
| 1 | 35 % |
| 2 | 28 % |
| 3 | 20 % |
| 4 | 12 % |
| 5 | 5 % |

**Pity-System (Release):** Nach 8 Drops ohne Stufe ≤ 2 garantiert Stufe 1 oder 2.

### 5.6 Container-Grenzen

- Wände: voll reflektierend
- Boden: leicht gedämpfter Bounce (0,2–0,35 Restitution)
- Früchte dürfen rollen (Skill & Chaos)

### 5.7 Game-Over-Mechanik (Danger Zone)

- Überschreitet **irgendein** Fruit-Collider die Warnlinie für **> 2,0 Sekunden** kontinuierlich → Niederlage
- Warnlinie pulsiert rot; Audio-Eskalation
- Kurzzeitige Überschreitung (< 2 s) durch Physik-Bounce: kein sofortiges Game Over

---

## 6. Steuerung

### 6.1 Input-Schema

| Input | Aktion |
|-------|--------|
| Touch Down + Horizontal Drag | Frucht-Position verschieben |
| Touch Up | Frucht fallen lassen |
| Zwei-Finger-Tap (optional) | Pause |
| Hardware Back | Pause-Menü / Zurück (Android-konform) |

### 6.2 Steuerungs-Prinzipien

- **Ein-Daumen-spielbar** — Daumen bleibt im unteren Drittel
- **Ghost-Preview:** Transparente Silhouette zeigt Landeposition
- Kein Joystick, kein Doppel-Tap-Zwang
- Touch-Deadzone: 0 px horizontal
- **Haptisches Feedback:** 8 ms bei Drop, 25 ms bei Fusion

### 6.3 Zugänglichkeit

- „Große Touch-Zonen"-Modus (+20 % Hitbox)
- Reduzierte Screen-Shake
- Farbenblind-Modus: eindeutige Form-Silhouetten + Stufen-Badge
- Vibration ein/ausschaltbar

---

## 7. Sieg- und Niederlagenbedingungen

### 7.1 Niederlage

**Primär:** Danger Zone für > 2,0 s durchbrochen → Game Over.

**Sekundär:**
- App-Minimierung: Spiel pausiert; bei Rückkehr Fortsetzung (max. 5 Min., danach Run verworfen)

### 7.2 „Sieg"

Classic Mode ist **Endlos-Highscore** — kein klassischer Sieg.

**Soft-Sieg-Momente:**
- Erste Goldene Frucht in einem Run
- Neuer persönlicher Rekord
- Erste Erreichung einer neuen Stufe im Frucht-Katalog

### 7.3 Run-Ende-Flow

1. Game-Over-Animation (0,8 s Freeze + Zoom)
2. Ergebnis-Overlay: Score, höchste Frucht, Merges, Dauer
3. CTA: „Nochmal", „Menü", „Teilen" (Release)

---

## 8. Scoring

### 8.1 Punktevergabe

| Event | Basis-Punkte |
|-------|--------------|
| Merge Stufe 1→2 | 10 |
| Merge Stufe 2→3 | 25 |
| Merge Stufe 3→4 | 50 |
| Merge Stufe 4→5 | 100 |
| Merge Stufe 5→6 | 200 |
| Merge Stufe 6→7 | 400 |
| Merge Stufe 7→8 | 800 |
| Merge Stufe 8→9 | 1.600 |
| Merge Stufe 9→10 | 3.200 |
| Merge Stufe 10→11 (Gold) | 7.500 |

### 8.2 Combo-Multiplikator

- Jede Fusion innerhalb von **1,5 s** nach vorheriger Fusion: +10 % Multiplikator (max. ×2,0)
- Combo-Break: visuelles & auditives Feedback

### 8.3 Score-Transparenz

- Floating Score-Popups an Fusion-Position
- Combo-Meter (dezent, oberer Rand)
- Endscreen: Aufschlüsselung Top-3-Merges

---

## 9. Progression

### 9.1 Meta-Progression

| System | MVP | Release |
|--------|-----|---------|
| Persönlicher Highscore | ✓ | ✓ |
| Frucht-Katalog (Stufen gesehen) | ✓ | ✓ |
| Lifetime-Stats | ✓ | ✓ |
| Daily Challenge | — | ✓ |
| Achievements | — | ✓ |
| Kosmetische Skins | — | ✓ |
| Battle Pass / Season | — | Post-Release |

### 9.2 Frucht-Katalog

- 11 Einträge; Silhouette bis „erstmals erzeugt"
- Tap zeigt Name, Trivia, Größe, erreichte Anzahl

### 9.3 Daily Challenge (Release)

- Täglich gleiches Seed für alle Spieler (lokal generiert)
- Ziel: Score ≥ X oder „Erreiche Stufe Y"
- Belohnung: Kosmetik-Währung

### 9.4 Monetarisierung

- Keine Gameplay-Boosts käuflich
- Post-Release: rein kosmetisch + Ads optional
- **Launch:** Clean Launch ohne Werbung (siehe Abschnitt 21)

---

## 10. Balancing

### 10.1 Design-Ziele

| Metrik | Ziel |
|--------|------|
| Median-Run-Dauer (Neuling) | 4 Min. |
| Median-Run-Dauer (Erfahren) | 8–12 Min. |
| Goldene Frucht | < 1 % aller Runs |

### 10.2 Physik-Tuning

| Parameter | Wert |
|-----------|------|
| Gravity Scale | 1,0 |
| Friction | 0,4 |
| Bounce (Boden) | 0,3 |
| Max. gleichzeitige Rigidbodies | 40 (Soft Cap) |
| Sleep-Threshold | aktiv ab 0,1 s Ruhe |

### 10.3 Schwierigkeitskurve

- **Frühe Phase:** viel Leerraum, schnelle Merges
- **Mid-Game:** Stabilität entscheidend, Stufe 6–8 seltener
- **Late-Game:** Mikro-Lücken-Management, hohe Strafe bei Fehl-Drops

---

## 11. UI

### 11.1 Screen-Map

```
Splash → Hauptmenü → Classic Game → Pause → Game Over
                  ↘ Einstellungen
                  ↘ Frucht-Katalog
                  ↘ Statistiken (Release)
                  ↘ Daily Challenge (Release)
```

### 11.2 Hauptmenü

- Logo „Frucht Kombinierer"
- Primär-CTA: **Spielen**
- Sekundär: Katalog, Einstellungen
- Dezente Anzeige: Persönlicher Rekord

### 11.3 HUD (Ingame)

| Element | Position |
|---------|----------|
| Aktueller Score | Oben links |
| Rekord (Ghost) | Oben rechts |
| Nächste Frucht (Release) | Oben Mitte |
| Aktuelle Frucht (Drag) | Oben, beweglich |
| Danger-Line | Im Container |
| Pause-Button | Oben rechts (min. 44×44 dp) |

### 11.4 Visuelles Design System

- **Stil:** Warm, illustrativ, leicht „farmers market"
- **Palette:** Cremeweiß, Holzbraun, Obst-Sättigung, Gold-Akzente
- **Typografie:** Rounded Sans (z. B. Nunito)
- **UI-Frames:** Weiche Schatten, 12 dp Corner Radius
- **Safe Areas:** Notch & Navigation Bar berücksichtigt

---

## 12. Audio

### 12.1 Sound-Liste

| Event | Sound |
|-------|-------|
| Drop | Soft „thud" |
| Merge klein | Helles „pop" |
| Merge groß | Tieferer „bloom" + Chime |
| Goldene Frucht | Spezial-Fanfare (2 s) |
| Combo | Aufsteigende Tonleiter |
| Danger Zone | Pulsierender Warn-Tick |
| Game Over | Sanfter „womp" + UI-Swoosh |
| UI Tap | Holz-Klick |
| Neuer Rekord | Celebration-Stinger |

### 12.2 Musik

- **Hauptmenü:** Entspannte Akustik-Gitarre + leichte Percussion (Loop 2:30)
- **Ingame:** Minimaler Ambient-Loop, Dynamik steigt mit Combo
- **Game Over:** Musik fade-out 1 s

### 12.3 Einstellungen

- Master / SFX / Musik getrennt
- Stummschaltung persistiert lokal

---

## 13. Animationen

| Animation | Dauer | Beschreibung |
|-----------|-------|--------------|
| Idle (in Hand) | Loop | Sanftes Schweben ±4 px |
| Drop | 0,3–0,8 s | Fall mit Squash beim Aufprall |
| Pre-Merge | 0,1 s | Früchte „ziehen" sich minimal an |
| Merge | 0,25 s | Scale-Up + Partikel-Burst |
| Gold-Merge | 0,6 s | Screen-Flash + Sternenring |
| Screen-Transitions | 200 ms | ease-out |
| Score-Counter | 120 ms | Rolling Numbers |
| Danger-Line | 1 Hz | Puls, Opacity 40–80 % |

**Technik:** Animations-Framerate entkoppelt von Physik (Fixed Timestep: 60 Hz). Keine Input-Blockade > 100 ms (außer Game Over).

---

## 14. Juice Effects

### 14.1 Juice-Matrix

| Trigger | Visual | Audio | Haptic |
|---------|--------|-------|--------|
| Drop | Staubpartikel | thud | light |
| Merge S | 8 Partikel, scale punch 1,1× | pop | light |
| Merge M | 16 Partikel, ripple | bloom | medium |
| Merge L | 32 Partikel, screen shake 2 px | bloom+chime | medium |
| Combo ×2 | Rainbow trail | pitch up | light |
| Gold | Full-screen glow 0,3 s | fanfare | heavy |
| Danger | Red vignette | tick | pulse |
| Rekord | Confetti (leicht) | stinger | medium |

### 14.2 Partikel-System

- GPU-basiert, Object-Pooling
- Max. 200 Partikel gleichzeitig
- Obst-Farben an Stufe gebunden
- Screen Shake max. 4 px (Standard), 8 px (Gold) — reduzierbar in Accessibility

---

## 15. Performanceziele

| Metrik | Ziel |
|--------|------|
| Ziel-FPS | 60 (fest) |
| Minimum-FPS (Mid-Tier) | ≥ 55 |
| Frame-Time-Spikes | < 5 % über 33 ms |
| Cold Start | < 3 s |
| Warm Start | < 1 s |
| APK-Größe (MVP) | < 80 MB |
| RAM (Peak) | < 250 MB |
| Batterie | < 5 % / 15 Min. |

### Test-Geräte-Matrix

- Samsung Galaxy A54 (Mid)
- Google Pixel 7 (High)
- Xiaomi Redmi Note 12 (Budget)
- Samsung Galaxy S23 (Flagship Reference)

---

## 16. Android-Anforderungen

| Anforderung | Wert |
|-------------|------|
| Min SDK | API 26 (Android 8.0) |
| Target SDK | API 35 |
| Orientierung | Portrait only |
| **Engine** | **Godot 4.x** |
| Architekturen | arm64-v8a (Pflicht), armeabi-v7a (optional) |

### Google Play Compliance

- Data Safety Form vollständig
- Keine unnötigen Permissions
- Families Policy-konform
- App Bundle (AAB) als Distribution
- 64-bit-only ab Target SDK 35

### Platform Features

- Haptics (Vibrator API)
- Predictive Back (Android 14+)
- Edge-to-Edge Display
- Vollständig offline spielbar (MVP)
- Cloud Save: Post-Release (Google Play Games Services)

### Lokalisierung

| Sprache | MVP | Release |
|---------|-----|---------|
| Deutsch | ✓ | ✓ |
| Englisch | ✓ | ✓ |
| Französisch | — | ✓ |
| Spanisch | — | ✓ |

---

## 17. Risiken

| ID | Risiko | Impact | Wahrscheinlichkeit | Mitigation |
|----|--------|--------|-------------------|------------|
| R1 | IP-Ähnlichkeit zu Suika/Fruit Merge | Hoch | Mittel | Eigenes Art, eigene Hierarchie, eigenes Branding |
| R2 | Physik-Instabilität | Hoch | Mittel | Fixed Timestep (60 Hz), Continuous CD auf RigidBody2D |
| R3 | Performance auf Budget-Geräten | Hoch | Mittel | Früh testen auf Redmi; Quality Settings |
| R4 | Kurze Retention | Mittel | Hoch | Daily Challenge, Katalog, Juice-Qualität |
| R5 | RNG-Frust | Mittel | Hoch | Pity-System, Dual-Preview, transparente Odds |
| R6 | Store-Reject | Mittel | Niedrig | Original Screenshots, keine fremden Marken |
| R7 | Scope Creep | Hoch | Hoch | Striktes MVP; Feature-Flags für Release |
| R8 | Monetarisierung ohne Vertrauen | Mittel | Mittel | Kosmetik-only; Clean Launch |

---

## 18. Zukünftige Features

### Phase 2 (v1.1–v1.3)

- Online-Leaderboards (wöchentlich)
- Zusätzliche Container-Skins
- Achievement-System
- Share-Card (Score als Bild)

### Phase 3 (v1.4–v2.0)

- Zen Mode (kein Game Over, Sandbox)
- Zeit-Attacke (3 Min. maximale Punkte)
- Seasonal Events (z. B. „Ernte-Fest"-Früchte)
- Google Play Games Cloud Save

### Phase 4 (v2.0+)

- iOS-Port
- Live-Ops-Kalender
- Battle Pass (kosmetisch)
- Community-Voting für neue Frucht-Skins

---

## 19. MVP

### 19.1 Ziel

Validierung: Ist das Kern-Gameplay auf Android befriedigend, stabil und retention-fähig?

**Ziel-Datum:** 10 Wochen nach Kickoff

### 19.2 Feature Set

| Feature | Enthalten |
|---------|-----------|
| Classic Endless Mode | ✓ |
| 11-stufige Frucht-Hierarchie | ✓ |
| Single-Preview Drop | ✓ |
| Physik & Merge | ✓ |
| Danger-Zone Game Over (2,0 s) | ✓ |
| Scoring + Combo | ✓ |
| Lokaler Highscore | ✓ |
| Frucht-Katalog | ✓ |
| Basis-Juice (Partikel, Shake, Haptic) | ✓ |
| Hauptmenü + Pause + Game Over | ✓ |
| DE/EN Lokalisierung | ✓ |
| Audio (SFX + 1 Musikloop) | ✓ |
| Einstellungen (Audio, Vibration) | ✓ |
| Analytics (Firebase: Session, D1) | ✓ |

### 19.3 Ausschlüsse

- Daily Challenge
- Achievements
- Kosmetik-Shop
- Ads / IAP
- Online-Leaderboard
- Cloud Save
- Dual-Preview
- Pity-System

### 19.4 Definition of Done

- [ ] 60 FPS auf Galaxy A54
- [ ] Crash-Free ≥ 99 %
- [ ] 10 interne Playtests ohne game-breaking Bug
- [ ] Store-Listing-Entwurf (DE/EN)
- [ ] Soft-Launch in Closed Testing (min. 50 Tester)

---

## 20. Release Version (v1.0)

### 20.1 Ziel

Öffentlicher Google-Play-Launch mit vollem Polish und erweiterten Retention-Systemen.

**Ziel-Datum:** 6 Wochen nach MVP-Soft-Launch

### 20.2 Feature Set (zusätzlich zu MVP)

| Feature | Enthalten |
|---------|-----------|
| Dual-Preview (aktuelle + nächste Frucht) | ✓ |
| Pity-Spawn-System | ✓ |
| Daily Challenge | ✓ |
| Achievement-System (20 Achievements) | ✓ |
| Lifetime-Statistiken-Screen | ✓ |
| 3 Korb-Skins (1 gratis, 2 via Progression) | ✓ |
| Erweiterte Juice (Combo-Trail, Gold-Effekt) | ✓ |
| Share-Funktion (Score-Bild) | ✓ |
| FR/ES Lokalisierung | ✓ |
| Firebase Crashlytics + Remote Config | ✓ |
| Quality Settings (Partikel niedrig/mittel/hoch) | ✓ |
| Predictive Back Support | ✓ |

### 20.3 Definition of Done

- [ ] Soft-Launch-KPIs erfüllt (D1 ≥ 30 %)
- [ ] Store-Rating in Closed Beta ≥ 4,0
- [ ] Keine offenen P0/P1 Bugs
- [ ] ASO: 8 Screenshots, Feature Graphic, Video
- [ ] Legal: Privacy Policy, Impressum (DE)
- [ ] Rollout: 10 % → 50 % → 100 % über 7 Tage

### 20.4 Monetarisierung

- **Keine Ads im v1.0-Launch** (Clean Launch für Reviews)
- IAP-Framework vorbereitet, aber deaktiviert
- Monetarisierung erst v1.1 evaluieren

---

## 21. Produktentscheidungen

Alle Empfehlungen wurden übernommen und sind verbindlich:

| Thema | Entscheidung | Begründung |
|-------|--------------|------------|
| **Engine** | Godot 4.x | Open Source, leichtgewichtig, starke 2D-Physik, git-freundliche Textdateien, kein Hub-Zwang |
| **Spielname (Store)** | Frucht Kombinierer | Klar, deutsch, beschreibt Gameplay; konsistent mit Projektname |
| **Danger-Zone-Dauer** | 2,0 Sekunden | Fairer Puffer für Physik-Bounces; reduziert Frust bei Neulingen |
| **Monetarisierung Launch** | Clean Launch (keine Ads) | Besseres Store-Rating und Vertrauen; Monetarisierung ab v1.1 |
| **End-Tier-Name** | Goldene Frucht | Emotionaler Höhepunkt, visuell distinct, passt zum Obst-Theme |

---

## 22. Glossar

| Begriff | Definition |
|---------|------------|
| **Merge / Fusion** | Zusammenführung zweier gleichstufiger Früchte zur nächsten Stufe |
| **Danger Zone** | Bereich oberhalb der Warnlinie; zu langer Aufenthalt = Game Over |
| **Juice** | Verstärktes sensorisches Feedback (VFX, SFX, Haptic) |
| **Pity-System** | Garantierter „fairer" Spawn nach Serie ungünstiger Zufallsfrüchte |
| **Combo** | Mehrere Merges innerhalb eines kurzen Zeitfensters |
| **Clean Launch** | Veröffentlichung ohne Werbung oder IAP zum Launch-Zeitpunkt |

---

*Dokument erstellt von Product & Game Design — Frucht Kombinierer*
