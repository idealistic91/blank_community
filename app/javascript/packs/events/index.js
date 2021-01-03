let eventContainer = $('#events-container');
let pastTab = $('#past')
let communityId = eventContainer.data('community')
let loadingElement = $(`<h5>Loading ... </h5>`)
$('#past-tab[data-toggle="tab"]').on('shown.bs.tab', function (e) {
    //e.target // newly activated tab
    //e.relatedTarget // previous active tab
    let token = $('meta[name=csrf-token]').attr('content');

    $.ajax({
        method: "POST",
        url: `/communities/${communityId}/events/fetch`,
        data: { authenticity_token: token },
        beforeSend: function() {
            pastTab.html(loadingElement)
        }
    })
        .done(function( data ) {
            let parsedData = JSON.parse(data)
            let item = parsedData.result;
            pastTab.html(item)
        });
})