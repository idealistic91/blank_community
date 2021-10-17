<template>
    <v-app>
      <v-app-bar app color="primary" id="nav-bar">
        <slot name="navbar">

        </slot>
      </v-app-bar>
      <v-main>
        <v-container>
            <v-card id="content-card">
                <slot name="content"></slot>
            </v-card>
        </v-container>
      </v-main>
      <!-- <v-footer>
          <slot name="footer"></slot>
      </v-footer> -->
    </v-app>
</template>
<script>
    export default {
      
    }
</script>
