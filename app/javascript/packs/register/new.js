function findGetParameter(parameterName) {
    var result = null,
        tmp = [];
    location.search
        .substr(1)
        .split("&")
        .forEach(function (item) {
          tmp = item.split("=");
          if (tmp[0] === parameterName) result = decodeURIComponent(tmp[1]);
        });
    return result;
}
let form = $('#new_user')
if(findGetParameter('server_id') != null){
    let hidden_input = `<input type="hidden" name="server_id" id="server_id" value="${findGetParameter('server_id')}">`
    form.prepend(hidden_input)
}

$('#user_discord_id').val(findGetParameter('discord_id'))