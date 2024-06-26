# Chat System

Chat System Application provides creating different applications, each one has its own chats and messages.

## Table of Contents

- [Chat System](#chat-system)
  - [Features](#features)
  - [Technologies Used](#technologies-used)
  - [Database Schema](#database-schema)
  - [Getting Started](#getting-started)
    - [Prerequisites](#prerequisites)
    - [Installation](#installation)
  - [API Endpoints](#api-endpoints)
    - [Applications](#applications)
    - [Chats](#chats)
    - [Messages](#messages)
    - [Search](#search)

### Features

- <b> Application Creation:</b> Users can create many apps each one with its chats and messages. Each Application is identified by unique token.

- <b>Chat Creation:</b> Within each application, users can create multiple chats. Each chat has unique id identifies it.

- <b>Message Exchange:</b> Users can send and receive messages within individual chats. Each message is assigned a unique number starting from 1 for each chat.

- <b> Message Queuing with Redis:</b> Message queuing with redis offers asynchronous communication between components enhancing system scalability, load balancing and performance. Redis message queuing also supports fault tolerance through message storage and delivery.

- <b>Elasticsearch Search:</b> The system provides full-text search functionality for messages using Elasticsearch. This allows users to search through messages based on their content.

- <b>Background Job for Updating Counts:</b> Automated job to update counts of messages and chats regularly. This ensures that the counts of messages and chats are up-to-date and accurate.

- <b>Containerized Deployment:</b> The application is containerized using Docker and Docker Compose, making it easy to deploy and manage.

## Database Schema

### Tables

- <b> Application:</b> Contains information about applications, including their tokens, names, and chat counts.
- <b> Chat:</b> Stores chats associated with applications, including their application id, numbers and messages count.
- <b> Message:</b> Contains messages sent within chats, including their chat id, message numbers and bodies.

## Technologies Used

- **Ruby on Rails:** Backend framework for building the API and workers.

- **MySQL:** Relational database for storing application, chat, and message data.
- **Redis:** In-memory data store for caching messages and chats counts.
- **RabbitMQ:** Message broker for handling message queuing.
- **Elasticsearch:** Search engine for message searching functionality through messages of any chat.

- **Sidekiq:** Background job processing for updating message and chat counts each hour.

- **Docker / Docker Compose:** Containerization for easy deployment and scalability.

## Getting Started

### Prerequisites

You need to have Docker installed on your machine in order to run the whole stack.

- Docker
- Docker compose

### Installation

1. Clone the repository
   ```sh
   git clone https://github.com/AlaaElattar/chat-system
   ```
2. Run the whole stack using docker compose.
   By default, the environment is set to development. You can specify custom environment to be `test` or `production` by adding `RAILS_ENV`.
   ```
   RAILS_ENV=production
   ```
   Then, run docker compose.
   ```sh
   docker compose up --build
   ```

## API Endpoints


- **POST /applications**: Create a new application.
  ```bash
  curl -X POST http://localhost:4000/applications -H "Content-Type: application/json" -d '{"name": "New Application"}'
  ```
  ```bash
  {
    "token": "app-token"
  }
  ```
- **GET /applications**: Retrieve a list of all applications.
  ```bash
  curl -X GET http://0.0.0.0:4000/applications
  ```
  ```bash
  [
    {
      "token": "app-token1",
      "name": "Test Application",
      "chats_count": 5,
      "id": 1
    },
    {
      "token": "app-token1",
      "name": "Another Application",
      "chats_count": 3,
      "id": 2
    }
  ]
  ```
- **GET /applications/:application_token**: Retrieve details of a specific application.
  ```bash
  curl -X GET http://localhost:4000/applications/app-token1
  ```
  ```bash
  {
    "id": 1,
    "token": "app-token1",
    "name": "Test Application",
    "chats_count": 5
  }
  ```

### Chats

- **POST /applications/:application_token/chats**: Create a new chat for a specific application.
    ```bash
      curl -X POST http://localhost:4000/applications/app-token1/chats
    ```
    ```bash
    {
      "chat_number": 3
    }
    ```
- **GET /applications/:application_token/chats**: Retrieve a list of all chats for a specific application.
    ```bash
      curl -X GET http://localhost:4000/applications/app-token1/chats
    ```
    ```bash
      [
        {
          "token": "app-token1",
          "number": 1,
          "messages_count": 10
        },
        {
          "token": "app-token1",
          "number": 2,
          "messages_count": 5
        }
      ]
    ```
- **GET /applications/app-token1/chats/:chat_number**: Retrieve details of a specific chat.
    ```bash
      curl -X GET http://localhost:4000/applications/app-token1/chats/1
    ```
    ```bash
    {
      "token": "app-token1",
      "number": 1,
      "messages_count": 10
    },
    ```    
### Messages

- **POST /applications/:application_token/chats/:chat_number/messages**: Create a new message for a specific chat.
    ```bash
    curl -X POST http://localhost:4000/applications/app-token1/chats/1/messages -H "Content-Type: application/json" -d '{"content": "Hello new message !"}'
    ```

- **GET /applications/:application_token/chats/:chat_number/messages**: Retrieve a list of all messages for a specific chat.
    ```bash
    curl -X GET http://localhost:4000/applications/app-token1/chats/1/messages
    ```
    ```bash
    [
      {
        "number": 1,
        "chat_id":1,
        "message_number": 1,
        "content": "Hello, world!"
      },
      {
        "number": 2
        "chat_id":1,
        "message_number": 2,
        "content": "Hello!"
      }
    ]
    ```
- **GET /applications/:application_token/chats/:chat_number/messages/:message_number**: Retrieve details of a specific message.
    ```bash
    curl -X GET http://localhost:4000/applications/app-token1/chats/1/messages/1
    ```
    ```bash
    {
      "id": 1,
      "number": 1,
      "chat_id":1,
      "message_number": 1,
      "content": "Hello, world!"
    }
    ```

### Search

- **GET /applications/:application_token/chats/:chat_number/messages/search?query=:query**: Search for messages within a specific chat.
    ```bash
    curl -X GET http://localhost:4000/applications/app-token1/chats/1/messages/search?query=new
    ```
    ```bash
    [
      {
        "id", 3,
        "chat_id":1,
        "body":"Hello to the new World!",
      }
    ]
    ```    