# Exchange Server Planung und Bereitstellung

## Inhaltsverzeichnis

1. [Einleitung](#einleitung)
2. [Planungsphase](#planungsphase)
   - [Dokumentation und Tools](#dokumentation-und-tools)
   - [Testumgebung](#testumgebung)
   - [Systemanforderungen](#systemanforderungen)
3. [Vorbereitung](#vorbereitung)
   - [Voraussetzungen](#voraussetzungen)
4. [Bereitstellung](#bereitstellung)
   - [Exchange Server-Editionen](#exchange-server-editionen)
   - [Setup-Typen](#setup-typen)
   - [Setup-Modi](#setup-modi)
5. [Installationsschritte](#installationsschritte)
   - [Vorbereitung des Active Directory und der Domänen](#vorbereitung-des-active-directory-und-der-domänen)
   - [Installation der Voraussetzungen](#installation-der-voraussetzungen)
   - [Installation von Exchange Server](#installation-von-exchange-server)
6. [Nach der Installation](#nach-der-installation)
   - [Post-Installation-Aufgaben](#post-installation-aufgaben)
   - [Wartung und Updates](#wartung-und-updates)
7. [Fehlerbehebung](#fehlerbehebung)
8. [Ressourcen](#ressourcen)

## Einleitung

Diese Anleitung deckt alle wichtigen Schritte zur Planung und Bereitstellung von Microsoft Exchange Server ab. Eine sorgfältige Planung und methodische Bereitstellung sind entscheidend für eine erfolgreiche Exchange-Implementierung.

## Planungsphase

### Dokumentation und Tools

1. **Release Notes lesen**:
   - Bevor du mit der Bereitstellung beginnst, lies die aktuellen Release Notes, um über potenzielle Probleme und deren Lösungen informiert zu sein.
   - Link zu den Release Notes: [Exchange Server Release Notes](https://docs.microsoft.com/de-de/exchange/release-notes)

2. **Exchange Server Deployment Assistant**:
   - Nutze den Microsoft Exchange Server Deployment Assistant, um individuelle Checklisten zu erstellen.
   - URL: [Exchange Deployment Assistant](https://assistants.microsoft.com)

### Testumgebung

1. **Isolierte Testumgebung einrichten**:
   - Richte vor der Produktionsbereitstellung eine isolierte Testumgebung ein.
   - Virtualisierung mit Hyper-V kann die Hardwarekosten reduzieren.
   - Führe Tests mit denselben Konfigurationen durch, die für die Produktionsumgebung geplant sind.

2. **Testumgebung konfigurieren**:
   - Domain Controller mit Active Directory
   - DNS-Server
   - Zertifizierungsstelle (wenn intern verwendet)
   - Client-Computer für Tests

### Systemanforderungen

Stelle sicher, dass deine Hardware und Software allen Mindestanforderungen entspricht:

1. **Hardwareanforderungen**:
   - Prozessor: 64-Bit-Prozessor, Intel-kompatibel
   - Arbeitsspeicher: Mindestens 8 GB für Exchange Server 2019
   - Festplattenspeicher: Mindestens 30 GB für Systempartition
   - Zusätzlicher Speicherplatz für Datenbanken und Protokolle

2. **Softwareanforderungen**:
   - Windows Server (Version je nach Exchange-Version)
   - .NET Framework (spezifische Version je nach Exchange-Version)
   - Aktuelle Windows-Updates
   - Unterstützte Active Directory-Gesamtstruktur und -Domain-Funktionsebene

## Vorbereitung

### Voraussetzungen

Installiere die erforderlichen Windows Server-Features und andere Software:

1. **Windows-Features**:
   ```powershell
   Install-WindowsFeature NET-Framework-45-Features, RPC-over-HTTP-proxy, RSAT-Clustering, RSAT-Clustering-CmdInterface, RSAT-Clustering-Mgmt, RSAT-Clustering-PowerShell, Web-Mgmt-Console, WAS-Process-Model, Web-Asp-Net45, Web-Basic-Auth, Web-Client-Auth, Web-Digest-Auth, Web-Dir-Browsing, Web-Dyn-Compression, Web-Http-Errors, Web-Http-Logging, Web-Http-Redirect, Web-Http-Tracing, Web-ISAPI-Ext, Web-ISAPI-Filter, Web-Mgmt-Console, Web-Metabase, Web-Mgmt-Service, Web-Net-Ext45, Web-Request-Monitor, Web-Server, Web-Stat-Compression, Web-Static-Content, Web-Windows-Auth, Web-WMI, Windows-Identity-Foundation, RSAT-ADDS
   ```

2. **Zusätzliche Software**:
   
   **Für Windows Server 2025**:
   Winget ist bereits im Lieferumfang enthalten und kann direkt verwendet werden:
   
   ```powershell
   # Installiere über winget verfügbare Komponenten
   winget install Microsoft.VCRedist.2015+.x64
   winget install Microsoft.VCRedist.2013.x64
   winget install Microsoft.VCRedist.2012.x64
   
   # .NET Framework 4.8 (falls nicht bereits als Windows-Feature installiert)
   winget install Microsoft.DotNet.Framework.DeveloperPack_4
   ```
   
   **Zusätzlich benötigt:**:
   Für den UCMA 4.0 Runtime (nicht über winget verfügbar):
   - Manueller Download: [UCMA 4.0 Runtime](https://www.microsoft.com/en-us/download/details.aspx?id=34992) 

   **Für Windows Server 2019 und 2022**:
   Installiere zuerst den [App Installer](https://www.microsoft.com/p/app-installer/9nblggh4nns1) für winget-Unterstützung.
   
   

   Alternativ, wenn winget nicht verfügbar ist (Windows Server 2016 und älter), nutze die direkten Download-Links:
   - [Microsoft Visual C++ Redistributable 2012](https://www.microsoft.com/de-de/download/details.aspx?id=30679)
   - [Microsoft Visual C++ Redistributable 2013](https://www.microsoft.com/de-de/download/details.aspx?id=40784)
   - [Microsoft Visual C++ Redistributable 2019](https://learn.microsoft.com/de-de/cpp/windows/latest-supported-vc-redist)
   - [.NET Framework 4.8](https://dotnet.microsoft.com/de-de/download/dotnet-framework/net48)

## Installationsschritte

### Vorbereitung des Active Directory und der Domänen

Die Active Directory-Umgebung muss für Exchange Server vorbereitet werden. Diese Befehle verwendest du mit der `Setup.exe` aus dem Exchange Server-Installationsmedium (DVD oder ISO). Beachte: In PowerShell musst du bei lokalen Befehlen `.\` voranstellen:

1. **Schema erweitern**:
   ```powershell
   .\Setup.exe /PrepareSchema /IAcceptExchangeServerLicenseTerms
   ```

2. **Active Directory vorbereiten**:
   ```powershell
   .\Setup.exe /PrepareAD /OrganizationName:"OrganisationsName" /IAcceptExchangeServerLicenseTerms
   ```

3. **Domäne vorbereiten**:
   ```powershell
   .\Setup.exe /PrepareDomain /IAcceptExchangeServerLicenseTerms
   ```
   Oder alle Domänen vorbereiten:
   ```powershell
   .\Setup.exe /PrepareAllDomains /IAcceptExchangeServerLicenseTerms
   ```

4. **Überprüfe die AD-Replikation**:
   - Stelle sicher, dass alle Änderungen an alle Domain Controller repliziert wurden
   - Verwende das Tool `repadmin /syncall` zur Überprüfung

### Installation der Voraussetzungen

1. **Server vorbereiten**:
   - Windows Server aktualisieren (neueste Updates)
   - Erforderliche Windows-Features installieren
   - Erforderliche Software installieren

2. **Netzwerk konfigurieren**:
   - Statische IP-Adresse zuweisen
   - DNS-Einstellungen konfigurieren
   - Firewall-Einstellungen anpassen

### Installation von Exchange Server

#### Über den Exchange Setup-Assistenten (GUI):

1. Mounte das Exchange Server ISO-Image oder lege die DVD ein
2. Wechsle in PowerShell zum Verzeichnis mit der Setup.exe und führe `.\Setup.exe` aus
3. Wähle im Setup-Assistenten die gewünschten Optionen:
   - Serverrolle(n)
   - Installationspfad
   - Ort der Exchange-Datenbank und -Protokolle
   - Exchange Organization-Name (falls erforderlich)
4. Überprüfe die Voraussetzungen (Readiness Checks)
5. Starte die Installation
6. Führe nach Abschluss die empfohlenen Post-Installation-Schritte durch

#### Über unbeaufsichtigte Installation (Befehlszeile):

1. Öffne eine Eingabeaufforderung mit Administratorrechten
2. Wechsle zum Exchange-Installationsverzeichnis
3. Führe einen Befehl ähnlich dem folgenden aus:

   ```powershell
   .\Setup.exe /Mode:Install /Role:Mailbox /OrganizationName:"OrganisationsName" /IAcceptExchangeServerLicenseTerms
   ```

4. Füge weitere Parameter nach Bedarf hinzu:
   - `/TargetDir`: Installationsverzeichnis
   - `/MdbName`: Name der Standarddatenbank
   - `/DbFilePath`: Pfad für Datenbankdateien
   - `/LogFolderPath`: Pfad für Protokolldateien

## Nach der Installation

### Post-Installation-Aufgaben

1. **Konfigurieren der Zertifikate**:
   - Erstelle eine Zertifikatanforderung für ein SSL-Zertifikat
   - Importiere und weise das SSL-Zertifikat den erforderlichen Diensten zu

2. **Virtuelle Verzeichnisse konfigurieren**:
   - Passe die URL-Einstellungen für OWA, ECP, ActiveSync usw. an

3. **Empfängerrichtlinien konfigurieren**:
   - E-Mail-Adressrichtlinien erstellen/anpassen
   - Postfachrichtlinien einrichten

4. **Transporteinstellungen konfigurieren**:
   - Akzeptierte Domänen einrichten
   - Empfangsconnectors konfigurieren
   - Sendeconnectors konfigurieren

5. **Datenbanken konfigurieren**:
   - Zusätzliche Datenbanken erstellen (bei Bedarf)
   - Datenbankkopien einrichten (für hohe Verfügbarkeit)

### Wartung und Updates

1. **Regelmäßige Updates installieren**:
   - Installiere die neuesten Cumulative Updates (CUs)
   - Installiere Security Updates zeitnah

2. **Systemüberwachung**:
   - Führe regelmäßig das Exchange Health Checker-Skript aus, um Sicherheitsupdates zu überprüfen
   - Überwache Ereignisprotokolle und Performance-Metriken
   - Richte Warnungen für kritische Ereignisse ein

3. **Backup-Strategie**:
   - Implementiere regelmäßige Backups der Exchange-Datenbanken
   - Teste Wiederherstellungsprozeduren regelmäßig

## Fehlerbehebung

1. **Setup-Protokolle überprüfen**:
   - Standardspeicherort: `C:\ExchangeSetupLogs`
   - Wichtige Protokolldatei: `ExchangeSetup.log`

2. **Ereignisprotokolle überprüfen**:
   - Windows-Ereignisanzeige öffnen
   - Application- und System-Logs auf Exchange-bezogene Fehler prüfen

3. **Allgemeine Probleme und Lösungen**:
   - Schema-Vorbereitung schlägt fehl: Stelle sicher, dass der Benutzer über Schemaadministratorrechte verfügt
   - Installationsfehler aufgrund fehlender Voraussetzungen: Installiere alle erforderlichen Windows-Features und Software
   - Replikationsprobleme: Überprüfe die AD-Replikation zwischen allen Domain Controllern

## Ressourcen

- [Microsoft Exchange Server-Dokumentation](https://docs.microsoft.com/de-de/exchange/)
- [Exchange Server Deployment Assistant](https://assistants.microsoft.com)
- [Exchange Server Supportmatrix](https://docs.microsoft.com/de-de/exchange/plan-and-deploy/supportability-matrix)
- [Exchange Server TechCommunity](https://techcommunity.microsoft.com/t5/exchange/ct-p/Exchange)
- [Exchange Server Health Checker](https://github.com/microsoft/CSS-Exchange/tree/main/HealthChecker)
