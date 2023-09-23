module ApplicationCable
  class Channel < ActionCable::Channel::Base
    def self.default_broadcast_payload
      {
        "broadcast_from": "server",
        "error": nil
      }
    end
  end
end
