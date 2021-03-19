<template>
  <div id="app">
    <ul>
      <li v-for="(event, idx) in events" :key="idx">
       <button :title="event.title" v-on:click="deleteEvent">
          <b>{{ event.title }}</b>
       </button>
      </li>
    </ul>
  </div>
</template>

<script>
export default {
  data: function () {
    return {
      events: {},
      url: '/communities/21/events.json'
    }
  },
  mounted: function () {
      // GET /someUrl
      this.$http.get(this.url).then(response => {
        // get body data
        this.events = response.body;
      }, response => {
       alert('alles scheiße')
      });
  },
  methods:{
    deleteEvent(event){
      console.log(event)
    }
  },
  watch: {
    events: function () { 
      
      }
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
