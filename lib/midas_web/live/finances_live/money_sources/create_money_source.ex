defmodule MidasWeb.FinancesLive.MoneySources.CreateMoneySource do
  use MidasWeb, :live_view

  alias Midas.Finances
  alias Midas.Finances.MoneySource

  @impl true
  def mount(_params, _session, socket) do
    socket = assign(socket, form: to_form(Finances.change_money_source(%MoneySource{})))

    {:ok, socket}
  end

  @impl true
  def handle_event("create_money_source", %{"money_source" => params}, socket) do
    case Finances.create_money_source(socket.assigns.current_user.id, params) do
      {:ok, _} ->
        socket =
          socket
          |> put_flash(:info, "Conta criada com sucesso")
          |> push_navigate(to: ~p"/finances/money_sources")

        {:noreply, socket}

      {:error, "User not found"} ->
        {:noreply, put_flash(socket, :error, "Usuário não encontrado")}

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end
