FROM ruby:latest

RUN apt-get update && \
    apt-get install -y default-libmysqlclient-dev \
                       redis-tools && \
    apt-get clean

WORKDIR /app

COPY Gemfile* ./

RUN bundle install

COPY . .

CMD ["sh", "-c", "sh ./init.sh && rails s -p 3000 -b '0.0.0.0' -e development"]
