defmodule MusicQuiz.ViewHelper do
  @moduledoc """
  Access current user information in the eex views.
  """
  def current_user(conn), do: Guardian.Plug.current_resource(conn)
  def logged_in?(conn), do: Guardian.Plug.authenticated?(conn)
end
