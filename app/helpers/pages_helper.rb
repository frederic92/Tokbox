module PagesHelper

  def links
    if user_signed_in?
      'layouts/nav/dropdown'
    else
      'layouts/nav/auth_links'
    end
  end

end
