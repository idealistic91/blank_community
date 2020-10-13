$(document).on('turbolinks:load', function(){    
    //set color to black if tab selected
    $('#event-bar a').on('click', function(){
        $(this).removeClass('text-light');
        let tabs = $('#event-bar a');
        tabs.splice($.inArray(this, tabs), 1);
        tabs.each(function() {
            $(this).addClass('text-light')
        });
    });
    $(document).on('ajax:success', function(event){
        data = event.detail[2]
        data = JSON.parse(data.response)
        $('#participants').html(data.template)
        
    });


});

