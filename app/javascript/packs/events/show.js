// $('#event-bar a').on('click', function(){
//     $(this).removeClass('text-light');
//     let tabs = $('#event-bar a');
//     tabs.splice($.inArray(this, tabs), 1);
//     tabs.each(function() {
//         $(this).addClass('text-light')
//     });
// });

$('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
    $(e.relatedTarget).addClass('text-light')
    $(e.target).removeClass('text-light');
  })

$(document).on('ajax:success', function(event){
    data = event.detail[2]
    data = JSON.parse(data.response)
    $('#participants').html(data.list)
    $('#join-leave-btn').html(data.button)
    $('#participants-tab').tab('show')
});