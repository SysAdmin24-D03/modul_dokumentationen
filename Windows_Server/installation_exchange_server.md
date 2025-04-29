## **Exchange Server Planung und Bereitstellung**

### **Inhaltsverzeichnis**

1. [Einleitung](#einleitung)
2. [Planungsphase](#planungsphase)
   1. [Dokumentation und Tools](#dokumentation-und-tools)
   2. [Testumgebung](#testumgebung)
   3. [Systemanforderungen](#systemanforderungen)
3. [Vorbereitung](#vorbereitung)
   1. [Voraussetzungen installieren](#voraussetzungen-installieren)
   2. [Active Directory Vorbereitung (optional)](#active-directory-vorbereitung-optional)
4. [Installation mit dem GUI-Installer](#installation-mit-dem-gui-installer)
   1. [Setup-Medium bereitstellen](#setup-medium-bereitstellen)
   2. [Setup-Assistent starten](#setup-assistent-starten)
   3. [Wizard-Schritte im Detail](#wizard-schritte-im-detail)
   4. [Rollenauswahl und Pfad-Konfiguration](#rollenauswahl-und-pfad-konfiguration)
   5. [Readiness Checks & Troubleshooting](#readiness-checks--troubleshooting)
5. [Nach der Installation](#nach-der-installation)
   1. [Erste Konfigurationsschritte im EAC](#erste-konfigurationsschritte-im-eac)
   2. [Post-Installation-Aufgaben](#post-installation-aufgaben)
6. [Wartung und Updates](#wartung-und-updates)
7. [Fehlerbehebung im GUI-Context](#fehlerbehebung-im-gui-context)
8. [Ressourcen](#ressourcen)

---

## **Einleitung**

Diese Anleitung beschreibt Schritt für Schritt die Bereitstellung eines Microsoft Exchange Servers **per GUI-Installer**. Ziel ist es, sowohl die Vorbereitung als auch den eigentlichen Wizard-Durchlauf so zu strukturieren, dass selbst Einsteiger sicher und effizient zum Ziel kommen.

---

## **Planungsphase**

### **Dokumentation und Tools**

* **Exchange Server Release Notes**  
   Lies vorab die aktuellen Release Notes für deine Version (2016/2019/2022/2025), um Breaking Changes und Hotfix-Empfehlungen zu kennen.

* **Exchange Deployment Assistant**  
   Mit dem Web-Tool ([https://assistants.microsoft.com](https://assistants.microsoft.com/)) erstellst du einen maßgeschneiderten Fragenkatalog, der dein Setup-Szenario abfragt und alle notwendigen Schritte ausgibt.

### **Testumgebung**

* **Isolierte Umgebung aufsetzen**  
   Verwende Hyper-V oder VMware, um eine Kopie deiner geplanten Produktionsumgebung nachzubauen.

* **Gleiche Versionen verwenden**  
   Domain Controller, DNS, Zertifikats-CA und Client-VMs sollten exakt dieselben Versionen nutzen wie später in der Produktion.

### **Systemanforderungen**

* **Hardware**

  * CPU: 64-Bit, mindestens 4 Kerne

  * RAM: 16 GB (Produktivserver), 8 GB (Test)

  * SSD empfohlen für Datenbanken

* **Software**

  * Windows Server in passender Version (2019/2022/2025)

  * Aktuelle .NET Frameworks und Windows-Patches

  * Active Directory-Schemafunktionsebene ≥ Windows Server 2012 R2

---

## **Vorbereitung**

### **Voraussetzungen installieren**

1. **PowerShell als Administrator öffnen**

2. **Windows Features per GUI oder PowerShell**

   * **GUI-Variante**: „Server Manager → Rollen und Features hinzufügen“ → Web-Server (IIS) und alle Unterrollen auswählen, RSAT-Tools, .NET Framework 4.8.

**PowerShell-Variante**:

 Install-WindowsFeature NET-Framework-45-Features, Web-Server, Web-Asp-Net45, RSAT-ADDS, ...

*   
3. **Externe Komponenten**

   * **IIS URL Rewrite**: MSI-Paket herunterladen und per Doppelklick installieren.

   * **Visual C++ Redistributables** (2012, 2013, 2015+) via Winget oder manuell.

### **Active Directory Vorbereitung (optional)**

**Hinweis:** Der GUI-Installer führt `/PrepareSchema`, `/PrepareAD` und `/PrepareDomain` automatisch aus, wenn nötig. Nur vorab manuell durchführen, wenn du volle Kontrolle willst.

---

## **Installation mit dem GUI-Installer**

### **Setup-Medium bereitstellen**

* ISO mounten oder DVD einlegen.

* Prüfen, ob das Konto lokale Admin-Rechte hat und die PowerShell-ExecutionPolicy keine Skripte blockiert.

### **Setup-Assistent starten**

![Setup-Assistent starten](images/setup-wizard-start.png)

Der erste Dialog des Exchange-Setup-Assistenten begrüßt Sie und zeigt eine Übersicht der nächsten Schritte. Klicken Sie auf **Weiter**, um zur Update-Prüfung zu gelangen.

**Setup.exe doppelklicken** oder in PowerShell:

```ps
 cd D:\\Setup\\  
.\\Setup.exe
```
 
> **GUI-Willkommensbildschirm:** „Weitere Informationen zu Installation und Updates“ ggf. überspringen.

### **Wizard-Schritte im Detail**

1. **Updates suchen**

   ![Updates suchen](images/check-for-updates.png)

   Dieser Dialog fragt, ob das Setup online nach den neuesten Cumulative Updates suchen soll. Nutzen Sie **Mit dem Internet verbinden und nach Updates suchen**, wenn der Server Internetzugang hat.

2. **Lizenzbedingungen**

   ![Lizenzbedingungen](images/license-agreement.png)

   Lesen Sie den Endbenutzer-Lizenzvertrag und aktivieren Sie die Checkbox **Ich akzeptiere die Bedingungen des Lizenzvertrags**, um fortzufahren.

3. **Bereitstellungsoptionen**

   ![Bereitstellungsoptionen](images/deployment-options.png)

   Wählen Sie hier den Installationsmodus. Die **Standard**-Option installiert typische Komponenten, während **Benutzerdefiniert** erweiterte Einstellungen erlaubt (in den meisten Fällen reicht Standard).

### **Rollenauswahl und Pfad-Konfiguration**

![Rollenauswahl und Pfad-Konfiguration](images/role-path-selection.png)

In diesem Schritt wählen Sie die **Mailbox-Serverrolle** aus und legen das Verzeichnis für Programmdaten (z.B. C:\Program Files) und Datenbanken (z.B. D:\ExchangeDatabases) fest.

### **Readiness Checks & Troubleshooting**

![Readiness Checks](images/readiness-checks.png)

Exchange führt nun eine detaillierte Prüfung aller Voraussetzungen durch. Rote Fehler müssen behoben werden, bevor Sie auf **Installieren** klicken können.

---

## **Nach der Installation**

### **Erste Konfigurationsschritte im EAC**

1. **Exchange Admin Center (EAC)** öffnen:

   * URL: `https://<Hostname>/ecp`

   * Anmeldung mit Domain-Admin ➔ empfiehlt Service-Account mit geringerem Recht für den Alltag.

2. **Akzeptierte Domänen**

   * Definiere interne und externe SMTP-Domänen unter „Nachrichtenfluss → Akzeptierte Domänen“.

3. **E-Mail-Adressrichtlinien**

   * Richte Standard-Adressmuster (z. B. Vorname.Nachname@firma.de) ein.

### **Post-Installation-Aufgaben**

* **Zertifikate binden**

  * Unter „Server → Zertifikate“ neues SAN-Zertifikat importieren, IIS-Bindings und SMTP-Dienste erweitern.

* **Postfachdatenbanken**

  * Erstelle DB1 und DB2 auf getrennten Volumes, passe Wiederherstellungs­optionen an.

* **Backups**

  * Exchange-aware Backup-Lösung konfigurieren und Test-Wiederherstellung durchführen.

---

## **Wartung und Updates**

* **Cumulative Updates**

  * Immer zuerst in der Testumgebung installieren.

  * Im EAC unter „Server → Updates“ lässt sich meist sofort erkennen, ob neue CU verfügbar sind.

* **Health Checker**

  * Nutze [Exchange HealthChecker Script](https://github.com/microsoft/CSS-Exchange/tree/main/HealthChecker) für automatisierte Prüfberichte.

---

## **Fehlerbehebung im GUI-Context**

* **Setup-Logdateien**

  * Pfad: `C:\ExchangeSetupLogs\`

  * Suche in `ExchangeSetup.log` nach Schlüsselwort „Error“ und zeige Kontext im Editor.

* **EAC-Fehler**

  * Häufige Ursache: Zertifikat fehlt oder DNS falsch. Prüfe Export-/Import­pfade des Zertifikats.

* **Dienste starten nicht**

  * Dienste snap-in öffnen, auf „Starttyp“ achten, bei „Manuell“ auf „Automatisch“ setzen.

---

## **Ressourcen**

* **Offizielle Doku**: [https://docs.microsoft.com/de-de/exchange/](https://docs.microsoft.com/de-de/exchange/)

* **Deployment Assistant**: [https://assistants.microsoft.com](https://assistants.microsoft.com/)

* **Health Checker**: [https://github.com/microsoft/CSS-Exchange/tree/main/HealthChecker](https://github.com/microsoft/CSS-Exchange/tree/main/HealthChecker)

* **TechCommunity**: [https://techcommunity.microsoft.com/t5/exchange/ct-p/Exchange](https://techcommunity.microsoft.com/t5/exchange/ct-p/Exchange)
