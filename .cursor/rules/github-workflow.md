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
✓ Milestone akzeptanzkriterien vollständig abgeschlossen
