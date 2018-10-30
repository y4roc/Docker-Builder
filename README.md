# Docker Builder

## Installation

Vor dem ersten Start des Docker Containers löscht man die Ordner `/.git` damit man nicht ausversehen dieses Repository auf dem BitBucket-Server überschreibt.

Als nächstes bearbeitet man die Datei `/docker/.env.dist` und gibt den Projektname in der 2. Zeile an (`PROJECT="sn"`). Anschließend wählt man eine PHP-Version in der man die 3. Zeile der selben Datei ändert (`PHP="7.2"`).

Zuletzt werde die `/nginx/*.dist` Konfig-Datei gelöscht, welche nicht benötigt werden.

Nun kann man das Project wie gewohnt mit `dcup` starten oder man führt die Date `/docker/docker.sh -l` aus.