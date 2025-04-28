# Exchange Server Planung und Bereitstellung

## Inhaltsverzeichnis

1. [Einleitung](#einleitung)
2. [Planungsphase](#planungsphase)
   - [Dokumentation und Tools](#dokumentation-und-tools)
   - [Testumgebung](#testumgebung)
   - [Systemanforderungen](#systemanforderungen)
3. [Vorbereitung](#vorbereitung)
   - [Voraussetzungen](#voraussetzungen)
4. [Installationsschritte](#installationsschritte)
   - [Vorbereitung des Active Directory und der Domänen](#vorbereitung-des-active-directory-und-der-domänen)
   - [Installation der Voraussetzungen](#installation-der-voraussetzungen)
   - [Installation von Exchange Server](#installation-von-exchange-server)
5. [Nach der Installation](#nach-der-installation)
   - [Post-Installation-Aufgaben](#post-installation-aufgaben)
   - [Wartung und Updates](#wartung-und-updates)
6. [Fehlerbehebung](#fehlerbehebung)
7. [Ressourcen](#ressourcen)

## Einleitung

Diese Anleitung deckt alle wichtigen Schritte zur Planung und Bereitstellung von Microsoft Exchange Server ab. Eine sorgfältige Planung und methodische Bereitstellung sind entscheidend für eine erfolgreiche Exchange-Implementierung.

## Planungsphase

### Dokumentation und Tools

1. **Release Notes lesen**:
   - Lies die aktuellen Release Notes, um über potenzielle Probleme und deren Lösungen informiert zu sein.
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
   - **Für Windows Server 2025**: Winget ist bereits im Lieferumfang enthalten und kann direkt verwendet werden:
     ```powershell
     winget install Microsoft.VCRedist.2015+.x64
     winget install Microsoft.VCRedist.2013.x64
     winget install Microsoft.VCRedist.2012.x64
     winget install Microsoft.DotNet.Framework.DeveloperPack_4
     ```
   - **Für Windows Server 2019 und 2022**: Installiere zuerst den [App Installer](https://www.microsoft.com/p/app-installer/9nblggh4nns1) für winget-Unterstützung und verwende dann die gleichen Befehle wie oben.
   - **Für alle Windows Server-Versionen**: UCMA 4.0 Runtime ist nicht über winget verfügbar und muss manuell heruntergeladen werden: [UCMA 4.0 Runtime](https://www.microsoft.com/en-us/download/details.aspx?id=34992).
   - **Für ältere Windows Server-Versionen (2016 und älter)**: Nutze die direkten Download-Links:
     - [Microsoft Visual C++ Redistributable 2012](https://www.microsoft.com/de-de/download/details.aspx?id=30679)
     - [Microsoft Visual C++ Redistributable 2013](https://www.microsoft.com/de-de/download/details.aspx?id=40784)
     - [Microsoft Visual C++ Redistributable 2019](https://learn.microsoft.com/de-de/cpp/windows/latest-supported-vc-redist)
     - [.NET Framework 4.8](https://dotnet.microsoft.com/de-de/download/dotnet-framework/net48)

## Installationsschritte

### Vorbereitung des Active Directory und der Domänen

Die Active Directory-Umgebung muss für Exchange Server vorbereitet werden. Diese Befehle verwendest du mit der `Setup.exe` aus dem Exchange Server-Installationsmedium (DVD oder ISO). Beachte: In PowerShell musst du bei lokalen Befehlen `./` voranstellen:

1. **Schema erweitern**:
   ```powershell
   ./Setup.exe /PrepareSchema /IAcceptExchangeServerLicenseTerms
   ```

2. **Active Directory vorbereiten**:
   ```powershell
   ./Setup.exe /PrepareAD /OrganizationName:"OrganisationsName" /IAcceptExchangeServerLicenseTerms
   ```

3. **Domäne vorbereiten**:
   ```powershell
   ./Setup.exe /PrepareDomain /IAcceptExchangeServerLicenseTerms
   ```
   Oder alle Domänen vorbereiten:
   ```powershell
   ./Setup.exe /PrepareAllDomains /IAcceptExchangeServerLicenseTerms
   ```

4. **Überprüfe die AD-Replikation**:
   - Stelle sicher, dass alle Änderungen an alle Domain Controller repliziert wurden.
   - Verwende das Tool `repadmin /syncall` zur Überprüfung.

### Installation der Voraussetzungen

1. **Server vorbereiten**:
   - Windows Server aktualisieren (neueste Updates).
   - Erforderliche Windows-Features installieren.
   - Erforderliche Software installieren.

2. **Netzwerk konfigurieren**:
   - Statische IP-Adresse zuweisen.
   - DNS-Einstellungen konfigurieren.
   - Firewall-Einstellungen anpassen.

### Installation von Exchange Server

#### Über den Exchange Setup-Assistenten (GUI):

1. **Vorbereitung für die Installation**:
   - Stelle sicher, dass du als Administrator angemeldet bist.
   - Mounte das Exchange Server ISO-Image oder lege die DVD ein.
   - Deaktiviere temporär die Antivirensoftware, um Installationsprobleme zu vermeiden.
   - Schließe alle unnötigen Programme.

2. **Starte den Setup-Assistenten**:
   - Wechsle zum Installationsmedium (DVD/ISO).
   - Öffne die PowerShell mit Administratorrechten und navigiere zum Verzeichnis.
   - Führe `./Setup.exe` aus.
   - Falls eine Windows-Sicherheitswarnung erscheint, klicke auf "Ja".

3. **Exchange Server-Setup-Assistent**:
   - Wenn der Assistent startet, klicke auf "Weiter".
   - Überprüfe auf Updates: Wähle "Mit dem Internet verbinden und nach Updates suchen".
   - Einwilligung in die Lizenzbedingungen: Lies die Lizenzvereinbarung und wähle "Ich akzeptiere die Bedingungen".

4. **Installationstyp auswählen**:
   - Wähle "Typische Exchange-Serverinstallation" für eine Standardinstallation mit den gängigsten Komponenten.
   - Wähle "Benutzerdefinierte Exchange-Serverinstallation" für erweiterte Anpassungen.
   - Bei einer benutzerdefinierten Installation kannst du einzelne Serverrollen auswählen:
     - Mailbox (primäre Rolle, enthält Datenbanken und die meisten Dienste).
     - Edge Transport (optional, für DMZ-Bereitstellungen).

5. **Serverrollen konfigurieren (bei benutzerdefinierter Installation)**:
   - Wähle die zu installierenden Serverrollen aus.
   - Für den ersten Exchange-Server wird meist die Mailbox-Rolle empfohlen.
   - Klicke auf "Weiter", wenn du deine Auswahl getroffen hast.

6. **Exchange-Organisationsname festlegen**:
   - Gib einen aussagekräftigen Namen für deine Exchange-Organisation ein.
   - Dieser Name kann später nicht mehr geändert werden.
   - Beachte: Keine Leerzeichen oder Sonderzeichen verwenden.
   - Bei einer bestehenden Organisation wird dieser Schritt übersprungen.

7. **Malware-Schutzeinstellungen**:
   - Wähle, ob der integrierte Malware-Schutz aktiviert werden soll.
   - Empfohlen: "Ja" auswählen, wenn keine andere Antimalware-Lösung für Exchange vorhanden ist.

8. **Speicherorte festlegen**:
   - **Installationspfad**: Standardmäßig `C:\Program Files\Microsoft\Exchange Server\V15`.
   - **Exchange-Datenbanken**: Wähle idealerweise ein separates Volume mit ausreichend Speicherplatz.
   - **Exchange-Protokolldateien**: Am besten auf einem separaten Volume für optimale Leistung und Sicherheit.

9. **Überprüfung der Readiness-Checks**:
   - Das Setup überprüft, ob alle Voraussetzungen erfüllt sind.
   - Falls Fehler auftreten, behebe diese und klicke dann auf "Erneut überprüfen".
   - Bei Warnungen kannst du meist mit "Weiter" fortfahren.
   - Bei kritischen Fehlern musst du diese zuerst beheben.

10. **Installation starten**:
    - Überprüfe die Installationsübersicht.
    - Klicke auf "Installieren", um den Installationsprozess zu starten.
    - Die Installation kann 30-60 Minuten oder länger dauern, abhängig von der Systemleistung.

11. **Installationsfortschritt überwachen**:
    - Der Assistent zeigt den Fortschritt für jeden Installationsschritt an.
    - Während der Installation werden verschiedene Dienste installiert und konfiguriert.
    - Warte, bis alle Schritte abgeschlossen sind.

12. **Installation abschließen**:
    - Nach erfolgreicher Installation erscheint eine Zusammenfassung.
    - Lies die angezeigten Informationen sorgfältig durch.
    - Klicke auf "Fertig stellen", um den Assistenten zu schließen.
    - Es wird empfohlen, den Server nach der Installation neu zu starten.

13. **Überprüfung nach der Installation**:
    - Öffne die Exchange Management Shell, um zu prüfen, ob die Installation erfolgreich war.
    - Führe den Befehl `Get-ExchangeServer | Format-List Name,Edition,AdminDisplayVersion` aus, um die Serverdetails anzuzeigen.
    - Öffne das Exchange Admin Center (EAC) über https://servername/ecp, um die webbasierte Verwaltungsoberfläche zu testen.

14. **Erste Konfigurationsschritte**:
    - Akzeptierte Domänen konfigurieren.
    - E-Mail-Adressrichtlinien einrichten.
    - Postfachdatenbanken und ihre Eigenschaften konfigurieren.
    - Virtuelle Verzeichnisse und URL-Einstellungen anpassen.

## Nach der Installation

### Post-Installation-Aufgaben

1. **Überprüfung der Dienste**:
   - Stelle sicher, dass alle Exchange-Dienste ordnungsgemäß ausgeführt werden.
   - Überprüfe die Ereignisanzeige auf Fehler oder Warnungen.

2. **Zugriff auf die Exchange-Verwaltungskonsole**:
   - Melde dich bei der Exchange-Verwaltungskonsole an, um die Installation zu verwalten.
   - URL: `https://<DeinExchangeServer>/ecp`

3. **SSL-Zertifikate konfigurieren**:
   - Stelle sicher, dass gültige SSL-Zertifikate für die Exchange-Dienste installiert sind.
   - Konfiguriere die Zertifikate für die Verwendung mit IIS und anderen Diensten.

4. **E-Mail-Fluss testen**:
   - Überprüfe den E-Mail-Fluss zwischen Postfächern in der Organisation.
   - Teste den E-Mail-Versand an und von externen Adressen.

5. **Backup-Lösungen implementieren**:
   - Stelle sicher, dass regelmäßige Backups der Exchange-Datenbanken und -Konfigurationen durchgeführt werden.
   - Teste die Wiederherstellungsverfahren, um die Integrität der Backups zu gewährleisten.

### Wartung und Updates

1. **Regelmäßige Updates**:
   - Halte den Exchange Server mit den neuesten Updates und Service Packs auf dem neuesten Stand.
   - Überwache die Microsoft-Website für Ankündigungen zu neuen Updates.

2. **Überwachung der Systemleistung**:
   - Überwache die Leistung des Exchange Servers regelmäßig.
   - Achte auf Speicherplatz, CPU-Auslastung und Arbeitsspeicherverbrauch.

3. **Protokollierung und Berichterstattung**:
   - Aktiviere die erforderlichen Protokolle für die Überwachung und Fehlersuche.
   - Erstelle regelmäßige Berichte über den Systemstatus und die Nutzung.

4. **Benutzer- und Berechtigungsmanagement**:
   - Verwalte Benutzerkonten und -berechtigungen regelmäßig.
   - Überprüfe die Zuweisung von Administratorrechten und anderen sensiblen Berechtigungen.

5. **Sicherheitsüberprüfungen**:
   - Führe regelmäßige Sicherheitsüberprüfungen durch, um potenzielle Schwachstellen zu identifizieren.
   - Überprüfe die Firewall- und Netzwerksicherheitseinstellungen.

## Fehlerbehebung

1. **Häufige Probleme und Lösungen**:
   - Liste häufiger Probleme und deren Lösungen auf.
   - Beispiel: Probleme mit der DNS-Konfiguration, die den E-Mail-Fluss beeinträchtigen.

2. **Protokolle zur Fehlerbehebung verwenden**:
   - Verwende die Ereignisanzeige und Exchange-spezifische Protokolle zur Fehlersuche.
   - Beispiel: Überprüfe das Setup-Log auf Fehler während der Installation.

3. **Microsoft Support und Community**:
   - Ziehe den Microsoft Support oder die TechCommunity zurate, wenn du auf Probleme stößt, die du nicht selbst beheben kannst.
   - Links: [Microsoft Support](https://support.microsoft.com) und [Exchange Server TechCommunity](https://techcommunity.microsoft.com/t5/exchange/ct-p/Exchange)

## Ressourcen

- [Microsoft Exchange Server-Dokumentation](https://docs.microsoft.com/de-de/exchange/)
- [Exchange Server Deployment Assistant](https://assistants.microsoft.com)
- [Exchange Server Supportmatrix](https://docs.microsoft.com/de-de/exchange/plan-and-deploy/supportability-matrix)
- [Exchange Server TechCommunity](https://techcommunity.microsoft.com/t5/exchange/ct-p/Exchange)
- [Exchange Server Health Checker](https://github.com/microsoft/CSS-Exchange/tree/main/HealthChecker)
