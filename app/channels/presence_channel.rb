class PresenceChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user
  end

  def receive
    current_device.update(online: true)
    current_user.update(online: true, last_online_at: Time.now)

    current_user.contacts.each do |contact|
      PresenceChannel.broadcast_to contact, { payload: payload }
    end
  end

  def unsubscribed
    current_device.update(online: false)

    devices = current_user.devices.where(online: true).order(created_at: :desc)
    if devices.present?
      current_user.update(online: true)
    else
      current_user.update(online: false, last_online_at: Time.now)
    end

    stop_stream_for current_user
  end

  private

  def payload
    {
      connected: current_user.online,
      user_id: current_user.id,
      last_online_at: current_user.last_online_at
    }
  end
end
