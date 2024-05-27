class MessageWorker
  include Sneakers::Worker
  from_queue 'messages', env: nil
  def work(raw_message)
    require "#{Rails.root}/config/environment"

    logger.info "Received raw message: #{raw_message}"

    message = JSON.parse(raw_message)

    begin 
      @chat = Chat.find_by(number: message["chat_id"])
      if @chat.nil?
        logger.error "Chat with id: #{message["chat_id"]} not found"
        reject!
        return
      end
      @message = @chat.messages.create(number: message["number"], body: message["body"])
      logger.info "Successfully created message for chat_id: #{message['chat_id']} with number: #{message['number']}"
      ack!
    rescue ActiveRecord::RecordInvalid => e
      logger.error "Failed to create record: #{e.message}"
      reject!       
    rescue StandardError => e
      logger.error "Error processing Chat: #{e.message}"
      reject!
    end
  end
end
