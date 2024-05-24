namespace :sneakers do
  desc 'Start the Sneakers worker'
  task :run do
    require 'sneakers'
    require_relative '../../app/workers/chat_worker'

    Sneakers.configure({})
    Sneakers.logger.level = Logger::INFO 

    chat_worker = ChatWorker.new

    Thread.new { chat_worker.run }
    loop {sleep 5}
  end
end
