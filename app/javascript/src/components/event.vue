<template lang="pug">
  div
    v-card.mx-auto.event-card(max-width='400' max-height='400' v-if='!loading')
      v-img.white--text.align-end(height='200px' gradient='to top right, rgba(100,115,201,.33), rgba(25,32,72,.7)' :src='firstGame.cover')
        .date
          span.day 12
          span.month Aug
          span.year 2016
        v-card-title
          | {{ event.title }}
      v-card-subtitle.pb-0
        | Bob
        v-btn.join-btn(fab dark small color='primary')
          v-icon(dark)
            | mdi-dots-vertical
      v-card-text.text--primary 
        | {{ event.description }}
      v-card-actions
        v-btn(color='orange' text)
          | Share
        v-btn(color='orange' text)
          | Explore
    v-card.event-card(max-width='400' max-height='400' v-else)
      v-img.white--text.align-end(height='200px')
        template(v-slot:placeholder)
          v-row.fill-height.ma-0(align='center' justify='center')
            v-progress-circular(indeterminate color='lighten-5')

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