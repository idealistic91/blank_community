let gameSearchField = $('#game-search')

gameSearchField.select2({
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

let gameFieldContainer = $('#game-fields-container');
let action = $('#main-container').data('action');
let token = $('meta[name=csrf-token]').attr('content');

function assignDeleteEvents() {
  $('.delete-game').on('click', function(){
    let igdb_id = $(this).data('igdb-id')
    let gameFields = $(`#game-fields-${igdb_id}`)
    if(action === 'new') {
      gameFields.remove();
    } else {
      gameFields.hide();
      $(`#game_${igdb_id}_destroy`).prop('disabled', false)
    }
  })
}

function getGameAndAddToDom (params) {
  $.ajax({
    method: "POST",
    dataType: "json",
    url: "/games/get_igdb_game",
    data: params,
    success: (data) => {
      gameSearchField.prop('disabled', false);
      $('#game-loading').hide();
      if($(`#game-fields-${params.igdb_id}`).length === 1) {
        $(`#game-fields-${params.igdb_id}`).show();
        $(`#game_${igdb_id}_destroy`).prop('disabled', true)
      } else {
        gameFieldContainer.append(data.fields)
      }
      assignDeleteEvents();
    },
    beforeSend: () => {
      gameSearchField.prop('disabled', true);
      $('#game-loading').show();
    }
  });
}

$('#game-search').on('select2:select', function (e) {
  let count = $('.game-fields').length
  let game = e.params.data
  getGameAndAddToDom({ authenticity_token: token, igdb_id: game.id, count: count })
});

assignDeleteEvents();
