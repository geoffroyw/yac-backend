require 'bunny'

class Publisher

  def self.publish_booking_request(message)
    conn = Bunny.new
    conn.start
    ch = conn.create_channel
    q = channel.queue('yac-booking-request')
    ch.default_exchange.publish(message, rounting_key: q.name)
    conn.close
  end
end