<template lang="pug">
  Layout
    template(v-slot:sidebar)
      Sidebar
    template(v-slot:navbar)
      v-app-bar-nav-icon(@click='toggleSidebar')
      v-toolbar-title Devent
      v-spacer
    template(v-slot:content)
      div
        v-system-bar(window dark height='50')
          v-icon {{ titleIcon }}
          span {{ title }}
          v-spacer
          div(class='button-group')
            v-btn(dark small)   
                v-icon mdi-refresh
            v-btn(dark small)
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
      title: 'Home',
      titleIcon: ''
    }
  },
  methods: {
    toggleSidebar: function () {
      return this.$store.commit('toggleDrawerState', !this.drawerState)
    },
    updateTitle: function(title, icon) {
      this.title = title;
      this.titleIcon = icon;
    }
  },
  computed: {
    drawerState: function() {
      return this.$store.getters.drawerState
    }
  },
  components: {
    Layout,
    Sidebar
  }
}
</script>

<style lang='scss'>
   @import url('https://fonts.googleapis.com/css2?family=Press+Start+2P&display=swap');
  
  .button-group > .v-btn {
    margin-left: 5px;
    margin-right: 5px;
  }

  .v-toolbar__title {
     font-family: 'Press Start 2P', cursive !important;
  }
  html {
    overflow-y: auto !important
  }
</style>
