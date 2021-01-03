import Poll from "../poll/main";

$('#join-leave-button').on('ajax:success', function(event){
    let data = event.detail[2]
    data = JSON.parse(data.response)
    if(data.success){
        $('#participants').html(data.list)
        $('#join-leave-btn').html(data.button)
        $('#participants-tab').tab('show')
    }
});

let poll = new Poll('#tool-modal-body')
