<template lang="pug">
  v-app
    slot(name='sidebar')
    v-app-bar#nav-bar(app color='primary')
      slot(name='navbar')
    v-main
      v-container
        v-card#content-card
          slot(name='content')
</template>