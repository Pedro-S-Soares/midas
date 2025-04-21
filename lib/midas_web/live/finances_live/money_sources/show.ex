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
    money_source = Finances.get_money_source!(id)

    # Verificar se a conta pertence ao usuário atual
    if money_source.user_id == socket.assigns.current_user.id do
      {:ok, _} = Finances.delete_money_source(money_source)

      money_sources = Finances.get_user_money_sources(socket.assigns.current_user)
      {:noreply, assign(socket, :money_sources, money_sources)}
    else
      {:noreply, put_flash(socket, :error, "Você não tem permissão para excluir esta conta.")}
    end
  end
end
