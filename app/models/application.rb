class Application < ApplicationRecord
    has_many :chats, dependent: :destroy

    validates_uniqueness_of :token
    validates_presence_of :name, :token, :chats_count
end
