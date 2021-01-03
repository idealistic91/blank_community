$('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
    $(e.relatedTarget).addClass('text-light')
    $(e.target).removeClass('text-light');
})

function assignEvents() {
    $('.badge-pill').on('mouseover', function(){
        $(this).find($('.role-destroy')).show();
    });
    $('.badge-pill').on('mouseout', function(){
        $(this).find($('.role-destroy')).hide();
    });
}

assignEvents();

$(document).on('ajax:success', function(event){
    data = event.detail[2]
    data = JSON.parse(data.response)
    $(`#discord_role_${data.dc_role_id}`).html(data.element)
    assignEvents();
});

