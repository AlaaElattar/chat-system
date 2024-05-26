class MessageWorker
    include Sneakers::Worker
    from_queue 'messages', env: nil

    def work(raw_message)
        require "#{Rails.root}/config/environment" 

        logger.info "Received raw message: #{raw_message}"

        message = JSON.parse(raw_message)

        @chat = Chat.find_by(number: message["chat_id"])
        if @chat.nil?
            logger.error "Chat with id: #{message["chat_id"]} not found"
            reject!
            return
        end
        @message = @chat.messages.create(number: message["number"], body: message["body"])
        puts "#{@message.inspect}"
    rescue StandardError => e
        logger.error "Error processing Chat: #{e.message}"
        reject!
    end
end