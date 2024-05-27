namespace :elasticsearch do
  desc 'Reindex all messages'
  task reindex: :environment do
    begin
      Message.__elasticsearch__.create_index!(force: true)
      Message.import
      puts "Reindexing completed successfully."
    rescue => e
      puts "An error occurred during reindexing: #{e.message}"
    end
  end
end
