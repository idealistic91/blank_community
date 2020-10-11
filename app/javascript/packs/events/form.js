flatpickr('#picker')

$(document).on('ajax:success', function(event){
    let data = event.detail[2]
    data = JSON.parse(data.response)
    if(data.success === 'true') {
        $('#game-collection').html(data.template)
        // Set new game as current selected
        $('#game-collection select').val(data.game_id)
    } else {
        console.log('Error')
        // show error partial in modal
        $('#error_container').html(data.template)
    };
});