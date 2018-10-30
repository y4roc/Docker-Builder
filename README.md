# Docker Builder

## Installation

1. Vor dem ersten Start des Docker Containers löscht man die Ordner `/.git` damit man nicht ausversehen dieses Repository auf dem BitBucket-Server überschreibt.
2. Als nächstes bearbeitet man die Datei `/docker/.env.dist` und gibt den Projektname in der 2. Zeile an (`PROJECT=sn`). 
3. Anschließend wählt man eine PHP-Version in der man die 3. Zeile der selben Datei ändert (`PHP=7.1`).
4. Zuletzt werden die `/nginx/*.dist` Konfig-Dateien gelöscht, welche nicht benötigt werden.
5. Nun kann man das Project wie gewohnt mit `dcup` starten oder man führt die Date `/docker/docker.sh -l` aus.