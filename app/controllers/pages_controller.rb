require "opentok"

class PagesController < ApplicationController

  before_action :authenticate_user!

  def home
    @users = User.all
  end

  def call
    @api_key = api_key

    if room = Room.between(current_user.id, User.find(params[:id]))[0]
      @session = opentokSession
      @session_id = @session.session_id
      @token = create_token(@session_id)
    else
      @session = opentokSession
      @session_id = @session.session_id
      @token = create_token(@session_id)
      Room.create!(session_id: @session_id, sender_id: current_user.id, recipient_id: User.find(params[:id]).id)

    end

    respond_to do |format|
      format.js
    end

  end

  def join
    @session_id = Room.between(current_user.id, 1)[0].session_id
    @token = create_token(@session_id)
    @api_key = api_key
  end

  private

  def opentokSession
    create_session
  end

  def api_key
    Rails.application.credentials.opentok[:api_key]
  end

  def opentok
    OpenTok::OpenTok.new api_key, Rails.application.credentials.opentok[:secret_key]
  end

  def create_session
    opentok.create_session :media_mode => :routed
  end

  def create_token(session_id)
    opentok.generate_token(session_id)
  end
























end
