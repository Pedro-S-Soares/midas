defmodule MidasWeb.FinancesLive.MoneySources.Show do
  use MidasWeb, :live_view

  alias Midas.Finances

  @impl true
  def mount(_params, _session, socket) do
    money_sources = Finances.get_user_money_sources(socket.assigns.current_user.id)

    socket =
      socket
      |> assign(:money_sources, money_sources)

    {:ok, socket}
  end
end
