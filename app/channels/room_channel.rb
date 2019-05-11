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

    if room = Room.between(current_user.id, recipient_id)[0]
      session_id = room.session_id
      token = create_token(session_id)
      #broadcast_to_sender(session_id, token, current_user.id, recipient_id)
      broadcast_notif_to_recipient(current_user.first_name, recipient_id, session_id)
    else
      @session = opentokSession
      session_id = @session.session_id
      token = create_token(session_id)
      Room.create(session_id: session_id, sender_id: current_user.id, recipient_id: recipient_id)
      broadcast_notif_to_recipient(current_user.first_name, recipient_id, session_id)

    end


  end

  def answer(data)
    session_id = data["session_id"]
    # Get the sender id to broadcast to the sender
    room = Room.where(session_id: session_id)[0]
    sender_id = room.opposed_user(current_user).id
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

  def broadcast_notif_to_recipient(sender_first_name, recipient_id, session_id)
    ActionCable.server.broadcast(
      "room_#{recipient_id}",
      sender_first_name: sender_first_name,
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
