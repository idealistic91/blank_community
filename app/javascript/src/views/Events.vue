<template lang="pug">
    #events-index
        #event-container(v-if='!loading')
            .event-scope(v-for="scope in events" v-show="scope.items.length > 0" :id="scope.label")
                .scope-display
                    span.text-subtitle-1
                        | {{ scope.label }}
                        b  ({{ scope.items.length }})
                    hr
                v-row
                    v-col(md="3").event(v-for='event in scope.items' :key='event.id')
                        Event(:eventId='event')
        v-overlay(:value='true' v-else)
            v-progress-circular(indeterminate size='64')
</template>
<style>
    .scope-display {
        margin-bottom: 20px;
        display: flex;
    }
    .scope-display span {
        padding-left: 10px;
        padding-right: 10px;
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
    .event-scope {
        margin-bottom: 20px;
    }
</style>
<script>

import Event from '../components/event'

 export default {
     data() {
         return {
            loading: true,
            events: [],
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
