require "opentok"

class RoomChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from "room_#{current_user.id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    stop_all_streams
  end

  def call(data)
    recipient_id = data['recipient_id']
    recipient_name = data['recipient_name']
    @session = opentokSession
    session_id = @session.session_id
    broadcast_notif_to_recipient(recipient_id, session_id)


  end

  def answer(data)
    session_id = data["session_id"]
    sender_id = data["sender_id"]
    broadcast_session_to_recipient(session_id)
    broadcast_session_to_sender(session_id, sender_id)
  end


  private


  # Brodcast the session to the recipient
  def broadcast_session_to_recipient(session_id)
    token = create_token(session_id)
    ActionCable.server.broadcast(
      "room_#{current_user.id}",
      apikey: api_key,
      session_id: session_id,
      token: token,
      step: 'Broadcasting session to the recipient'
    )
  end

  def broadcast_session_to_sender(session_id, sender_id)
    token = create_token(session_id)
    ActionCable.server.broadcast(
      "room_#{sender_id}",
      apikey: api_key,
      session_id: session_id,
      token: token,
      step: 'Broadcasting session to the sender'
    )
  end

  def broadcast_notif_to_recipient(recipient_id, session_id)
    ActionCable.server.broadcast(
      "room_#{recipient_id}",
      sender_first_name: current_user.full_name,
      sender_id: current_user.id,
      session_id: session_id,
      step: 'receiving the call'
    )
  end

  def opentokSession
    create_session
  end

  def api_key
    Rails.application.credentials.opentok[:api_key]
  end

  def secret_key
    Rails.application.credentials.opentok[:secret_key]
  end

  def opentok
    OpenTok::OpenTok.new api_key, secret_key
  end

  def create_session
    opentok.create_session :media_mode => :routed
  end

  def create_token(session_id)
    opentok.generate_token(session_id)
  end



end
