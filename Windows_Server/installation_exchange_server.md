# Installationsanleitung: Microsoft Exchange Server 2019 CU15 (GUI-Installation)

## Inhaltsverzeichnis

- Einleitung
- Planung und Vorbereitung
  - Hardware- und Softwareanforderungen
  - Wichtige Tools und Links
  - Vorbereitung der Testumgebung
  - Vorbereitung des Active Directory
- Installationsvoraussetzungen
  - Windows Server Features installieren
  - Zusätzliche Software installieren
  - Hinweise zu Windows Server 2019 und winget
- Exchange 2019 CU15 Installation (GUI)
  - Setup starten und Updates suchen
  - Lizenzbedingungen und Einstellungen
  - Rollen- und Installationstyp auswählen
  - Installationspfad festlegen
  - Exchange-Organisation einrichten
  - Malware-Schutz Einstellungen
  - Voraussetzungsprüfung
  - Installation durchführen und Abschluss
- Aufgaben nach der Installation
  - Exchange-Dienste prüfen
  - Exchange Admin Center (EAC) aufrufen
  - SSL-Zertifikate einrichten
  - E-Mail-Fluss testen
  - Backup und Wartung
- Häufige Probleme und Fehlerbehebung
- Wichtige Ressourcen und Links

## Einleitung

In dieser Anleitung wird Schritt für Schritt erläutert, wie Microsoft Exchange Server 2019 CU15 auf einem Windows-Server über den grafischen Setup-Assistenten (GUI Installer) installiert wird. Es handelt sich um eine umfassende Installationsanleitung in deutscher Sprache, die sowohl die Vorbereitung der Umgebung als auch die eigentliche Installation und Nachbereitung abdeckt. Zielgruppe sind IT-Profis und Systemadministratoren, die eine Exchange 2019 CU15 Test- oder Produktivumgebung einrichten möchten. Wir beginnen mit einer Übersicht der Voraussetzungen sowie Planungsschritte. Anschließend folgt die detaillierte Anleitung zur Installation von Exchange Server 2019 CU15 mithilfe des GUI-Setup-Assistenten. Schließlich werden wichtige Nachkonfigurations-Schritte, häufige Probleme und deren Behebung sowie weiterführende Ressourcen erläutert.

> **Hinweis:** Exchange Server 2019 CU15 ist ein kumulatives Update, das alle vorherigen Updates enthält. Bei der Installation von Exchange wird immer die vollständige Version installiert, d.h. Sie müssen keine früheren CUs installieren, wenn Sie direkt mit CU15 beginnen. CU15 entspricht außerdem dem geplanten Wechsel zur neuen Exchange Server Subscription Edition (SE) – es ist das letzte CU für Exchange 2019 und bildet die Basis für Exchange SE.

---

## Planung und Vorbereitung

Eine sorgfältige Planung und Vorbereitung stellt sicher, dass die Exchange-Installation reibungslos verläuft. In diesem Abschnitt erfahren Sie die Mindestanforderungen und Empfehlungen, welche Vorarbeiten durchzuführen sind und welche Ressourcen hilfreich sind, bevor Sie mit der eigentlichen Installation beginnen.

### Hardware- und Softwareanforderungen

**Betriebssystem und Serverrolle:**
- Exchange Server 2019 CU15 kann auf Windows Server 2019 oder höher installiert werden (inkl. Windows Server 2022; Unterstützung für Windows Server 2025 wurde mit CU14/15 hinzugefügt). Für die GUI-Installation muss der Server im Desktop Experience Modus installiert sein. Der Exchange-Server sollte Mitglied einer Active-Directory-Domäne sein (bitte keinen Workgroup-Server verwenden).
- Active Directory:
  - Stellen Sie sicher, dass alle Domänencontroller in der Gesamtstruktur mit einer unterstützten Windows Server-Version ausgeführt werden (z.B. Windows Server 2012 R2 oder höher). Die Gesamtstrukturfunktionsebene muss die Anforderungen für Exchange 2019 erfüllen.
  - In dem Standort muss mindestens ein beschreibbarer globaler Katalogserver vorhanden sein.
- **Wichtig:** Microsoft empfiehlt ausdrücklich, Exchange nicht auf einem Domänencontroller zu installieren.

**Hardware:**
- **CPU:** 64-Bit Prozessor (x64) von Intel oder AMD. Max. 2 physische Sockel empfohlen.
- **RAM:**
  - Mailbox-Server (Produktiv): ≥ 128 GB
  - Edge-Transport-Server: ≥ 64 GB
  - Testumgebung: ≥ 8 GB
- **Festplattenspeicher:**
  - Installationslaufwerk: ≥ 30 GB frei
  - Systemlaufwerk (C:): ≥ 200 MB frei
  - Transport-Warteschlangendatenbank: ≥ 500 MB frei
- **Netzwerk:** Gigabit-Ethernet oder höher, DNS korrekt konfiguriert.
- **Clients:** Outlook 2013, 2016, 2019 und Microsoft 365 Apps for Enterprise.

### Wichtige Tools und Links

- Exchange Deployment Assistant
- Release Notes & KB: CU15 KB5042461
- Supportability Matrix: Unterstützte Windows- und .NET-Versionen
- Microsoft Learn: Detaillierte Dokumentation zu Exchange 2019

### Vorbereitung der Testumgebung

- Isolierte AD-Gesamtstruktur
- Virtuelle Maschinen mit Snapshots
- Interner DNS-Server
- Optional Internetzugang für Updates/Hybrid
- Snapshot vor Installation

### Vorbereitung des Active Directory

**Manuelle AD-Vorbereitung:**
```powershell
Setup.exe /PrepareSchema
Setup.exe /PrepareAD /OrganizationName:<Name>
Setup.exe /PrepareDomain
```

> **AD Vorbereitung durch Setup:** GUI-Setup führt Schema- und AD-Vorbereitung automatisch aus, wenn Rechte vorhanden sind.

---

## Installationsvoraussetzungen

### Windows Server Features installieren

```powershell
Install-WindowsFeature Server-Media-Foundation, NET-Framework-45-Features, RPC-over-HTTP-proxy, RSAT-Clustering, RSAT-Clustering-CmdInterface, RSAT-Clustering-Mgmt, RSAT-Clustering-PowerShell, WAS-Process-Model, Web-Asp-Net45, Web-Basic-Auth, Web-Client-Auth, Web-Digest-Auth, Web-Dir-Browsing, Web-Dyn-Compression, Web-Http-Errors, Web-Http-Logging, Web-Http-Redirect, Web-Http-Tracing, Web-ISAPI-Ext, Web-ISAPI-Filter, Web-Metabase, Web-Mgmt-Console, Web-Mgmt-Service, Web-Net-Ext45, Web-Request-Monitor, Web-Server, Web-Stat-Compression, Web-Static-Content, Web-Windows-Auth, Web-WMI, Windows-Identity-Foundation, RSAT-ADDS
```

### Zusätzliche Software installieren

- .NET Framework 4.8
- Visual C++ Redistributable 2012 (x64)
- Visual C++ Redistributable 2013 (x64)
- IIS URL Rewrite Module 2.1 (x64)
- UCMA 4.0 Runtime

### Hinweise zu Windows Server 2019 und winget

- winget nicht standardmäßig installiert
- Installation über App-Installer
- Praktisch für Redistributables und IIS Module

---

## Exchange 2019 CU15 Installation (GUI)

### Setup starten und Updates suchen

1. Setup.exe als Administrator
2. Check for Updates?
3. Dateien kopieren
4. Einführung → Weiter

### Lizenzbedingungen und Einstellungen

1. Lizenzvertrag akzeptieren
2. Empfohlene Einstellungen (Diagnosedaten senden)

### Rollen- und Installationstyp auswählen

- Mailbox Role auswählen
- Automatisch benötigte Rollen/Features installieren

### Installationspfad festlegen

- Standard: C:\Program Files\Microsoft\Exchange Server\V15
- Empfehlung: eigenes Volume (z.B. E:\Exchange\V15)

### Exchange-Organisation einrichten

- Organisationsname festlegen (z.B. "ContosoExchange")
- Split-Permission deaktiviert

### Malware-Schutz Einstellungen

- „Do you want to disable malware scanning?“
  - Nein (Standard)
  - Ja

### Voraussetzungsprüfung

- Windows-Komponenten
- Softwarepakete
- Speicherplatz
- AD-Rechte

### Installation durchführen und Abschluss

- Fortschritt
- Log: C:\ExchangeSetupLogs\ExchangeSetup.log
- Finish → Neustart

* * *

## Aufgaben nach der Installation

### Exchange-Dienste prüfen

```powershell
Get-Service *Exchange* | Select Name, Status
```

### Exchange Admin Center (EAC) aufrufen

- https://<servername>/ecp

### SSL-Zertifikate einrichten

1. EAC > Server > Zertifikate
2. Anfrage erstellen und importieren
3. Dienste zuweisen

### E-Mail-Fluss testen

- Intern: OWA → Testmail
- Extern ausgehend: Send Connector
- Extern eingehend: MX, Firewall Port 25

### Backup und Wartung

- VSS-Writer Backup
- Sicherheitsupdates
- Monitoring, Logging, DB-Wartung

* * *

## Häufige Probleme und Fehlerbehebung

- Fehlende Voraussetzungen → Retry
- Ungenügende Berechtigungen
- Dienste starten nicht → Event Viewer
- HTTP 500 bei ECP/OWA → URL Rewrite
- Zertifikatwarnungen → Namen anpassen

* * *

## Wichtige Ressourcen und Links

- Microsoft Docs – Exchange 2019 Systemanforderungen
- Microsoft Docs – Exchange 2019 Voraussetzungen
- GUI-Installation Mailbox-Serverrolle
- Release Notes zu CU15 (KB5042461)
- Exchange Deployment Assistant
- Exchange Team Blog
- Download Exchange 2019 CU15
- UCMA, Visual C++ Redistributables, IIS Rewrite
- Microsoft Q&A Forum
- TechNet Foren
- FrankysWeb Exchange Blog
