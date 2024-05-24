def MessageWorker
    include Sneakers::Worker
    from_queue 'messages', env: nil

    def work(raw_message)
        puts self.name
        message = JSON.parse(raw_message)
        chat = Chat.find_by(number: message["chat_id"])
        if chat
            message = chat.messages.create(number: message['message_number'], body: message['body'])
            logger.info "Message #{msg.number} created in chat #{chat.number}"
        else
            logger.error "Chat #{message['chat_id']} not found"
        end   
        ack!     

    end
end