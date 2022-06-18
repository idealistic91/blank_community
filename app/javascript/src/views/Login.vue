<template lang='pug'>
  v-row(justify='center')
    v-dialog(v-model='dialog' persistent max-width='700' dark)
      //- template(v-slot:activator='{ on, attrs }')
      //-   v-btn(color='primary' dark v-bind='attrs' v-on='on')
      //-     | Open Dialog
      v-card
        v-card-title.text-h3
          | Sign in
        v-card-text
          v-form(ref='form' v-model='valid' lazy-validation)
            v-text-field(v-model='email' :rules='emailRules' label='Email' required filled)
            v-text-field(v-model='password' :append-icon="showPw ? 'mdi-eye' : 'mdi-eye-off'" :rules='[passwordRules.required, passwordRules.min]' :type="showPw ? 'text' : 'password'" name='input-10-1' label='Passwort' hint='' counter='' @click:append='showPw = !showPw' filled)

        v-card-actions
          v-spacer
          v-btn(color='green darken-1' text @click='login')
            | Login
          v-btn(color='green darken-1' text @click='dialog = false')
            | Agree

</template>
<script>

//import sessionService from '../services/session'

export default ({
  data: function () {
    return {
      showPw: false,
      valid: true,
      email: '',
      emailRules: [
        v => !!v || 'E-mail is required',
        v => /.+@.+\..+/.test(v) || 'E-mail must be valid',
      ],
      password: '',
      passwordRules: {
        required: v => !!v || 'Passwort fehlt',
        min: v => v.length >= 8 || 'Min 8 characters',
      },
      dialog: true
    }
  },
  methods: {
    login: function() {
      this.$store.commit('toggleLogin')
    }
  }
})
</script>
