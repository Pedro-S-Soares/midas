defmodule MidasWeb.FinancesLive.Index do
  use MidasWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    finances = Midas.Finances.get_user_finances(socket.assigns.current_user.id)

    socket =
      socket
      |> assign(:finances, finances)

    {:ok, socket}
  end
end
