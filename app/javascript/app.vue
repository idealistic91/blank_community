<template>
  <Layout>
    <template v-slot:navbar>
      <v-app-bar-nav-icon @click="drawer = !drawer"></v-app-bar-nav-icon>
      <v-toolbar-title>Devent</v-toolbar-title>
      <v-spacer></v-spacer>
      <v-btn color="primary" to="/events">Events</v-btn>
    </template>
    <template v-slot:content>
      <router-view></router-view>
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

<style scoped>

</style>
