require 'bunny'

class RabbitmqService
  def self.channel
    @channel ||= begin
      conn = Bunny.new
      conn.start
      conn.create_channel
    end
  end
end
