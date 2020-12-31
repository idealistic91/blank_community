module ApplicationHelper
  def profile_picture_icon(user)
    if user.has_picture?
      image_tag url_for(user.picture), id: 'nav-profile-picture', class: 'rounded-circle'
    else
      image_tag image_url('logo.png'), id: 'nav-profile-picture', class: 'rounded-circle'
    end
  end
end
