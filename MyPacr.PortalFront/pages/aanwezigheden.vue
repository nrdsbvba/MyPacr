<template>
  <div class="d-sm-flex justify-content-between col-12">
    <div class="col-lg-2"></div>
    <div class="col-lg-8">
      <div>
        <div class="row">
          <div class="col-12">
            <b-card
              border-variant="primary"
              header="Aanwezigheden"
              header-bg-variant="primary"
              header-text-variant="white"
              style="min-height: 20rem;"
            >
              <div>
                <b-list-group>
                  <b-list-group-item
                    v-for="user in userList"
                    v-bind:key="user.id"
                  >
                    <h5 class="mb-1">
                      {{ user.first_name }} {{ user.last_name }}
                    </h5>
                    <hr />
                    <p>
                      <b-button
                        variant="outline-primary"
                        @click="openAttendenceProfile(user)"
                        >Aanwezigheidsprofiel</b-button
                      >
                    </p>
                  </b-list-group-item>
                </b-list-group>
              </div>
            </b-card>
          </div>
        </div>
      </div>
    </div>
    <div class="col-lg-2"></div>
    <b-modal
      id="aanwezigheidsProfielModal"
      size="xl"
      title="AanwezigheidsProfiel"
    >
      <h5>
        Aanwezigheidsprofiel voor {{ selectedUser.first_name }}
        {{ selectedUser.last_name }}
      </h5>
      <p>Gelieve aan te duiden welke dagen de student blijft ineten.</p>
      <div v-if="selectedAttendenceProfile">
        <b-form-checkbox
          v-model="selectedAttendenceProfile.monday"
          name="check-button"
          switch
        >
          Maandag
        </b-form-checkbox>
        <b-form-checkbox
          v-model="selectedAttendenceProfile.tuesday"
          name="check-button"
          switch
        >
          Dinsdag
        </b-form-checkbox>
        <b-form-checkbox
          v-model="selectedAttendenceProfile.thursday"
          name="check-button"
          switch
        >
          Donderdag
        </b-form-checkbox>
        <b-form-checkbox
          v-model="selectedAttendenceProfile.friday"
          name="check-button"
          switch
        >
          Vrijdag
        </b-form-checkbox>
        <b-button
          variant="outline-primary"
          @click="saveAttendenceProfile()"
          class="float-right"
          >Aanwezigheidsprofiel Opslaan</b-button
        >
      </div>
      <template v-slot:modal-footer>
        <div class="w-100">
          <b-button
            variant="primary"
            size="sm"
            class="float-right"
            @click="closeAttendenceProfile()"
          >
            Sluiten
          </b-button>
        </div>
      </template>
    </b-modal>
  </div>
</template>

<script>
import tobackend from "~/plugins/2backend.js";

export default {
  middleware: "authenticated",
  data() {
    return {
      selectedAttendenceProfile: {},
      selectedUser: {}
    };
  },
  computed: {
    userList: {
      get() {
        var users = [];
        this.$store.state.loginObject.FullAccount.users.forEach(element => {
          users.push(element.users_id);
        });
        return users;
      },
      set() {}
    }
  },
  beforeMount: function() {
    tobackend.getAttendenceProfiles(this.$store).then(() => {
      //done
    });
  },
  methods: {
    openAttendenceProfile(user) {
      var attendenceProfile = this.$store.state.attendenceProfiles.find(x => {
        return x.user.id == user.id;
      });
      attendenceProfile = attendenceProfile
        ? {
            monday: attendenceProfile.monday,
            tuesday: attendenceProfile.tuesday,
            thursday: attendenceProfile.thursday,
            friday: attendenceProfile.friday,
            id: attendenceProfile.id,
            user: {
              id: user.id
            }
          }
        : {
            monday: false,
            tuesday: false,
            thursday: false,
            friday: false,
            user: {
              id: user.id
            }
          };

      this.selectedAttendenceProfile = attendenceProfile;
      this.selectedUser = user;

      this.$bvModal.show("aanwezigheidsProfielModal");
    },
    closeAttendenceProfile() {
      this.$bvModal.hide("aanwezigheidsProfielModal");
    },
    saveAttendenceProfile() {
      tobackend
        .saveAttendenceProfile(this.$store, this.selectedAttendenceProfile)
        .then(resp => {
          return tobackend.getAttendenceProfiles(this.$store);
        })
        .then(resp => {
          console.log("Saved AttendenceProfile");
        })
        .catch(err => {
          console.log(err);
        })
        .finally(() => {
          this.$bvModal.hide("aanwezigheidsProfielModal");
          this.selectedAttendenceProfile = {};
          this.selectedUser = {};
        });
    }
  }
};
</script>

<style>
</style>