<template lang="pug">
  Layout
    template(v-slot:sidebar)
      Sidebar(v-model='drawer')
    template(v-slot:navbar)
      v-app-bar-nav-icon(@click='drawer = !drawer')
      v-toolbar-title Devent
      v-spacer
    template(v-slot:content)
      div
        v-system-bar(window dark)
          v-icon {{ titleIcon }}
          span {{ title }}
          v-spacer
          v-icon mdi-refresh
          v-icon mdi-plus-circle
      v-container
        router-view(@updateTitle='updateTitle')
</template>

<script>
import Layout from './src/views/layouts/mainLayout'
import Sidebar from './src/components/TheSidebar'

export default {
  data: function () {
    return {
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
    Sidebar
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
