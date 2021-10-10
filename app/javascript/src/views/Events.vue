<template>
    <div id="events-index">
        <h1>Events</h1>
        <div id="event-container" v-if="!loading">
            <div id="events" v-for="event in events" :key="event.id">
                {{ event.title }}
            </div>
        </div>
        <div v-else>
            Loading ...
        </div>
    </div>
</template>
<script>
 export default {
     data() {
         return {
            loading: true,
            events: []
         }
     },
     methods: {
         getEvents: function(){
             this.events = [{
                id: 216,
                title: "Daddeln mit den Boys",
                date: "2021-05-14",
                description: "dwadawd",
                created_at: "2021-05-02 13:42:12.771956000 +0200",
                updated_at: "2021-05-02 13:42:12.771956000 +0200",
                creator: "Bob",
                slots: 8,
                start_at: "2021-05-14 13:41:00.000000000 +0200",
                ends_at: "2021-05-14 13:56:00.000000000 +0200",
                community_id: 22,
                state: "ready",
                created_by: 86
            }]
            setTimeout(() =>{
                this.loading = false
            }, 5000)
            // Get events from api, later from axios request (api branch needs to be merged)
         }
     },
     mounted(){
         this.getEvents()
     }
 }
</script>
