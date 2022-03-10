#MyPacr school kassa en registratie systeem

Het MyPacr software system werdt ontwikkeld door [NRDS](https://nrds.be/) in 2019. Door de corona-crisis is dit project stillgevallen. Om het geleverde werkt niet voor niets te hebben gedaan, is besloten dit open-source aan te bieden.

##Overzicht
Elke student krijgt een [smart-card](https://en.wikipedia.org/wiki/Smart_card). Tijdens de middag-pauze scant de student deze kaart om zijn/haar aanwezigheid te registreren. De student kan ook eten en drinken betalen met deze kaart. Het registreren en aankopen gebeurd via het Terminal project.

Om een saldo op te laden op de kaart kunnen de co-accounts(aka ouders/voogden) gebruik maken van de PortalFront. Dit portaal laat de co-accounts toe om alle kaarten(inclusief transacties) van al hun kinderen te zien. De co-accounts kunnen vervolgens op een of meerdere kaarten een saldo bijladen. De betaling gebeurd dan via [Mollie](https://www.mollie.com).

De Terminal communiceert direct met de de backend CMS [Directus](https://directus.io/).
PortalFront communiceert met het PortalAPI project, die op zijn beurt communiceert met de [Directus](https://directus.io/) CMS.


Andere features die aanwezig zijn:
- Ondersteuning voor stoeltjes geld
- Integratie met Smartschool
	- Automatisch gebruikers synchroniseren
	- **TODO**
- Automatisch mails naar co-accounts sturen wanneer een kaart een laag saldo heeft
- **TODO**

Voor meer informatie zie de [wiki](www.link-naar-de-wiki.com).


# 1. [PortalAPI](google.com)
Het portalAPI is de backend API van het systeem dat onder andere de link legt tussen de UI en de databank/CMS. Dit project is een [Node.js](https://nodejs.org) [Express](https://expressjs.com/) server.

## 2. PortalFront
De portalfront is de plaats waar de co-accounts(aka ouders/voogden) de kaarten van de gebruikers kunnen bijladen. Dit is gemaakt met [Nuxt](https://nuxtjs.org/), een [Vue](https://vuejs.org/) framework.

## 3. Terminal
Dit is de Point-of-Sale (POS) terminal, deze wordt bediend door een medewerker van de school. Deze geeft dan in wat de klant(aka de student) wilt kopen. Vervolgens scant de student zijn kaart, waardoor de transactie automatisch verloopt.

