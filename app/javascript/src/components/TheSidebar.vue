<template lang="pug">
  v-navigation-drawer(v-model='value' absolute temporary dark)
    v-list(nav dense)
      v-list-item-group(v-model='group' active-class='deep-orange--text text--accent-4')
        v-list-item(to="/events")
          v-list-item-icon
            v-icon mdi-calendar
          v-list-item-title Events
        v-list-item(to="/communities")
          v-list-item-icon
            v-icon mdi-account-group
          v-list-item-title Communities
</template>
<script>
    export default {
        props: {
            value: {
              type: Boolean,
              required: true
            }
        },
        data() {
            return {
                group: ''
            }
        }
    }
</script>
