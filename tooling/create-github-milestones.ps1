# Creates GitHub milestones M01-M36 for Frucht Kombinierer
# Requires: gh auth login

$ErrorActionPreference = "Stop"
$Repo = "tommy040797/Frucht-Kombinierer"

$milestones = @(
    @{ Num = "M01"; Title = "Godot-Projekt-Scaffold"; Phase = "Foundation"; Desc = "Lauffaehiges Godot-4-Projekt, Ordnerstruktur, Portrait, Physics 60Hz" }
    @{ Num = "M02"; Title = "Autoloads Core"; Phase = "Foundation"; Desc = "EventBus, FeatureFlags, SaveService-Stub als Autoloads" }
    @{ Num = "M03"; Title = "Custom Resources und Config"; Phase = "Foundation"; Desc = "FruitDefinition, SpawnConfig, ScoreConfig, PhysicsConfig als .tres" }
    @{ Num = "M04"; Title = "Test-Framework-Setup"; Phase = "Foundation"; Desc = "GdUnit4 installieren, erstes Unit-Test-Skeleton" }
    @{ Num = "M05"; Title = "Container und Physik-Grenzen"; Phase = "Foundation"; Desc = "Obstkorb StaticBody2D, Waende, Boden, Danger-Line Area2D" }
    @{ Num = "M06"; Title = "FruitBody und Object Pool"; Phase = "Vertical Slice"; Desc = "RigidBody2D FruitBody, FruitPool acquire/release" }
    @{ Num = "M07"; Title = "Input und Drop-Preview"; Phase = "Vertical Slice"; Desc = "Touch-Drag, Ghost-Silhouette, Drop bei Release" }
    @{ Num = "M08"; Title = "MergeService Tier 1 zu 2"; Phase = "Vertical Slice"; Desc = "Gleich-Tier-Kollision, Merge am Kontaktpunkt" }
    @{ Num = "M09"; Title = "ScoreService Basis"; Phase = "Vertical Slice"; Desc = "Punkte bei Merge gemaess ScoreConfig PRD 8.1" }
    @{ Num = "M10"; Title = "Vertical Slice Integration"; Phase = "Vertical Slice"; Desc = "Drop, Physik, Merge, Score end-to-end spielbar" }
    @{ Num = "M11"; Title = "SpawnService RNG"; Phase = "Vertical Slice"; Desc = "Gewichtetes RNG Tier 1-5, Single-Preview" }
    @{ Num = "M12"; Title = "Merge-Kette 11 Tiers"; Phase = "Vertical Slice"; Desc = "Alle Frucht-Stufen, Kettenreaktionen bis Gold" }
    @{ Num = "M13"; Title = "Combo-System"; Phase = "Core Gameplay"; Desc = "1.5s Fenster, +10 Prozent Multiplikator, max x2.0" }
    @{ Num = "M14"; Title = "Danger Zone"; Phase = "Core Gameplay"; Desc = "2.0s ueber Warnlinie loest Game Over aus" }
    @{ Num = "M15"; Title = "Game-Over-Logik"; Phase = "Core Gameplay"; Desc = "Physik stoppen, RunStats, run_ended Event" }
    @{ Num = "M16"; Title = "Game State Machine"; Phase = "Core Gameplay"; Desc = "Boot, Splash, Menu, Playing, Paused, GameOver States" }
    @{ Num = "M17"; Title = "RunSession"; Phase = "Core Gameplay"; Desc = "Score, HighestTier, MergeCount, Duration pro Run" }
    @{ Num = "M18"; Title = "Game Bootstrap"; Phase = "Core Gameplay"; Desc = "GameBootstrap orchestriert Services, Playing State" }
    @{ Num = "M19"; Title = "Main Menu"; Phase = "UI"; Desc = "Logo, Spielen, Katalog, Einstellungen, Highscore PRD 11.2" }
    @{ Num = "M20"; Title = "Game HUD"; Phase = "UI"; Desc = "Score, Rekord, Pause, Combo-Meter PRD 11.3" }
    @{ Num = "M21"; Title = "Pause und Android Back"; Phase = "UI"; Desc = "Pause-Overlay, Resume/Menu, Back-Button" }
    @{ Num = "M22"; Title = "Game Over Screen"; Phase = "UI"; Desc = "Stats, Nochmal/Menu CTAs PRD 7.3" }
    @{ Num = "M23"; Title = "Splash und Boot Flow"; Phase = "UI"; Desc = "Asset-Preload, Splash, Cold Start unter 3s" }
    @{ Num = "M24"; Title = "UI Theme und Safe Area"; Phase = "UI"; Desc = "Theme.tres, Nunito, Safe Area Notch PRD 11.4" }
    @{ Num = "M25"; Title = "Placeholder-Art Pass"; Phase = "UI"; Desc = "11 unterscheidbare Frucht-Sprites und Container" }
    @{ Num = "M26"; Title = "Save und Highscore"; Phase = "Meta und Polish"; Desc = "JSON user://save.json, Highscore persistiert" }
    @{ Num = "M27"; Title = "Frucht-Katalog"; Phase = "Meta und Polish"; Desc = "11 Eintraege, Discovery, Silhouette PRD 9.2" }
    @{ Num = "M28"; Title = "Einstellungen"; Phase = "Meta und Polish"; Desc = "Audio-Slider, Vibration, Persistenz PRD 12.3" }
    @{ Num = "M29"; Title = "Audio SFX"; Phase = "Meta und Polish"; Desc = "AudioService, SfxPool, Drop/Merge/UI Sounds" }
    @{ Num = "M30"; Title = "Musik"; Phase = "Meta und Polish"; Desc = "Menu und Ingame Loop, Crossfade, Game-Over-Fade" }
    @{ Num = "M31"; Title = "Juice Basis"; Phase = "Meta und Polish"; Desc = "Partikel, Screen-Shake, Haptics PRD 14" }
    @{ Num = "M32"; Title = "Lokalisierung DE/EN"; Phase = "Meta und Polish"; Desc = "CSV-Translations, alle UI-Strings" }
    @{ Num = "M33"; Title = "Android Export"; Phase = "Ship MVP"; Desc = "AAB Export, Min SDK 26, Target 35" }
    @{ Num = "M34"; Title = "Performance-Tuning"; Phase = "Ship MVP"; Desc = "60 FPS Ziel Mid-Tier, Soft Cap 40 Bodies" }
    @{ Num = "M35"; Title = "Firebase Analytics"; Phase = "Ship MVP"; Desc = "Session, Run-End, Fruit-Discovered Events" }
    @{ Num = "M36"; Title = "MVP Release Candidate"; Phase = "Ship MVP"; Desc = "MVP DoD PRD 19.4, Closed Testing Build v0.1.0-mvp" }
)

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    $ghPath = "C:\Program Files\GitHub CLI\gh.exe"
    if (Test-Path $ghPath) {
        $env:Path += ";C:\Program Files\GitHub CLI"
    } else {
        Write-Error "GitHub CLI (gh) nicht gefunden. Installieren: winget install GitHub.cli"
        exit 1
    }
}

gh auth status 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Error "Nicht bei GitHub angemeldet. Bitte ausfuehren: gh auth login"
    exit 1
}

Write-Host "Lade bestehende Milestones ..." -ForegroundColor Cyan
$existingTitles = @{}
$apiResponse = gh api "repos/$Repo/milestones?state=all&per_page=100"
$milestoneList = $apiResponse | ConvertFrom-Json
foreach ($item in $milestoneList) {
    $existingTitles[$item.title] = $true
}

Write-Host "Erstelle $($milestones.Count) Milestones in $Repo ..." -ForegroundColor Cyan

$created = 0
$skipped = 0
$failed = 0

foreach ($m in $milestones) {
    $title = "$($m.Num) - $($m.Title)"
    $body = "**Phase:** $($m.Phase)`n`n$($m.Desc)`n`nSpec: docs/MILESTONES.md"

    if ($existingTitles.ContainsKey($title)) {
        Write-Host "  SKIP: $title" -ForegroundColor Yellow
        $skipped++
        continue
    }

    $payload = @{ title = $title; description = $body } | ConvertTo-Json -Compress
    $payload | gh api "repos/$Repo/milestones" --method POST --input - 2>&1 | Out-Null

    if ($LASTEXITCODE -eq 0) {
        Write-Host "  OK:   $title" -ForegroundColor Green
        $created++
    } else {
        Write-Host "  FAIL: $title" -ForegroundColor Red
        $failed++
    }
}

Write-Host ""
Write-Host "Fertig: $created erstellt, $skipped uebersprungen, $failed fehlgeschlagen." -ForegroundColor Cyan
Write-Host "Milestones: https://github.com/$Repo/milestones"

if ($failed -gt 0) { exit 1 }
