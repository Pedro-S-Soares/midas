defmodule MidasWeb.FinancesLive.MoneySources.Form do
  use MidasWeb, :live_view

  alias Midas.Finances
  alias Midas.Finances.MoneySource

  @impl true
  def mount(params, _session, socket) do
    case params do
      %{"id" => id} ->
        money_source = Finances.get_user_money_source(socket.assigns.current_user, id)

        socket =
          socket
          |> assign(form: to_form(Finances.change_money_source(money_source)))
          |> assign(:money_source, money_source)
          |> assign(:mode, :edit)

        {:ok, socket}

      _ ->
        socket =
          socket
          |> assign(form: to_form(Finances.change_money_source(%MoneySource{})))
          |> assign(:money_source, nil)
          |> assign(:mode, :new)

        {:ok, socket}
    end
  end

  @impl true
  def handle_event("save_money_source", %{"money_source" => params}, socket) do
    if socket.assigns.mode == :new do
      do_save_money_source(socket, params)
    else
      do_update_money_source(socket, params)
    end
  end

  @impl true
  def handle_event("validate", %{"money_source" => params}, socket) do
    changeset =
      %MoneySource{}
      |> Finances.change_money_source(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, form: to_form(changeset))}
  end

  defp do_save_money_source(socket, params) do
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

  defp do_update_money_source(socket, params) do
    case Finances.update(socket.assigns.current_user.id, socket.assigns.money_source.id, params) do
      {:ok, _} ->
        socket =
          socket
          |> put_flash(:info, "Conta atualizada com sucesso")
          |> push_navigate(to: ~p"/finances/money_sources")

        {:noreply, socket}

      {:error, "User not found"} ->
        {:noreply, put_flash(socket, :error, "Usuário não encontrado")}

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end
