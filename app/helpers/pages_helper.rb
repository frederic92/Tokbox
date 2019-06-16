module PagesHelper

  def links
    if user_signed_in?
      'layouts/nav/dropdown'
    else
      'layouts/nav/auth_links'
    end
  end

  def call_icon(user)
    user.state == "online" ? "pages/home/call_icons/call_icon" : "pages/home/call_icons/call_icon_disabled"
  end




end
