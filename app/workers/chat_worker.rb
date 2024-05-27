class ChatWorker 
  include Sneakers::Worker
  from_queue 'chats', env: nil
    def work(raw_message)
    require "#{Rails.root}/config/environment" 

    logger.info "Received raw message: #{raw_message}"
    
    message = JSON.parse(raw_message)
    
    @application = Application.find_by(id: message['application_id'])

    if @application.nil?
      logger.error "Application not found with token: #{message['application_id']}"
      reject!
      return
    end

    begin
      @chat = Chat.create(application_id: @application.id, number: message['number'], messages_count: message['messages_count'])
      logger.info "Successfully created chat for application: #{message['application_id']} with number: #{message['number']}"
      ack!
    rescue ActiveRecord::RecordInvalid => e
      logger.error "Failed to create record: #{e.message}"
      reject!
    rescue StandardError => e
      logger.error "Error processing message: #{e.message}"
      reject!
    end
  end
end

