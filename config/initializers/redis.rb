require 'redis'

$redis = Redis.new(host: Rails.configuration.redis[:host], port: Rails.configuration.redis[:port])
Redis::Namespace.new(:my_app, redis: $redis)
