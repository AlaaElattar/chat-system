namespace :sneakers do
  desc 'Start the Sneakers worker'
  task :run do
    require 'sneakers'
    require_relative '../../app/workers/chat_worker'
    require_relative '../../app/workers/message_worker'

    Sneakers.configure({})
    Sneakers.logger.level = Logger::INFO 

    workers = [
      ChatWorker,
      MessageWorker
    ]

    chat_worker = ChatWorker.new
    message_worker = MessageWorker.new

    Thread.new { chat_worker.run }
    Thread.new { message_worker.run }

    loop {sleep 5}
  end
end
