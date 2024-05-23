class Application < ApplicationRecord
    has_many :chats, dependent: :destroy

    validates_uniqueness_of :token
    validates_presence_of :name, :chats_count
    before_save :generate_token

    private

    def generate_token
        self.token = SecureRandom.uuid
    end    
end
