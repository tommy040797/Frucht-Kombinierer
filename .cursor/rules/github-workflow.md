# GitHub Workflow Regeln

Du arbeitest ausschließlich entlang der definierten GitHub Milestones und Issues.

Vor jeder Implementierung:

1. Prüfe den aktuellen GitHub Milestone.
2. Prüfe alle dazugehörigen Issues.
3. Identifiziere Abhängigkeiten.
4. Prüfe, welche Aufgaben bereits erledigt wurden.
5. Erstelle einen Implementierungsplan.

Arbeite niemals an Features außerhalb des aktuellen Milestones.

---

## Arbeitsweise

Für jedes Issue:

1. Verstehe die Anforderungen.
2. Prüfe bestehende Architektur.
3. Plane die Änderung.
4. Implementiere die kleinste sinnvolle Änderung.
5. Schreibe Tests.
6. Führe Code Review durch.
7. Refaktoriere.
8. Aktualisiere Dokumentation.
9. Bereite Commit vor.

---

## Commit Regeln

Jeder Commit muss:

- eine klare Beschreibung besitzen
- nur eine zusammenhängende Änderung enthalten
- kompilierbar sein
- getesteten Code enthalten

Commit Format:

feat:
fix:
refactor:
test:
docs:

Beispiel:

feat(physics): implement circle collision detection

---

## Qualitätsstandard

Eine Aufgabe gilt erst als abgeschlossen wenn:

✓ Code funktioniert
✓ Tests vorhanden
✓ Dokumentation aktualisiert
✓ keine Warnungen
✓ Architektur eingehalten
✓ Performance geprüft
✓ Milestone-Akzeptanzkriterien vollständig abgeschlossen

---

## Milestone abschließen (Pflicht am Ende jedes Milestones)

Ein Milestone ist **erst dann abgeschlossen**, wenn Code **und** Tracking synchron sind. Nach der Implementierung immer in dieser Reihenfolge:

### 1. Akzeptanzkriterien prüfen

- Alle Kriterien aus `Docs/MILESTONES.md` für den aktuellen Milestone (Abschnitt + Checkliste) durchgehen
- Jede Zeile explizit verifizieren (Headless-Start, Unit-Tests, manuelle Checks — je nach Milestone)
- Fehlende Kriterien nachziehen, bevor der Milestone als erledigt gilt

### 2. Lokale Dokumentation aktualisieren

In `Docs/MILESTONES.md`:

- Status-Zeile: `✅ Abgeschlossen (TT.MM.JJJJ)`
- Alle Checklisten-Items `[x]` setzen
- Übersichtstabelle (Fortschritt) anpassen

### 3. GitHub Issue schließen

```powershell
gh issue close <nummer> --repo tommy040797/Frucht-Kombinierer --comment "M0X abgeschlossen — Akzeptanzkriterien verifiziert (siehe Docs/MILESTONES.md)."
```

- Issue-Nummer = Milestone-Nummer (z. B. M03 → Issue #3)
- GitHub-Milestone schließen (falls nach Issue-Close noch `open`):

```powershell
gh api repos/tommy040797/Frucht-Kombinierer/milestones/<nummer> -X PATCH -f state=closed
```

### 4. Abschluss-Checkliste (DoD)

Vor dem nächsten Milestone bestätigen:

- [ ] Akzeptanzkriterien verifiziert
- [ ] `Docs/MILESTONES.md` aktualisiert
- [ ] GitHub Issue geschlossen
- [ ] GitHub Milestone geschlossen
- [ ] Commits auf `master` (oder PR gemerged)

**Nicht ausreichend:** Nur Code committen oder nur `MILESTONES.md` lokal bearbeiten — ohne geschlossenes GitHub-Issue gilt der Milestone als offen.
