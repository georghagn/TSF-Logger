
# TSF-Logger Design Dokumentation

**Projekt:** TSF-Logger (Teil der Tiny Smalltalk Framework Suite)
**Datum:** 27. November 2025
**Plattform:** Pharo Smalltalk
**Status:** V1.0 (Core, Appender, Async, Tests implementiert)

## Architektur-Übersicht

Das Framework folgt einem modularen Ansatz basierend auf dem Strategy- und Decorator-Pattern.

### 1. Kern-Klassen
* **`TsfLogger` (Core):** * Verwaltet Log-Level (Debug bis Fatal).
    * Hält eine Collection von Appendern.
    * Agiert als Router/Dispatcher. 
    * *Wichtig:* Enthält KEINE Formatierungslogik mehr (Refactoring V1).
    * API: `info:`, `warn:`, etc. unterstützt Strings und Blöcke (Lazy Eval).

* **`TsfLogAppender` (Abstract Strategy):**
    * Basisklasse für Ausgabeziele.
    * **Besitzt den `formatter`**.
    * Methode `recordTag:message:` koordiniert Formatierung und ruft `record:` auf.

### 2. Appender Implementierungen
* **`TsfTranscriptAppender`:** Schreibt in den Pharo Transcript.
* **`TsfFileAppender`:** * Strategie: **Open-Write-Close**.
    * Grund: Robustheit gegenüber externen Tools (Log-Rotation, TSF-Rotator).
    * Nimmt Performance-Hit in Kauf zugunsten von Stabilität.
* **`TsfAsyncLogAppender` (Decorator):**
    * Wrappt einen anderen Appender.
    * Nutzt `SharedQueue` und einen Hintergrund-Prozess (`forkAt: Processor userBackgroundPriority`).
    * Features: `flush` (wartet via Semaphore, bis Queue leer ist).
    * Formatierung geschieht **synchron** im Main-Thread (State freezing), Schreiben asynchron.

### 3. Formatter
* **`TsfLogMessageFormatter` (Abstract):** Definiert Schnittstelle.
* **`TsfDefaultLogFormatter`:** Einfacher Text `[TAG] Message`.
* **`TsfJsonLogFormatter`:** Nutzt `STONJSON` für strukturierte Logs.

## Wichtige Design-Entscheidungen

1.  **Initialization:** Wir nutzen explizite `initialize` Methoden statt Lazy-Getters für Instanzvariablen (außer in Migrationsszenarien), um Thread-Safety und Determinismus zu gewährleisten.
2.  **Convenience:** `TsfLogger class >> new` liefert mittels `super new` eine konfigurierte Instanz (Transcript) zurück ("Batteries included").
3.  **Dependencies:** Keine externen Bibliotheken (nutzt Pharo Core + STON).
4.  **Testing:** Nutzung eines `TsfMemoryAppender` für Unit-Tests, um IO-unabhängig Logik zu prüfen.

## Offene Punkte / Ideen für V2
* Globaler Logger (Singleton Accessor), falls benötigt.
* Mehr Formatter (z.B. Syslog Format).


