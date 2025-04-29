# Installationsanleitung: Microsoft Exchange Server 2019 CU15 (GUI-Installation)

## Inhaltsverzeichnis

- [Einleitung](#einleitung)  
- [Planung und Vorbereitung](#planung-und-vorbereitung)  
  - [Hardware- und Softwareanforderungen](#hardware--und-softwareanforderungen)  
  - [Wichtige Tools und Links](#wichtige-tools-und-links)  
  - [Vorbereitung der Testumgebung](#vorbereitung-der-testumgebung)  
  - [Vorbereitung des Active Directory](#vorbereitung-des-active-directory)  
- [Installationsvoraussetzungen](#installationsvoraussetzungen)  
  - [Windows Server Features installieren](#windows-server-features-installieren)  
  - [Zusätzliche Software installieren](#zusätzliche-software-installieren)  
  - [Hinweise zu Windows Server 2019 und winget](#hinweise-zu-windows-server-2019-und-winget)  
- [Exchange 2019 CU15 Installation (GUI)](#exchange-2019-cu15-installation-gui)  
  - [Setup starten und Updates suchen](#setup-starten-und-updates-suchen)  
  - [Lizenzbedingungen und Einstellungen](#lizenzbedingungen-und-einstellungen)  
  - [Rollen- und Installationstyp auswählen](#rollen--und-installationstyp-auswählen)  
  - [Installationspfad festlegen](#installationspfad-festlegen)  
  - [Exchange-Organisation einrichten](#exchange-organisation-einrichten)  
  - [Malware-Schutz Einstellungen](#malware-schutz-einstellungen)  
  - [Voraussetzungsprüfung](#voraussetzungsprüfung)  
  - [Installation durchführen und Abschluss](#installation-durchführen-und-abschluss)  
- [Aufgaben nach der Installation](#aufgaben-nach-der-installation)  
  - [Exchange-Dienste prüfen](#exchange-dienste-prüfen)  
  - [Exchange Admin Center (EAC) aufrufen](#exchange-admin-center-eac-aufrufen)  
  - [SSL-Zertifikate einrichten](#ssl-zertifikate-einrichten)  
  - [E-Mail-Fluss testen](#e-mail-fluss-testen)  
  - [Backup und Wartung](#backup-und-wartung)  
- [Häufige Probleme und Fehlerbehebung](#häufige-probleme-und-fehlerbehebung)  
- [Wichtige Ressourcen und Links](#wichtige-ressourcen-und-links)  

---

## Einleitung

In dieser Anleitung wird Schritt für Schritt erläutert, wie Microsoft Exchange Server 2019 CU15 auf einem Windows-Server über den grafischen Setup-Assistenten (GUI Installer) installiert wird. Es handelt sich um eine umfassende Installationsanleitung in deutscher Sprache, die sowohl die Vorbereitung der Umgebung als auch die eigentliche Installation und Nachbereitung abdeckt. Zielgruppe sind IT-Profis und Systemadministratoren, die eine Exchange 2019 CU15 Test- oder Produktivumgebung einrichten möchten. Wir beginnen mit einer Übersicht der Voraussetzungen sowie Planungsschritte. Anschließend folgt die detaillierte Anleitung zur Installation von Exchange Server 2019 CU15 mithilfe des GUI-Setup-Assistenten. Schließlich werden wichtige Nachkonfigurations-Schritte, häufige Probleme und deren Behebung sowie weiterführende Ressourcen erläutert.

> **Hinweis:** Exchange Server 2019 CU15 ist ein kumulatives Update, das alle vorherigen Updates enthält. Bei der Installation von Exchange wird immer die vollständige Version installiert, d.h. Sie müssen keine früheren CUs installieren, wenn Sie direkt mit CU15 beginnen. CU15 entspricht außerdem dem geplanten Wechsel zur neuen Exchange Server Subscription Edition (SE) – es ist das letzte CU für Exchange 2019 und bildet die Basis für Exchange SE.

---

## Planung und Vorbereitung

Eine sorgfältige Planung und Vorbereitung stellt sicher, dass die Exchange-Installation reibungslos verläuft. In diesem Abschnitt erfahren Sie die Mindestanforderungen und Empfehlungen, welche Vorarbeiten durchzuführen sind und welche Ressourcen hilfreich sind, bevor Sie mit der eigentlichen Installation beginnen.

### Hardware- und Softwareanforderungen

**Betriebssystem und Serverrolle**  
- Exchange Server 2019 CU15 kann auf Windows Server 2019 oder höher installiert werden (inkl. Windows Server 2022; Unterstützung für Windows Server 2025 wurde mit CU14/15 hinzugefügt).  
- Für die GUI-Installation muss der Server im Desktop Experience Modus installiert sein.  
- Der Exchange-Server sollte Mitglied einer Active-Directory-Domäne sein (kein Workgroup-Server).  
- Domänencontroller müssen eine unterstützte Windows Server-Version ausführen (z.B. Windows Server 2012 R2 oder höher).  
- Active Directory Gesamtstrukturfunktionsebene: mindestens Windows Server 2012 R2.  
- Kein Einsatz auf Domänencontrollern empfohlen.

**Hardware**  
- **CPU:** 64-Bit Prozessor (x64) von Intel oder AMD. Max. 2 physische Sockel empfohlen.  
- **RAM:**  
  - Mailbox-Server (Produktiv): ≥ 128 GB  
  - Edge-Transport-Server: ≥ 64 GB  
  - Testumgebung: ≥ 8 GB  
- **Festplattenspeicher:**  
  - Installationslaufwerk: ≥ 30 GB frei  
  - Systemlaufwerk (C:): ≥ 200 MB frei  
  - Transport-Warteschlangendatenbank-Laufwerk: ≥ 500 MB frei  
- **Netzwerk:** Gigabit-Ethernet oder höher, Zugriff auf Domänencontroller und ggf. Internet/SMTP-Relay.  
- **DNS:** Korrekte Namensauflösung, FQDN erreichbar.  
- **Clients:** Outlook 2013, 2016, 2019 und Microsoft 365 Apps for Enterprise.

### Wichtige Tools und Links

- **Exchange Deployment Assistant:** Interaktives Planungstool von Microsoft.  
- **Release Notes & KB:** CU15 KB 5042461 und Exchange Team Blog.  
- **Supportability Matrix:** Unterstützte Windows- und .NET-Versionen.  
- **Microsoft Learn:** Detaillierte Dokumentation zu Exchange 2019.

### Vorbereitung der Testumgebung

- Isolierte AD-Gesamtstruktur (separate Domäne/Forest).  
- Virtuelle Maschinen (Hyper-V, VMware) mit Snapshots.  
- Interner DNS-Server (Hosts-Datei oder DNS).  
- Optional Internetzugang für Updates/Hybrid.  
- Snapshot vor Installation.

### Vorbereitung des Active Directory

**Manuelle AD-Vorbereitung**  
```powershell
Setup.exe /PrepareSchema
Setup.exe /PrepareAD /OrganizationName:<Name>
Setup.exe /PrepareDomain


>### AD Vorbereitung durch Setup
>*   GUI-Setup führt Schema- und AD-Vorbereitung automatisch aus, wenn Rechte vorhanden sind (Schema-Admin, Enterprise-Admin).
    

---

Installationsvoraussetzungen
----------------------------

### Windows Server Features installieren

powershell

KopierenBearbeiten

`Install-WindowsFeature Server-Media-Foundation, NET-Framework-45-Features, `
RPC-over-HTTP-proxy, RSAT-Clustering, RSAT-Clustering-CmdInterface, `
RSAT-Clustering-Mgmt, RSAT-Clustering-PowerShell, WAS-Process-Model, `
Web-Asp-Net45, Web-Basic-Auth, Web-Client-Auth, Web-Digest-Auth, Web-Dir-Browsing, `
Web-Dyn-Compression, Web-Http-Errors, Web-Http-Logging, Web-Http-Redirect, `
Web-Http-Tracing, Web-ISAPI-Ext, Web-ISAPI-Filter, Web-Metabase, Web-Mgmt-Console, `
Web-Mgmt-Service, Web-Net-Ext45, Web-Request-Monitor, Web-Server, `
Web-Stat-Compression, Web-Static-Content, Web-Windows-Auth, Web-WMI, `
Windows-Identity-Foundation, RSAT-ADDS`

> Alternativ im Setup „Windows Server-Rollen und -Features automatisch installieren“ aktivieren.

### Zusätzliche Software installieren

*   **.NET Framework 4.8**
    
*   **Visual C++ Redistributable 2012 (x64)**
    
*   **Visual C++ Redistributable 2013 (x64)**
    
*   **IIS URL Rewrite Module 2.1 (x64)**
    
*   **Unified Communications Managed API (UCMA) 4.0**
    

### Hinweise zu Windows Server 2019 und winget

*   winget nicht standardmäßig auf Server 2019.
    
*   Kann über App-Installer aus Store nachinstalliert werden.
    
*   Praktisch für C++ Redistributables, IIS URL Rewrite, .NET.
    

* * *

Exchange 2019 CU15 Installation (GUI)
-------------------------------------

### Setup starten und Updates suchen

1.  Setup.exe als Administrator ausführen.
    
2.  **Check for Updates?**
    
    *   Internet verbunden: Updates für CU15 herunterladen.
        
    *   Ohne Internet: „Don’t check for updates right now“.
        
3.  Dateien werden kopiert (C:\Windows\Temp\ExchangeSetup).
    
4.  Einführung lesen → Weiter.
    

### Lizenzbedingungen und Einstellungen

1.  Lizenzvertrag akzeptieren → Weiter.
    
2.  **Empfohlene Einstellungen:**
    
    *   Use recommended settings → Diagnosedaten an Microsoft.
        
    *   Don’t use recommended settings → keine Datenübermittlung.
        

### Rollen- und Installationstyp auswählen

*   **Mailbox role** auswählen.
    
*   Optional: „Windows Server-Rollen und -Features automatisch installieren“.
    
*   (Edge Transport Role nur in Arbeitsgruppe verfügbar.)
    

### Installationspfad festlegen

*   Standard: `C:\Program Files\Microsoft\Exchange Server\V15`
    
*   Empfehlung: eigenes Volume (z.B. `E:\Exchange\V15`).
    
*   Ausreichender Speicher (≥ 30 GB + Reserve).
    

### Exchange-Organisation einrichten

*   Wenn keine Organisation existiert: Organisationsnamen festlegen (z.B. `ContosoExchange`).
    
*   Split-Permission Security Model in der Regel deaktiviert.
    

### Malware-Schutz Einstellungen

*   „Do you want to disable malware scanning?“
    
    *   **Nein** (Standard): Malware-Schutz aktiv.
        
    *   Ja: Deaktivierung.
        

### Voraussetzungsprüfung

*   Prüfpunkte: Windows-Komponenten, Softwarepakete, Speicherplatz, AD-Rechte, DNS, u.v.m.
    
*   Fehler beheben → Retry.
    
*   Warnungen (z.B. Installation auf DC) prüfen → Install.
    

### Installation durchführen und Abschluss

*   Fortschritt: Programmdaten kopieren, Dienste registrieren, AD-Schema, Mailbox-DB.
    
*   Log: `C:\ExchangeSetupLogs\ExchangeSetup.log`.
    
*   Nach Abschluss → Finish → Neustart falls gefordert.
    

* * *

Aufgaben nach der Installation
------------------------------

### Exchange-Dienste prüfen

powershell

KopierenBearbeiten

`Get-Service *Exchange* | Select Name, Status`

Wichtige Dienste:

*   MSExchangeADTopology
    
*   MSExchangeTransport
    
*   MSExchangeMailboxTransportSubmission/Delivery
    
*   MSExchangeIS
    
*   MSExchangeFrontendTransport
    
*   u.v.m.
    

### Exchange Admin Center (EAC) aufrufen

*   URL: `https://<servername>/ecp`
    
*   Browser-Warnung wegen Selbstsigniertem Zertifikat.
    
*   Anmeldung mit Exchange-Organisation-Admin.
    

### SSL-Zertifikate einrichten

1.  EAC: Server > Zertifikate > Anfrage-Assistent.
    
2.  CA-Anfrage erstellen und Zertifikat importieren.
    
3.  Dienste zuweisen: SMTP, IIS, POP/IMAP.
    
4.  Selbstsigniertes Zertifikat schrittweise aus Diensten entfernen.
    

### E-Mail-Fluss testen

*   **Intern:** OWA → E-Mail zwischen Testpostfächern.
    
*   **Extern ausgehend:** Send Connector konfigurieren, Testmail an extern.
    
*   **Extern eingehend:** MX-Eintrag, Firewall Port 25, Receive Connector.
    

### Backup und Wartung

*   **Backup:** VSS-Writer-fähige Software, Windows Server Backup mit Exchange-Plugin.
    
*   **Wartung:** Sicherheitsupdates monatlich, neue CUs halbjährlich.
    
*   **Monitoring:** Speicherplatz, Logs, Datenbankwartung, Circular Logging.
    
*   **Dokumentation:** Build-Version (z.B. 15.2.1118.x), Änderungen protokollieren.
    

* * *

Häufige Probleme und Fehlerbehebung
-----------------------------------

*   Fehlende Voraussetzungen → Installation abbrechen, Komponente installieren, Setup retry.
    
*   Ungenügende Rechte für Schema-Update → Konto mit Schema- und Enterprise-Admin.
    
*   Exchange-Dienste starten nicht → Event Viewer, IPv6, NetTCP-Portsharing.
    
*   ECP/OWA HTTP 500 → URL Rewrite Module, IIS-Konfiguration, `/ConfigureIIS`.
    
*   Zertifikatwarnungen in Outlook → Zertifikat-Namen/Autodiscover anpassen.
    
*   Keine ausgehende Mail → Send Connector erstellen.
    
*   Koexistenz mit Exchange 2013 nicht unterstützt → Exchange 2013 entfernen.
    
*   Abgebrochene Installation → Logs prüfen, `/mode:Recoverserver`.
    

* * *

Wichtige Ressourcen und Links
-----------------------------

*   **Microsoft Docs – Exchange 2019 Systemanforderungen**
    
*   **Microsoft Docs – Exchange 2019 Voraussetzungen**
    
*   **Microsoft Docs – GUI-Installation Mailbox-Serverrolle**
    
*   **Release Notes zu Exchange 2019 CU15 (KB5042461)**
    
*   **Exchange Deployment Assistant**
    
*   **Exchange Team Blog (TechCommunity)**
    
*   **Download Exchange 2019 CU15**
    
*   **UCMA 4.0 Runtime, Visual C++ Redistributables, IIS URL Rewrite**
    
*   **Microsoft Q&A Forum für Exchange**
    
*   **TechNet Foren**
    
*   **FrankysWeb Exchange Blog**
    

Viel Erfolg bei Ihrer Exchange-Bereitstellung!
