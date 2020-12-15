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

import { library, dom } from '@fortawesome/fontawesome-svg-core'
import { fas } from '@fortawesome/free-solid-svg-icons'
import { faTwitter } from '@fortawesome/free-brands-svg-icons'

library.add(fas, faTwitter)

dom.watch()


$(document).on('turbolinks:load', function(){
    let data = $('#main-container').data();
    let controller = data.controller
    let view = data.view
    $(`li.${controller}-nav`).addClass('active')
});

function showSpinner() {
    $('#kitt').css('display', 'block');
};
function hideSpinner() {
    setTimeout(function(){
        $('#kitt').css('display', 'none');
    }, 500)
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
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)