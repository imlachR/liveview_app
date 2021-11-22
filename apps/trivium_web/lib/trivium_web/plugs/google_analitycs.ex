defmodule TriviumWeb.GoogleAnalitycs do
  import Plug.Conn

  def init(opts) do
    case Mix.env() do
      :prod ->
        Keyword.put(opts, :ga_id, "G-BHC98TQWFY") 
      _ ->
        opts
    end
  end

  def call(conn, ga_id: ga_id), do: assign(conn, :ga_id, ga_id)
  def call(conn, _opts), do: conn

end
