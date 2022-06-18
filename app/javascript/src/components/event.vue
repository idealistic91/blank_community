<template lang="pug">
  div
    v-card.mx-auto.event-card(max-height='400' v-if='!loading' :style='{height: `${height}px`}')
      v-img.white--text.align-end(height='200px' :style='coverStyle'
          @mouseover="gamePreviewView(true)"
          @mouseleave="gamePreviewView(false)"
          :gradient='gradient'
          :src='firstGame.cover')
        .date(v-if='!hover')
          span.day    {{ day }}
          span.month  {{ month }}
          span.year   {{ year }}
        v-card-title(v-if='!hover')
          | {{ event.title }}
        v-card-title(v-else)
          | {{ '' }}
      v-card-subtitle.pb-0
        | {{ event.title }}
        v-btn.join-btn(fab dark small color='primary')
          v-icon(dark)
            | mdi-dots-vertical
      v-card-text.text--primary 
        | {{ event.description }}
      //- v-card-actions
      //-   v-btn(color='primary')
      //-     v-icon
      //-       | mdi-share-circle
      //-   v-btn(color="primary")
      //-     v-icon
      //-       | mdi-play
    v-card.event-card(max-width='400' max-height='400' v-else)
      v-img.white--text.align-end(height='200px')
        template(v-slot:placeholder)
          v-row.fill-height.ma-0(align='center' justify='center')
            v-progress-circular(indeterminate color='lighten-5')

</template>
<style scoped>
    .v-card__text {
      height: 90px;
      overflow: hidden;
    }
    .v-card__actions {
      position: absolute;
      padding-left: 16px;
      bottom: 10px;
    }
    .bottom-gradient {
        background-image: linear-gradient(to top, rgba(0, 0, 0, 0.4) 0%, transparent 72px);
    }
    .join-btn {
      position: absolute;
      right: 30px;
      top: 180px;
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
  import { getEvent } from '../services/eventService'
  import moment from 'moment'
  
  export default {
      data() {
          return {
            defaultGradient: 'to top right, rgba(100,115,201,.80), rgba(25,32,72,.7)',
            gradient: 'to top right, rgba(100,115,201,.80), rgba(25,32,72,.7)',
            coverStyle: '',
            hover: false,
            loading: true,
            event: undefined,
            games: []
          }
      },
      methods: {
          gamePreviewView: function (onOff = true) {
            this.hover = onOff
            if(this.hover) {
              this.coverStyle = 'cursor: pointer;'
              this.gradient = ''
            } else {
              this.gradient = this.defaultGradient
              this.coverStyle = ''
            }
          },
          getEvent: function () {          
            getEvent(22, this.eventId).then(response => {
              this.event = response.event
              this.games = response.games
              this.event.description = 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.'

              this.loading = false
            })
          },
      },
    props: {
        eventId: {
            type: Number,
            required: true
        },
        height: {
          type: Number,
          default: 400
        }
    },
    computed: {
        firstGame: function() {
            if(this.games.length > 0) { return this.games[0] }
        },
        day: function() {
            if(this.event !== undefined && !this.loading) {
              return moment(this.event.date).format('D')
            }
        },
        month: function() {
          if(this.event !== undefined && !this.loading) {
              return moment(this.event.date).format('MMM')
            }
        },
         year: function() {
          if(this.event !== undefined && !this.loading) {
              return moment(this.event.date).format('YY')
            }
        }
    },
    mounted: function () {
        this.getEvent();
    }
  }
</script>