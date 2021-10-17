<template>
   <div>
    <v-card
        class="mx-auto event-card"
        max-width="400"
        max-height="400"
        v-if="!loading"
    >
    <v-img
      class="white--text align-end"
      height="200px"
      gradient="to top right, rgba(100,115,201,.33), rgba(25,32,72,.7)"
      :src="firstGame.cover"
    >
        <div class="date">
            <span class="day">12</span>
            <span class="month">Aug</span>
            <span class="year">2016</span>
        </div>
      <v-card-title>
          {{ event.title }}
      </v-card-title>
    </v-img>
    <v-card-subtitle class="pb-0">
        Bob
         <v-btn
            class="join-btn"
            fab
            dark
            small
            color="primary"
         >
            <v-icon dark>
               mdi-dots-vertical
            </v-icon>
        </v-btn>   
    </v-card-subtitle>

    <v-card-text class="text--primary">
        {{ event.description }}
    </v-card-text>

    <v-card-actions>
      <v-btn
        color="orange"
        text
      >
        Share
      </v-btn>

      <v-btn
        color="orange"
        text
      >
        Explore
      </v-btn>
    </v-card-actions>
  </v-card>
  <v-card
        max-width="400"
        max-height="400"
        class="event-card"
  v-else>
         <v-img
            class="white--text align-end"
            height="200px"
        >
            <template v-slot:placeholder>
                <v-row
                class="fill-height ma-0"
                align="center"
                justify="center"
                >
                    <v-progress-circular
                        indeterminate
                        color="lighten-5"
                    ></v-progress-circular>
                </v-row>
            </template>
        </v-img>
  </v-card>
</div>
     
</template>
<style scoped>
    .bottom-gradient {
        background-image: linear-gradient(to top, rgba(0, 0, 0, 0.4) 0%, transparent 72px);
    }
    .join-btn {
        margin-top: -45px;
        margin-left: 80%;
    }
    .event-card {
        background-color: black;
    }
    .date {
        position: absolute;
        top: 0;
        right: 0;
        margin-right: 20px;
        background-color: #ff6f00;
        color: white;
        padding: 0.8em;
    }
    .date span {
      display: block;
      text-align: center;
    }
    .day {
      font-weight: 700;
      font-size: 24px;
      text-shadow: 2px 3px 2px rgba(black, 0.18);
    }
    .month {
      text-transform: uppercase;
    }
    .month,
    .year {
      font-size: 12px;
    }
  
</style>
<script>

  export default {
      data() {
          return {
            loading: true,
            event: undefined,
            games: []
          }
      },
      methods: {
          getEvent: function () {
            let self = this;
            this.$http.get(`/communities/22/events/${self.eventId}?format=json`).then(function(res){
                console.log(res)
                self.event = res.data.event
                self.games = res.data.games
                 setTimeout(() =>{
                    self.loading = false
                }, 2000)
            })
          },
      },
    props: {
        eventId: {
            type: Number,
            required: true
        }
    },
    computed: {
        firstGame: function() {
            if(this.games.length > 0) { return this.games[0] }
        }
    },
    mounted: function () {
        this.getEvent();
    }
  }
</script>