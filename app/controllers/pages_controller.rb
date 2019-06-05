require "opentok"

class PagesController < ApplicationController

  before_action :authenticate_user!

  def home
    @users = User.where.not(id: current_user.id)
  end

end
