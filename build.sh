#!/usr/bin/env bash
# exit on error
set -o errexit

# Initial setup
mix deps.get --only prod
MIX_ENV=prod mix compile

# Compile assets
npm install --prefix ./apps/trivium_web/assets
npm run deploy --prefix ./apps/trivium_web/assets
mix phx.digest

# Build the release and overwrite the existing release directory
MIX_ENV=prod mix release --overwrite

# Run migrations
_build/prod/rel/trivium_umbrella/bin/trivium_umbrella eval "Trivium.Release.migrate"
