require 'sidekiq'
require 'sidekiq-cron'

Sidekiq::Cron::Job.create(
  name: 'Synchronize Redis to MySQL - every 1 hour',
  cron: '0 * * * *',
  class: 'SynchronizeRedisToMysqlJob'
)