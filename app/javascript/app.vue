<template>
  <Layout>
    <template v-slot:navbar>
      <v-app-bar-nav-icon @click="drawer = !drawer"></v-app-bar-nav-icon>
      <v-toolbar-title>Devent</v-toolbar-title>
      <v-spacer></v-spacer>
      <v-btn color="primary" to="/events">Events</v-btn>
    </template>
    <template v-slot:content>
      <div>
          <v-system-bar
            window
            dark
          >
            <v-icon>{{ titleIcon }}</v-icon>
            <span>{{ title }}</span>
            <v-spacer></v-spacer>
            <v-icon>mdi-refresh</v-icon>
            <v-icon>mdi-plus-circle</v-icon>
          </v-system-bar>
        </div>    
      <v-container>    
        <router-view @updateTitle="updateTitle"></router-view>
      </v-container>
    </template>
    <template v-slot:footer>
    </template>
  </Layout>
</template>

<script>
import Layout from './src/views/layouts/mainLayout'
import TheNav from './src/components/TheNav'

export default {
  data: function () {
    return {
      message: "Hello Vue!",
      group: 'group',
      drawer: false,
      title: 'Home',
      titleIcon: ''
    }
  },
  methods: {
    toggleSidebar: function (val) {
      this.drawer = val
    },
    updateTitle: function(title, icon) {
      this.title = title;
      this.titleIcon = icon;
    }
  },
  components: {
    Layout,
    TheNav
  }
}
</script>

<style>
   @import url('https://fonts.googleapis.com/css2?family=Press+Start+2P&display=swap');
  .v-toolbar__title {
     font-family: 'Press Start 2P', cursive !important;
  }
  html {
    overflow-y: auto !important
  }
</style>
