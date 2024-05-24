class ChatWorker 
  include Sneakers::Worker
  from_queue 'chats', env: nil

  def work(raw_message)
    logger.info "Received raw message: #{raw_message}"
    
    message = JSON.parse(raw_message)
    puts "Message #{message}"
    application = Application.find_by(token: message['application_id'])
    if application

      chat = Chat.create(application_id: message['application_id'], number: message['number'], messages_count: message['messages_count'])
      chat.save
      logger.info "Chat created successfully: #{chat.inspect}"
    else
      logger.error "Failed to create chat: #{chat.errors.full_messages.join(', ')}"
    end
    
    ack!
  rescue StandardError => e
    logger.error "Error processing message: #{e.message}"
    reject!
  end
end
