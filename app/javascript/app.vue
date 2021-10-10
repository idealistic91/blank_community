<template>
  <Layout>
    <template v-slot:navbar>
      <v-app-bar-nav-icon @click="drawer = !drawer"></v-app-bar-nav-icon>
      <v-toolbar-title>Devent</v-toolbar-title>
      <v-spacer></v-spacer>
      <v-btn color="primary" to="/events">Events</v-btn>
    </template>
    <template v-slot:content>
      <v-container>
        <router-view></router-view>
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
      drawer: false
    }
  },
  methods: {
    toggleSidebar: function (val) {
      this.drawer = val
    },
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
</style>
