// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()

import 'bootstrap'



//require("channels")

import JQuery, { data } from 'jquery';
window.$ = window.JQuery = JQuery;

import "../src/style.scss";
import "../src/community.scss";

import 'select2'
import 'select2/dist/css/select2.css'

import { library, dom } from '@fortawesome/fontawesome-svg-core'
import { fas } from '@fortawesome/free-solid-svg-icons'
import { faTwitter } from '@fortawesome/free-brands-svg-icons'
import Poll from '../packs/poll/main'

library.add(fas, faTwitter)

dom.watch()

$(document).on('turbolinks:load', function(){
    let data = $('#main-container').data();
    let controller = data.controller
    $(`li.${controller}-nav`).addClass('active')
    tabNavStyling();
    $(function () {
        $('[data-toggle="tooltip"]').tooltip()
      })
});


function showSpinner() {
    $('#kitt').css('display', 'block');
}

function hideSpinner() {
    setTimeout(function(){
        $('#kitt').css('display', 'none');
    }, 500)
}

function tabNavStyling() {
    $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
        $(e.relatedTarget).addClass('text-light')
        $(e.target).removeClass('text-light');
    })
}

$(document).on('ajax:success', function(event){
    let data = event.detail[2]
    data = JSON.parse(data.response)
    if(data.flash_box) {
        let alertContainer = $('#alert-container')
        alertContainer.html(data.flash_box)
        setTimeout(()=> {
            $('.alert').fadeOut()
        }, 3000)
    }
    hideSpinner()
});

$(document).on('ajax:before', function(){
    showSpinner()
});

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
//const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)/* eslint no-console: 0 */
// Run this example by adding <%= javascript_pack_tag 'hello_vue' %> (and
// <%= stylesheet_pack_tag 'hello_vue' %> if you have styles in your component)
// to the head of your layout file,
// like app/views/layouts/application.html.erb.
// All it does is render <div>Hello Vue</div> at the bottom of the page.

import VueResource  from 'vue-resource';
import Vue from 'vue'
import Vuetify from 'vuetify'
import App from '../app.vue'
Vue.use(VueResource);
Vue.use(Vuetify)

document.addEventListener('DOMContentLoaded', () => {
    const app = new Vue({
        render: h => h(App)
    }).$mount()
    document.body.appendChild(app.$el)
})


// The above code uses Vue without the compiler, which means you cannot
// use Vue to target elements in your existing html templates. You would
// need to always use single file components.
// To be able to target elements in your existing html/erb templates,
// comment out the above code and uncomment the below
// Add <%= javascript_pack_tag 'hello_vue' %> to your layout
// Then add this markup to your html template:
//
// <div id='hello'>
//   {{message}}
//   <app></app>
// </div>


// import Vue from 'vue/dist/vue.esm'
// import App from '../app.vue'
//
// document.addEventListener('DOMContentLoaded', () => {
//   const app = new Vue({
//     el: '#hello',
//     data: {
//       message: "Can you say hello?"
//     },
//     components: { App }
//   })
// })
//
//
//
// If the project is using turbolinks, install 'vue-turbolinks':
//
// yarn add vue-turbolinks
//
// Then uncomment the code block below:
//
// import TurbolinksAdapter from 'vue-turbolinks'
// import Vue from 'vue/dist/vue.esm'
// import App from '../app.vue'
//
// Vue.use(TurbolinksAdapter)
//
// document.addEventListener('turbolinks:load', () => {
//   const app = new Vue({
//     el: '#hello',
//     data: () => {
//       return {
//         message: "Can you say hello?"
//       }
//     },
//     components: { App }
//   })
// })