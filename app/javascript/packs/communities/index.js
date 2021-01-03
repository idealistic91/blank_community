let contentContainer =  $('#discord-communities')
let loadingElement = $(`<h5>Loading ... </h5>`)
$('#my_communities-tab[data-toggle="tab"]').on('shown.bs.tab', function (e) {
    //e.target // newly activated tab
    //e.relatedTarget // previous active tab
    let token = $('meta[name=csrf-token]').attr('content');
    $.ajax({
        method: "POST",
        url: "/communities/fetch",
        data: { authenticity_token: token },
        beforeSend: function() {
            contentContainer.append(loadingElement)
        }
    })
    .done(function( data ) {
        loadingElement.remove();
        let parsedData = JSON.parse(data)
        let items = parsedData.result;
        items.forEach((item)=>{
            let id = $(item).attr('id')
            if($(`#${id}`).length === 0) {
                contentContainer.append(item)
            }
        })
    });
})