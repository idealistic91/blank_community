$(document).on('turbolinks:load', function(){
    let count = 0;
    function setHeight() {
        count +=1;
        let image = $('#event-picture')
        let height = image.height();
        if(height === 0 && count < 4){
            setHeight();
        } else {
            $('#event-card-show').css('height', height.toString())
        }
    }
    
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

