<template>
  <div class="d-sm-flex justify-content-between col-12">
    <div class="col-lg-2"></div>
    <div class="col-lg-8">
      <div>
        <div class="row">
          <div class="col-12">
            <b-card
              border-variant="primary"
              header="MyPacr Pos Online Portaal"
              header-bg-variant="primary"
              header-text-variant="white"
              style="min-height: 20rem;"
            >
              <div>
                <p>
                  Met deze applicatie kan u de kaarten van de studenten opladen,
                  transacties en verbruik consulteren en aangeven welke dagen de
                  studenten op school zullen blijven eten.
                </p>
                <p>
                  Deze Applicatie is nog in actieve ontwikkeling en er zullen
                  dan ook de komende weken meer functionaliteiten voorzien
                  worden.
                </p>
                <p>
                  Klik op de links in de zijbalk om naar de bijhorende pagina te
                  gaan.
                </p>
                <b-alert show
                  >Opgelet: Om uw kaart op te laden wordt er een dossierskost
                  aangerekend van 0,20 euro door de school, deze kost wordt
                  teruggestort bij betaling met overschrijving</b-alert
                >
              </div>
            </b-card>
          </div>
        </div>
      </div>
    </div>
    <div class="col-lg-2"></div>
  </div>
</template>

<script>
export default {
  middleware: "authenticated"
};
</script>

<style>
</style>