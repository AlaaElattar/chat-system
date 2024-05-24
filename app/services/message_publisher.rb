require 'bunny'

class MessagePublisher

  def self.publish(channel, exchange, message)
    puts "Publishing message to exchange: #{exchange}"
    x = channel.queue(exchange, durable: true)
    x.publish(message.to_json, routing_key: x.name)
    puts "Message: #{message.to_json}"
    
    x.publish(message.to_json)
  rescue => e
    puts "Error publishing message: #{e.message}"
  end

end
