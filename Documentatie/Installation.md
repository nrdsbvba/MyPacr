# Installation
## 1. Directus V8 installeren
> De outdated installatie guide van Directus kan [hier](https://v8.docs.directus.io/getting-started/installation.html) gevonden worden.

Installeer [MySQl](https://www.mysql.com/products/community/) **5.7+**, [PHP](https://www.php.net/downloads) **7.2+** en [Apache](https://httpd.apache.org/download.cgi) **2.4**.
Deze kunnen apart geinstalleerd worden of via [XAMP](https://www.apachefriends.org/download.html) versie **7.4.27**.
Hogere versies van XAMP werken **NIET**!



Download Directus V8 via het officiele archief op [github](https://github.com/directus/v8-archive/releases).

Extract het zip-bestand in een folder naar keuze.

In `./apache/conf/httpd.conf` pas de `DocumentRoot` aan om te wijzen naar `your-path/directus-8.8.1/public`. Pas ook de `<Directory ...>` lijn eronder aan naar het ditzelfde pad.

In de MySQL databank maak een nieuwe gebruiker aan en geef deze volledige rechten over een lege databank.

Start de apache server en surf naar [`http://localhost/admin/#/install`](http://localhost/admin/#/install).

Vul een super-admin wachtwoord in en klik op "Next".
Klik nogmaals op "Next".
Kies een project naam, en vul voor project token "_" in.
Kies een email en wachtwoord voor de admin gebruiker.
Vul in het volgende scherm de databank gegevens in. De databank user, password en name zijn de nieuw aangemaakte gebruiker en databank.

In de databank zijn nu enkele tabellen aangemaakt die starten met "directus_". Verwijder al deze tabellen behalve `directus_users` aangezien hier het net aangemaakte Admin account in zit.

Voer het `directus_setup.sql` bestand uit op de databank. Dit maakt alle nodige tabellen en relaties aan.

Surf naar `http://localhost/admin/#/login` en log in met het aangemaakte admin account.

Directus is nu klaar. Voor meer informatie over elke collection klik [hier](https://github.com/nrdsbvba/MyPacr/tree/main/Documentatie/Collections.md)

## 2. PortalAPi opzetten
Installeer [Node.js](https://nodejs.org/en/download/)

Download het PortalAPI project van [github](github.com/NRDS/MyPacr.PortalAPI).

In `PortalApi/config/` hernoem `example.json` naar `default.json`
Pas alle gegevens aan:
- **directusSettings**
	- url: De url waar directus zich bevindt.
	- projectUrl: Dit is het Directus project token, laat dit op '_' staan.
	- token: zie de [Static Tokens](https://v8.docs.directus.io/api/authentication.html#tokens) op Directus V8 Docs.
	- databaseSettings: De login en naam van de databank.
- **portalSettings**
	- De url van het portalFront en de API.
- **paymentProvider**
	- De api key van het [mollie](https://www.mollie.com/be) betaling systeem.
- **localizationSettings**
	- De taal en tijdzone.
- **passport**
	- ==TODO==
- **jwt**
	- ==TODO==
- **smartschoolAuthentication**
	- Login gegevens om te synchroniseren met smartschool.
- **reporting**
	- Wachtwoord om te rapporteren, NIET AANPASSEN. Zie [uitleg](www.link-naar-uitleg.com)
- **syncPassphrases**
	- Synchronisatie wachtwoorden, NIET AANPASSEN. Zie [uitleg](www.link-naar-uitleg.com)
- **mail**
	- Mail instellingen, vanwaar, en welk account worden automatische mails verstuurd.

Na alles correct te hebben ingesteld, voer `node ./src/server.js` uit om de api te starten.

Om in production te gaan: ==TODO==

## 3. PortalFront opzetten

Download het PortalFront project van [github](github.com/NRDS/MyPacr.PortalFront).

Maak een bestand aan in de root folder genaamd: `.env`
Plaats het volgende in dit bestand:
```
API_URL=http://localhost:80/api
API_PORTALFRONT=http://localhost:3000
SMARTSCHOOL_URL=schoolnaam.smartschool.be
SMARTSCHOOL_CLIENTID=123456abc
```
==PAS OP: Plaats geen spaties, voor of na de lijnen of de gelijkheids tekens.==
Alternatief: plaats deze gegevens in systeem-variabelen.
- API_URL is de url van het PortalAPI project
- API_PORTALFRONT is de url van het PortalFront project
- SMARTSCHOOL_URL is de url van smartschool
- SMARTSCHOOL_CLIENTID is de id van smartschool. ==TODO==

Zorg dat PortalAPI en Directus draaien en dat Terminal niet draait op deze PC.
Voer het commando `node ./node\_modules/nuxt/bin/nuxt.js` uit om het PortalFront project te starten.

Surf naar `localhost:3000/registreren`.
Maak een account aan en log in.

## 4. Terminal opzetten
Download het PortalFront project van [github](github.com/NRDS/MyPacr.Terminal).

Maak een bestand aan in de root folder genaamd: `.env`
Plaats het volgende in dit bestand:
```
DIRECTUS_API_URL=http://localhost
DIRECTUS_API_TOKEN="token"
```
==PAS OP: Plaats geen spaties, voor of na de lijnen of de gelijkheids tekens.==
Alternatief: plaats deze gegevens in systeem-variabelen
- DIRECTUS_API_URL is de url waar Directus draait.
- DIRECTUS_API_TOKEN is dezelfde [Static Token](https://v8.docs.directus.io/api/authentication.html#tokens) ingevuld in het PortalAPI-config bestand.

Zorg dat PortalAPI en Directus draaien en dat PortalFront niet draait op deze PC.
Voer het commando `node ./node\_modules/nuxt/bin/nuxt.js` uit om het Terminal project te starten.

Surf naar `localhost:3000/`.
==TODO== registreer een Terminal

## 5. Omnikey 5427 CK Smart-card readers
De aangerade smart-card readers zijn de [Omnikey 5427 CK ](https://www.hidglobal.com/products/readers/omnikey/5427).

Aan 1 terminal kunnen 2 van deze lezers verbonden worden. Een voor het afrekenen van bestellingen, en een andere die enkel aanwezigheid registreert. Als de code die de lezer geeft eindigt op een `;`, wordt deze enkel gebruikt om aanwezigheid te registreren.

Om de Omnikey 5427 CK in te stellen om elke lezing te eindigen met een `;` moet eerst de driver geinstaleerd worden, deze is [hier](https://www.hidglobal.com/drivers/28595) te vinden.

Verbind de card-reader via USB en surf naar `http://192.168.63.99`
Klik op het tweede tab `Keyboard wedge` en vul `;` in bij `Card Out Event Keystroke`.

![image](./CardReader_1.PNG)
Ga naar het voorlaatste tab `System Config`, klik op `Apply changes` en vervolgens op `Store changes`.
![image](./CardReader_2.PNG)
De lezer geeft nu na elke lezing ook een `;`.

## 6. Mollie betalingsysteem
Surf naar [Mollie.com](https://www.mollie.com/be) en maak een account aan.

Er is onmiddelijk een test api key beschikbaar. Om een live api key te krijgen moet je eerst je account verder activeren.

Deze api key kan je invullen in de settings van het PortalAPI project.
