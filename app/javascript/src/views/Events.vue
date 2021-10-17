<template>
    <div id="events-index">
        <div id="event-container" v-if="!loading">
            <div class="scope-display">
                <span class="text-subtitle-1">Next week <b>({{ count }})</b></span>
                <hr/>
            </div>
            <v-row>
                <v-col class="event" v-for="event in events" :key="event.id">
                    <Event :eventId="event"/>
                </v-col>
                </v-row>
        </div>
        <v-overlay :value="true" v-else>
            <v-progress-circular
                indeterminate
                size="64"
            ></v-progress-circular>
        </v-overlay>
    </div>
</template>
<style>
    .scope-display {
        margin-bottom: 20px;
        display: flex;
    }
    .scope-display span {
        background: #36393F;
        z-index: 2;
    }
    .scope-display hr {
        margin-right: 20px;
        margin-left: 20px;
        margin-top: 14px;
        width: 100%;
        z-index: 1;
        right: 0;
        position: absolute;
    }
    .text--primary {
        color: white;
    }
</style>
<script>

import Event from '../components/event'

 export default {
     data() {
         return {
            loading: true,
            events: [],
            count: 0,
         }
     },
     components: {
        Event
     },
     methods: {
         getEvents: function(){

            setTimeout(() =>{
                this.loading = false
            }, 2000)
            let self = this
            this.$http.get('/communities/22/events?format=json').then(function(res){
                self.events = res.data.events
                self.count = self.events.length
            })
            // Get events from api, later from axios request (api branch needs to be merged)
         }
     },
     mounted(){
         this.$emit('updateTitle', 'Events', 'mdi-calendar-heart')
         this.getEvents()
     }
 }
</script>
