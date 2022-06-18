<template lang="pug">
  v-app
    v-main#landing-page(:style='{background: `url(${backgroundImage})`}')     
      slot(name='content')
</template>
<script>
  import backgroundImage from 'images/backgrounds/retro-big.jpg'

  export default {
      data: function () {
        return {
          backgroundImage
        }
      }
  }
</script>
