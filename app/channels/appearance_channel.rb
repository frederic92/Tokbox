class AppearanceChannel < ApplicationCable::Channel
  def subscribed
    stream_from "appearance"
    presence("online")
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed\
    stop_all_streams
    presence("offline")
  end

  def presence(state)
    update_state(state)
    broadcast_change_to_users(state)
  end

  private

  def update_state(state)
    state == "online" ? current_user.online! : current_user.offline!
  end

  def broadcast_change_to_users(state)
    ActionCable.server.broadcast(
      "appearance",
      state: state,
      user_id: current_user.id,
    )
  end

end
