<template lang="pug">
  Layout(v-if='loggedIn')
    template(v-slot:sidebar)
      Sidebar
    template(v-slot:navbar)
      v-app-bar-nav-icon(@click='toggleSidebar')
      v-toolbar-title Devent
      v-spacer
      v-icon(@click='logout') mdi-login
     
    template(v-slot:content)
      div
        v-system-bar(window dark height='50')
          v-icon {{ titleIcon }}
          span {{ title }}
          v-spacer
          div(class='button-group')
            v-btn(dark small @click='refresh')   
                v-icon mdi-refresh
            v-btn(dark small)
              v-icon mdi-plus
      v-container
        router-view(@updateTitle='updateTitle')
  LandingPage(v-else)
    template(v-slot:content)
      router-view(@updateTitle='updateTitle')
</template>

<script>
import Layout from './src/views/layouts/mainLayout'
import LandingPage from './src/views/layouts/landingLayout'
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
    logout: function () {
      this.$store.commit('logout')
    },
    refresh: function () {
      this.$router.go()
    },
    updateTitle: function(title, icon) {
      this.title = title;
      this.titleIcon = icon;
    }
  },
  computed: {
    drawerState: function() {
      return this.$store.getters.drawerState
    },
    loggedIn: function() {
      return this.$store.getters.loggedIn
    }
  },
  mounted(){
    if(!this.loggedIn) {
      this.$router.push({path: '/login'})
    }
  },
  watch: {
    loggedIn(newVal, _oldVal) {
      if(!newVal) { this.$router.push({path: '/login'}) }
    }
  },
  components: {
    Layout,
    LandingPage,
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
