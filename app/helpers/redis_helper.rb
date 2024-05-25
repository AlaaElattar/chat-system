require 'redis'

module RedisHelper
    def self.redis
        $redis
    end

    def self.generate_chat_number(application_id)
        key = "chats_count:#{application_id}"
        value = redis.incr(key)
        value
    end

    def self.get_chats_count(application_id)
        key = "chats_count:#{application_id}"
        redis.get(key).to_i
    end

    def self.generate_message_number(chat_id)
        key = "messages_count:#{chat_id}"
        value = redis.incr(key)
        value
    end  
    
    def self.get_messages_count(chat_id)
        key = "messages_count:#{chat_id}"
        redis.get(key).to_i
    end
end