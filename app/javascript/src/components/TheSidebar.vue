<template lang="pug">
  v-navigation-drawer(v-model='drawerState' absolute temporary dark)
    v-list(nav dense)
      v-list-item-group(v-model='group' active-class='deep-orange--text text--accent-4')
        v-list-item(to="/events")
          v-list-item-icon
            v-icon mdi-calendar
          v-list-item-title Events
        v-list-item(to="/my-communities")
          v-list-item-icon
            v-icon mdi-account-group
          v-list-item-title Communities
</template>
<script>
    export default {
        data() {
            return {
                group: ''
            }
        },
        computed: {
        drawerState: {
          get () { return this.$store.getters.drawerState },
          set (v) { return this.$store.commit('toggleDrawerState', v) }
        }
      }
    }
</script>
