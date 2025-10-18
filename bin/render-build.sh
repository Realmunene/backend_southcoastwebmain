# bin/render-build.sh
#!/usr/bin/env bash
set -o errexit

# Install dependencies
bundle install

# Precompile assets
bundle exec rails assets:precompile
bundle exec rails assets:clean

# Run migrations if this is the first deploy
bundle exec rails db:migrate