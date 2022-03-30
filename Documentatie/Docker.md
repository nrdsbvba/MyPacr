# Docker

## Configuratie
Configureer PortalAPI zoals beschreven staat in de manuele [installatie](https://github.com/nrdsbvba/MyPacr/blob/main/Documentatie/Installation.md#2-portalapi-opzetten).

Voer het shell-script `docker_build_windows.bat` of `docker_build_linux.sh` uit afhankelijk van het platform.

> Deze scripts genereren de Docker images voor elk van de 3 projecten.

Bewerk in `docker-compose.yml` de nodige wachtwoorden, gebruikersnamen en andere omgevings variabelen.

Voer het commando `docker-compose up` uit om alles te starten.

De eerste keer kan dit even duren en sommige containers herstarten enkele keren. Dit is omdat de databank bezig is met het aanmaken van de nodige tabellen. Het init.sql bestand wordt uitgevoerd als de databank opstart en zorgt dat de nodige tabellen en startdata aanwezig is in de databank.

Surf naar [localhost:2000](localhost:2000) om het MyPacr portalfront te zien.
> login: example@mypacr.be:qwerty

Surf naar [localhost:3000](localhost:3000) om het MyPacr POS terminal te zien.
> login: admin@example.com:qwerty

Surf naar [localhost:8055](localhost:8055) om het directus admin dashboard te zien.
> login: admin@example.com:qwerty






