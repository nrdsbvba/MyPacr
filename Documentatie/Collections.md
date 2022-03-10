# Collections
- **Absences**: Deze collection bevat alle afwezigheden. Als een student niet aanwezig is op een dag, terwijl deze wel verwacht was, wordt dat hier ingevuld.
- **Admin settings**: **TODO**
- **Admin Smartschool Import**: **TODO**
- **Articlecategories**: De type van een article, gebruikt om o.a. te filteren in de terminal.
- **Articles**: Alle artikels die te koop zijn via de terminal.
- **Attendence Exceptions**: Hier kunnen uitzonderingen in komen voor 1 student (bijvoorbeeld afwezig door ziekte/stage/..) of voor de hele school (bijvoorbeeld vakanties).
- **Attendenceprofile**: Hier kan voor elke student een profiel gemaakt worden, voor welke dagen van de week deze verwacht aanwezig te zijn.
- **Attendences**: Als een student aanwezig is, wordt dat in deze collectie geregistreerd.
- **Campuses**: Een school kan meerdere campusen hebben, dat wordt hier bijgehouden.
- **Card Leasing Type**: Het type van een cardleasing. Het type bepaalt onder andere de prijslevel en of er aanwezigheids/stoeltjesgeld betaald moet worden.
- **Cardleasings**: Elke uitgeleende kaart is hier terug te vinden, alsook de gebruiker, het saldo op de kaart, en wanneer de kaart actief is.
- **Cards**: Een lijst van alle bekende kaartjes.
- **Classgroup**: **TODO** Alle klassen, deze worden gelinkt aan de studenten om makkelijker te kunnen zoeken, deze (kunnen) automatisch via smartschool geimporteerd worden.
- **Coaccounts**: Hier staan alle co-accounts, dit zijn de accounts van de ouders/voogden/... . Met deze accounts kan in het portalFront worden ingelogd en de kaarten van de gelinkte studenten/users worden opgeladen.
- **Controle Exceptions**: **TODO**
- **Controleresults**: **TODO**[^]
- **Controles**: **TODO**
- **Eventregistration**: **TODO**
- **Events**: **TODO**
- **Eventtype**: **TODO**
- **Globalsettings**: Instellingen van het project, zie onderaan voor meer informatie
- **Online Payment**: Elke betaling die gebeurd komt hier terecht. Een betaling kan meerdere top-offs bevatten in geval een coaccount meerdere studenten onder zich heeft.
- **Online Topoff**: Elke oplading van een individuele kaart-leasing.
- **Orderitems**: Elk artikel dat in een order zit wordt hier opgeslagen.
- **Orders**: Bevat de bestellingen die gemaakt worden bij de terminals, elk bestelling bevat 1 of meerdere orderitems.
- **Pricelevels**: Bevat de types prijslevels, dit kan gebruikt worden om andere prijsen aan te reken voor bijvoorbeeld leerkrachten en studenten.
- **Prices**: De prijzen van elk artikel voor een bepaald pricelevel.
- **Reports**: De SQL-query die uitgevoerd moet worden om een rapport van te maken.
- **Terminalfuncties**: De functies die een terminal kan uitvoeren. Zo kan een terminal bijvoorbeeld worden ingesteld om enkel kassa te doen, en geen kaarten koppelen.
- **Terminal**: **TODO** Een lijst van alle Terminals, en hun Cookielink.
- **Transactions**: De betaling (met het kaartje) van elk order komt hier terecht.
- **Usergroups**: Het type van gebruiker, en welk pricelevel deze gebruikt.
- **Users**: Een lijst van alle gebruikers in het systeem.
- **Vat Levels**: De verschillende niveau's van belastingen.
- **Z Configuration**: De instellingen voor smartschool, cronJobs en messageProvider.

### Globalsettings:
- **Cookie expiration**: **TODO**
- **Use vat**: Moet er BTW worden aangerekend?
- **Entry fee**: Het stoeltjes geld, de hoeveelheid dat een student betaald om aanwezig te zijn.
- **Entry fee Return after Buy**: Wordt het stoeltjes geld terugbetaald bij een aankoop?
- **Default Cardleasing Type**: Wat soort van cardleasing moet standaard worden toegepast?
- **Default Pricelevel**: Welk pricelevel moet worden gebruikt als er geen gespecifieerd is?
- **Handling Cost**: Hoeveel wordt er aangerekend om een kaart bij te laden?
- **Usergroups Allowed to Login into Portal**: **TODO**
- **Low Balance Threshold**: **TODO** Bij welke saldo moet een waarschuwingsmail gestuurd worden?
- **Auth Provider Settings**: Welke authenticaties mogen gebruikt worden?





























