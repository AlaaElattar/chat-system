require 'redis'

module RedisHelper
    def self.redis
        @redis ||= Redis.new(host: Rails.configuration.redis[:host], port: Rails.configuration.redis[:port])
    end

    def self.generate_chat_number(application_id)
        key = "chats_count:#{application_id}"
        value = redis.incr(key)
        value
    end

    def self.generate_message_number(chat_id)
        key = "messages_count:#{chat_id}"
        value = redis.incr(key)
        value
    end      
end