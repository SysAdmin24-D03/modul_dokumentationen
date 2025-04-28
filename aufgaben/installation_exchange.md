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

## INSTALLATION FOLGT

