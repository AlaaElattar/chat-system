Application.destroy_all

app = Application.create!(name: 'Test Application', token: 'Token')
chat = app.chats.create!(number: 1)
chat.messages.create!(number: 1, body: 'Hello, World!')