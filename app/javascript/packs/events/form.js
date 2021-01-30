$('#game-create-form').on('ajax:success', function(event){
    let data = event.detail[2]
    data = JSON.parse(data.response)
    if(data.success === 'true') {
        $('#game-collection').html(data.template)
        $('#game-collection select').val(data.game_id)
        $('#game-create-modal').modal('toggle')
    } else {
        console.log('Error')
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

let token = $('meta[name=csrf-token]').attr('content');
let gameFieldContainer = $('#game-fields-container');

function assignDeleteEvents() {
  $('.delete-game').on('click', function(){
    let action = $('#main-container').data('action')
    let igdb_id = $(this).data('igdb-id')
    let gameFields = $(`#game-fields-${igdb_id}`)
    console.log(`Action: ${action}, id: ${igdb_id}, fields: ${gameFields.length}`)
    if(action === 'new') {
      gameFields.remove();
    } else {
      gameFields.hide();
      $(`#game_${igdb_id}_destroy`).prop('disabled', false)
      //$(`#game_${igdb_id}_destroy`).val(1)
    }
  })
}

function requestGame (params) {
  let ajax = $.ajax({
    method: "POST",
    dataType: "json",
    url: "/games/get_igdb_game",
    data: params,
    success: (data) => {
      if($(`#game-fields-${params.igdb_id}`).length === 1) {
        $(`#game-fields-${params.igdb_id}`).show();
        $(`#game_${igdb_id}_destroy`).prop('disabled', true)
      } else {
        gameFieldContainer.append(data.fields)
      }
      assignDeleteEvents();
    }
  });
  return ajax
}

$('#game-search').on('select2:select', function (e) {
  let count = $('.game-fields').length
  let game = e.params.data
  requestGame({ authenticity_token: token, igdb_id: game.id, count: count })
});

assignDeleteEvents();
