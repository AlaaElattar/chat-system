class Message < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :chat
  validates_presence_of :body, :chat_id, :number

  settings index: { number_of_shards: 1 } do
    mappings dynamic: 'false' do
      indexes :body, analyzer: 'english'
      indexes :chat_id, type: 'keyword'
      indexes :created_at, type: 'date'
    end
  end

  def as_indexed_json(options = {})
    self.as_json(only: [:body, :chat_id, :created_at])
  end

  def self.search(query, chat_id)
    __elasticsearch__.search(
      {
        query: {
          bool: {
            must: [
              { match: { body: query } },
              { term: { chat_id: chat_id } }
            ]
          }
        }
      }
    )
  end
end
