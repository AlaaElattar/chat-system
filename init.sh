
#!/bin/bash

bundle install

bundle exec rails db:migrate

bundle exec rails assets:precompile
