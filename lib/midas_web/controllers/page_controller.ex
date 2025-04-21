defmodule MidasWeb.PageController do
  use MidasWeb, :controller

  def home(conn, _params) do
    redirect(conn, to: ~p"/finances")
  end
end
