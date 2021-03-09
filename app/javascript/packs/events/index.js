let eventContainer = $('#events-container');
let communityId = eventContainer.data('community')
let loadingElement = $(`<h5>Loading ... </h5>`)
$('.tabs[data-toggle="tab"]').on('shown.bs.tab', function (e) {
    // change url
    
    //e.target // newly activated tab
    //e.relatedTarget // previous active tab
    // get scope from data rel
    let token = $('meta[name=csrf-token]').attr('content');
    let scope = $(this).data('scope')
    let tab = $(`#${scope}`)
    $.ajax({
        method: "POST",
        url: `/communities/${communityId}/events/fetch`,
        data: { authenticity_token: token, scope: scope},
        beforeSend: function() {
            tab.html(loadingElement)
        }
    })
        .done(function( data ) {
            let parsedData = JSON.parse(data)
            let item = parsedData.result;
            let location = document.location
            tab.html(item)
            let newUrl = `${location.pathname}?scope=${scope}`
            history.pushState(new XMLSerializer().serializeToString(document), document.title, newUrl);
        });
})

