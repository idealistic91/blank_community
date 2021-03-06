import Poll from "../poll/main";

let token = $('meta[name=csrf-token]').attr('content')
let eventId = $('#event-container').data('eventId')
let communityId = $('#event-container').data('communityId')
let spinner = $('<div class="lds-dual-ring"></div>')
let teamId = undefined

function assignEventListeners() {
    $('#edit-team-btn').on('click', function(){
        teamId = $(this).data('teamId')
        $(`#team-${teamId}`).attr('type', 'text')
        $(`#team-name-controls-${teamId}`).css('display', 'block')
        $(this).hide();
        $('#team-unassign-captain').hide();
        $(`#team-header-${teamId}`).hide();
    })

    $('#team-name-abort-btn').on('click', function(){
        $(`#team-${teamId}`).attr('type', 'hidden')
        $(`#team-name-controls-${teamId}`).css('display', 'none')
        $('#edit-team-btn').show()
        $(`#team-header-${teamId}`).show()
        $('#team-unassign-captain').show()
    })
    
    $("#team-name-save-btn").on('click', function(){
        let path = $(this).data('path')
        let teamId = $(this).data('teamId')
        let name = $(`#team-${teamId}`).val()
        let controlsWrapper = $(`#team-controls-wrapper-${teamId}`)
        $.ajax({
            method: "POST",
            dataType: "json",
            url: path,
            data: {community_id: communityId, id: eventId, team_id: teamId, authenticity_token: token, team: { name: name }},
            success: (data) => {
                if(data.success){
                    $('#participants').html(data.list)
                }
                assignEventListeners();
            },
            beforeSend: () => {
                controlsWrapper.addClass('d-flex')
                controlsWrapper.addClass('justify-content-center')
                controlsWrapper.html(spinner)
            }
        })
    })

    $('#team-unassign-captain, #team-assign-captain').on('click', function(){
        let path = $(this).data('path')
        let teamId = $(this).data('teamId')
        let controlsWrapper = $(`#team-controls-wrapper-${teamId}`)
        $.ajax({
            method: "POST",
            dataType: "json",
            url: path,
            data: {community_id: communityId, id: eventId, team_id: teamId, authenticity_token: token},
            success: (data) => {
                if(data.success){
                    $('#participants').html(data.list)
                }
                assignEventListeners();
            },
            beforeSend: () => {
                controlsWrapper.addClass('d-flex')
                controlsWrapper.addClass('justify-content-center')
                controlsWrapper.html(spinner)
            }
        })
    })

    $('#join-leave-button').on('ajax:success', function(event){
        let data = event.detail[2]
        data = JSON.parse(data.response)
        if(data.success){
            $('#participants').html(data.list)
            $('#join-leave-btn').html(data.button)
            $('#participants-tab').tab('show')
            assignEventListeners();
        }
    });

    $('#participants').on('ajax:success', function(event){
        let data = event.detail[2]
        data = JSON.parse(data.response)
        if(data.success) {
            $('#participants').html(data.list)
            assignEventListeners();
        }
    });

}
assignEventListeners();

let poll = new Poll('#tool-modal-body')
