<template lang='pug'>
  v-row(justify='center')
    v-dialog(v-model='dialog' persistent max-width='700' dark)
      //- template(v-slot:activator='{ on, attrs }')
      //-   v-btn(color='primary' dark v-bind='attrs' v-on='on')
      //-     | Open Dialog
      v-card
        v-card-title.text-h5
          | Willkommen. Wähle deine Community aus.
        v-card-text
          | Let Google help apps determine location. This means sending anonymous location data to Google, even when no apps are running.
        v-card-actions
          v-spacer
          v-btn(color='green darken-1' text @click='dialog = false')
            | Disagree
          v-btn(color='green darken-1' text @click='dialog = false')
            | Agree

</template>
<script>
export default ({
  data: function () {
    return {
      dialog: true
    }
  },
})
</script>
