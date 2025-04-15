**Ziel:** Ein Skript namens `interactive.sh` erstellen, das einen Befehl vom Benutzer entgegennimmt, diesen ausführt und die Ausgabe anzeigt. Dieses Skript soll nur von Benutzern ausgeführt werden können, die Mitglied der Gruppe "junior" sind.

**Voraussetzungen:**
* Du hast Zugriff auf ein Terminal auf deinem Ubuntu 24.04 System.
* Du hast `sudo`-Rechte (Administratorrechte), um Gruppen zu erstellen, Dateiberechtigungen zu ändern und Benutzer zu Gruppen hinzuzufügen.

**Schritt 1: Das Skript `interactive.sh` erstellen**

1.  **Öffne ein Terminal:** Drücke `Strg+Alt+T` oder suche im Anwendungsmenü nach "Terminal".
2.  **Wechsle in ein temporäres Verzeichnis (optional, aber empfohlen):** Du kannst das Skript zuerst in deinem Heimatverzeichnis erstellen.
    ```bash
    cd ~
    ```
3.  **Erstelle die Skriptdatei:** Verwende einen Texteditor wie `nano`, um die Datei zu erstellen und den Inhalt einzufügen.
    ```bash
    nano interactive.sh
    ```
4.  **Füge den Skriptinhalt ein:** Kopiere den folgenden Text und füge ihn in den `nano`-Editor ein (Rechtsklick -> Einfügen oder `Strg+Shift+V` im Terminal).

    ```bash
    #!/usr/bin/env bash
    read -p "Welchen Befehl möchtest Du ausführen?: " cmd
    echo -e "\nDie Ausgabe Deines Befehls lautet\n$($cmd)"
    ```

5.  **Speichere und schließe die Datei:**
    * Drücke `Strg+O` (speichern), bestätige den Dateinamen (`interactive.sh`) mit `Enter`.
    * Drücke `Strg+X` (schließen).

**Schritt 2: Das Skript ausführbar machen**

1.  **Setze die Ausführungsberechtigung:** Damit du (und später andere) das Skript starten kannst, muss es als ausführbar markiert werden.
    ```bash
    chmod +x interactive.sh
    ```
    Jetzt hat der Besitzer der Datei (also du) die Berechtigung, das Skript auszuführen.

**Schritt 3: Das Skript systemweit verfügbar machen**

Damit das Skript von überall im System aufgerufen werden kann (ohne den Pfad dorthin angeben zu müssen), muss es in einem Verzeichnis liegen, das in der `PATH`-Umgebungsvariable aufgeführt ist. `/usr/local/bin` ist dafür ein üblicher Ort.

1.  **Verschiebe das Skript nach `/usr/local/bin`:** Da dies ein Systemverzeichnis ist, benötigst du `sudo`.
    ```bash
    sudo mv interactive.sh /usr/local/bin/
    ```
2.  **Überprüfe den Speicherort (optional):**
    ```bash
    ls -l /usr/local/bin/interactive.sh
    ```
    Du solltest das Skript dort sehen.

**Schritt 4: Die Gruppe "junior" erstellen**

Wenn die Gruppe "junior", der du den Zugriff erlauben möchtest, noch nicht existiert, musst du sie erstellen.

1.  **Erstelle die Gruppe:**
    ```bash
    sudo addgroup junior
    ```
    Wenn die Gruppe bereits existiert, erhältst du eine entsprechende Meldung, was in Ordnung ist.

**Schritt 5: Dateibesitzer (Gruppe) und Berechtigungen anpassen**

Jetzt ändern wir die Gruppenzugehörigkeit der Skriptdatei auf "junior" und passen die Berechtigungen so an, dass nur der Besitzer (standardmäßig `root`, da mit `sudo mv` verschoben) und Mitglieder der Gruppe "junior" das Skript ausführen können.

1.  **Ändere die Gruppenzugehörigkeit der Datei:**
    ```bash
    sudo chgrp junior /usr/local/bin/interactive.sh
    ```
2.  **Passe die Dateiberechtigungen an:**
    * **Wichtiger Hinweis:** Der ursprüngliche Text schlägt `chmod 074 interactive.sh` vor (entspricht `---rwxr--`). Dies würde jedoch *Anderen* Lese-, Schreib- und Ausführrechte geben, aber der Gruppe nur Leserechte, was dem Ziel widerspricht, nur Gruppenmitgliedern die Ausführung zu erlauben.
    * Wir verwenden stattdessen `chmod 750`, was dem Besitzer (root) Lese-, Schreib- und Ausführrechte (`rwx`) und der Gruppe "junior" Lese- und Ausführrechte (`r-x`) gibt. Andere Benutzer haben keine Rechte (`---`). Dies passt genau zum Ziel.
    ```bash
    sudo chmod 750 /usr/local/bin/interactive.sh
    ```
3.  **Überprüfe die Berechtigungen und den Besitzer (optional):**
    ```bash
    ls -l /usr/local/bin/interactive.sh
    ```
    Die Ausgabe sollte etwa so aussehen: `-rwxr-x--- 1 root junior [Datum] /usr/local/bin/interactive.sh`. Der Besitzer ist `root`, die Gruppe ist `junior`, und die Berechtigungen sind `rwxr-x---`.

**Schritt 6: Deinen Benutzer zur Gruppe "junior" hinzufügen**

Damit du (oder ein anderer Benutzer) das Skript ausführen kannst, musst du Mitglied der Gruppe "junior" sein.

1.  **Füge deinen Benutzer zur Gruppe hinzu:** Ersetze `DEIN_BENUTZERNAME` durch deinen tatsächlichen Linux-Benutzernamen. Wenn du dir unsicher bist, gib `whoami` ein.
    ```bash
    sudo adduser DEIN_BENUTZERNAME junior
    ```
    Du wirst eine Bestätigungsmeldung sehen.

**Schritt 7: Änderungen wirksam machen und testen**

Die neue Gruppenmitgliedschaft wird erst bei der nächsten Anmeldung wirksam.

1.  **Abmelden und wieder anmelden:** Melde dich von deiner grafischen Sitzung ab und wieder an, oder schließe das Terminal und öffne ein neues, wenn du nur in der Konsole arbeitest. Ein Neustart funktioniert natürlich auch.
2.  **Überprüfe deine Gruppenmitgliedschaft:** Öffne ein neues Terminal und gib `id` ein. In der Liste der Gruppen (`groups=...`) sollte nun auch `junior` aufgeführt sein.
    ```bash
    id
    ```
3.  **Teste das Skript:** Da sich das Skript nun in `/usr/local/bin` befindet, kannst du es von jedem Verzeichnis aus aufrufen, indem du einfach seinen Namen eingibst.
    ```bash
    interactive.sh
    ```
4.  **Gib einen Befehl ein:** Wenn das Skript fragt "Welchen Befehl möchtest Du ausführen?:", gib einen einfachen Befehl ein, z. B. `pwd` (zeigt das aktuelle Verzeichnis) oder `ls -l` (listet Dateien auf) und drücke `Enter`.
    ```
    Welchen Befehl möchtest Du ausführen?: pwd
    ```
5.  **Überprüfe die Ausgabe:** Das Skript sollte dir die Ausgabe des eingegebenen Befehls anzeigen.
    ```
    Die Ausgabe Deines Befehls lautet

    /home/dein_benutzername
    ```
6.  **Teste als anderer Benutzer (optional):** Wenn du einen anderen Benutzer auf dem System hast, der *nicht* Mitglied der Gruppe `junior` ist, versuche, das Skript als dieser Benutzer auszuführen. Du solltest eine Fehlermeldung wie "Permission denied" (Zugriff verweigert) erhalten.

Damit hast du das Skript erfolgreich erstellt und den Zugriff auf Mitglieder der Gruppe "junior" beschränkt!

---

**Zusätzliches Skript: System-Informationen**

Du hast auch ein zweites Skript erwähnt, das Systeminformationen anzeigt. Hier ist, wie du es erstellen und ausführen kannst:

1.  **Öffne ein Terminal.**
2.  **Erstelle die Skriptdatei (z.B. in deinem Heimatverzeichnis):**
    ```bash
    cd ~
    nano system_info.sh
    ```
3.  **Füge den Skriptinhalt ein:**
    ```bash
    #!/bin/bash
    echo "System-Infos"
    echo "------------"
    echo "Hostname: $(hostname)"
    echo "Uptime: $(uptime)"
    # Hinweis: vm_stat ist auf Linux nicht standardmäßig verfügbar (stammt von macOS).
    # Wir verwenden stattdessen 'free -h' für die Speichernutzung.
    echo "Memory Usage:"
    free -h
    echo "Disk Usage:"
    df -h
    ```
    *Änderung:* Ich habe `vm_stat` durch `free -h` ersetzt, da `vm_stat` unter Ubuntu normalerweise nicht verfügbar ist und `free -h` eine ähnliche Funktion (Anzeige der Speichernutzung) erfüllt.

4.  **Speichere und schließe die Datei:** `Strg+O`, `Enter`, `Strg+X`.
5.  **Mache das Skript ausführbar:**
    ```bash
    chmod +x system_info.sh
    ```
6.  **Führe das Skript aus:** Da es sich in deinem aktuellen Verzeichnis befindet, musst du `./` voranstellen.
    ```bash
    ./system_info.sh
    ```
    Du siehst nun die Systeminformationen (Hostname, Uptime, Speicher- und Festplattennutzung) im Terminal ausgegeben. Wenn du dieses Skript ebenfalls systemweit verfügbar machen möchtest, kannst du es wie in Schritt 3 beschrieben nach `/usr/local/bin` verschieben.
