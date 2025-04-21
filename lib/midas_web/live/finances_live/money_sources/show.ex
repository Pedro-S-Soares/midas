defmodule MidasWeb.FinancesLive.MoneySources.Show do
  use MidasWeb, :live_view

  alias Midas.Finances

  @impl true
  def mount(_params, _session, socket) do
    money_sources = Finances.get_user_money_sources(socket.assigns.current_user)

    socket =
      socket
      |> assign(:money_sources, money_sources)

    {:ok, socket}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    case Finances.soft_delete(socket.assigns.current_user.id, id) do
      {:ok, _} ->
        updated_money_sources = Finances.get_user_money_sources(socket.assigns.current_user)

        socket =
          socket
          |> put_flash(:info, "Conta excluída com sucesso")
          |> assign(:money_sources, updated_money_sources)

        {:noreply, socket}

      {:error, _} ->
        {:noreply, put_flash(socket, :error, "Erro ao excluir conta.")}
    end
  end
end
