$(document).ready ->

  $('#user_avatar').change ->
    if this.files and this.files[0]
      reader = new FileReader
      reader.onload = (e) ->
        $('.avatar_thumb').attr('src', e.target.result).width(150).height(150)
        return
      reader.readAsDataURL this.files[0]

  if($(":file").length > 0)
    $(":file").filestyle({input: false, icon: false, badge: false})