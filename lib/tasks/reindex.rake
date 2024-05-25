namespace :elasticsearch do
  desc 'Reindex all messages'
  task reindex: :environment do
    Message.find_each do |message|
      message.__elasticsearch__.index_document
    end
    puts "Reindexing completed."
  end
end
