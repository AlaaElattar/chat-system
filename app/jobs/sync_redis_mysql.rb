class SyncRedisMysql
    include Sidekiq::Worker

    def perform
        Rails.logger.info "Starting SyncRedisMysql job"
        sync_chats_count
        sync_messages_count
        Rails.logger.info "Completed SyncRedisMysql job"

    end

    private
    def sync_chats_count
        Rails.logger.info "Starting sync_chats_count"
        Application.find_each do |application|
            count = RedisHelper.get_chats_count(application.token)
            Rails.logger.info "Application #{application.id} (#{application.token}): Redis count = #{count}"
            if count > 0
                application.update(chats_count: count)
                Rails.logger.info "Updated Application #{application.id} chats_count to #{count}"
            end
        end
        Rails.logger.info "Completed sync_chats_count"
    end

    def sync_messages_count
        Rails.logger.info "Starting sync_messages_count"
        Chat.find_each do |chat|
            count = RedisHelper.get_messages_count(chat.number)
            Rails.logger.info "Chat #{chat.id} (#{chat.number}): Redis count = #{count}"

            if count > 0
                chat.update(messages_count: count)
                Rails.logger.info "Updated Chat #{chat.id} messages_count to #{count}"
            end
        end    
        Rails.logger.info "Completed sync_messages_count"    
    end

end