$('#game-create-form').on('ajax:success', function(event){

    let data = event.detail[2]
    data = JSON.parse(data.response)
    if(data.success === 'true') {
        $('#game-collection').html(data.template)
        // Set new game as current selected
        $('#game-collection select').val(data.game_id)
        $('#game-create-modal').modal('toggle')
    } else {
        console.log('Error')
        // show error partial in modal
        $('#error_container').html(data.template)
    }
});

$('#game-search').select2({
    ajax: {
      url: '/games/search',
      type: 'get',
      dataType: 'json',
      delay: 250,
      data: function (params) {
        let query = {
          search: params.term,
          type: 'public'
        }
        return query;
      },
      processResults: function (data, _params) {
        return {
          results: data
        };
    }
    }
  });