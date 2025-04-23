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

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    case Midas.Finances.delete_finance(socket.assigns.current_user.id, id) do
      {:ok, _} ->
        socket =
          socket
          |> put_flash(:info, "Movimentação excluída com sucesso")
          |> assign(:finances, Midas.Finances.get_user_finances(socket.assigns.current_user.id))

        {:noreply, socket}

      {:error, _} ->
        socket =
          socket
          |> put_flash(:error, "Erro ao excluir movimentação")

        {:noreply, socket}
    end
  end
end
