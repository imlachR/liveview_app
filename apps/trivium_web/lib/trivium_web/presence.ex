defmodule TriviumWeb.Presence do
  use Phoenix.Presence,
    otp_app: :trivium,
    pubsub_server: Trivium.PubSub 
end
