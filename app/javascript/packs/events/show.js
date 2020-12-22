$(document).on('ajax:success', function(event){
    let data = event.detail[2]
    data = JSON.parse(data.response)
    $('#participants').html(data.list)
    $('#join-leave-btn').html(data.button)
    $('#participants-tab').tab('show')
});