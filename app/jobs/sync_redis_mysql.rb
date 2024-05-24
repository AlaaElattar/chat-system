class SyncRedisMysql
    include Sidekiq::worker

    def perform
        sync_chats_count
        sync_messages_count

    end

    private
    def sync_chats_count
        Application.find_each do |application|
            redis_key = "chats_count:#{application.token}"
            count = RedisHelper.get(redis_key).to_i
            application.update(chats_count:count) if count > 0
        end
    end

    def sync_messages_count
        Chat.find_each do |chat|
            redis_key = "messages_count:#{chat.number}"
            count = RedisHelper.get(redis_key).to_i
            chat.update(chats_count:count) if count > 0
        end        
    end


end