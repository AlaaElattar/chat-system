require 'bunny'

class RabbitmqService
  def self.channel
    @channel ||= begin
      conn = Bunny.new(hostname: ENV['RABBITMQ_HOST'] || 'rabbitmq', port: ENV['RABBITMQ_PORT'] || 5672)
      conn.start
      conn.create_channel
    end
  end
end
