defmodule MidasWeb.FinancesLive.Form do
  use MidasWeb, :live_view

  alias Midas.Finances
  alias Midas.Finances.Finance
  alias Midas.Finances.MoneySource
  @impl true
  def mount(params, _session, socket) do
    money_sources = Finances.get_user_money_sources(socket.assigns.current_user)

    case params do
      %{"id" => id} ->
        {:ok, finance} = Finances.get_user_finance(socket.assigns.current_user.id, id)

        socket =
          socket
          |> assign(form: to_form(Finances.change_finance(finance)))
          |> assign(:finance, finance)
          |> assign(:mode, :edit)
          |> assign(:money_sources, money_sources)
          |> assign(:selected_money_source_id, nil)
          |> assign(:page_title, "Editar movimentação")

        {:ok, socket}

      _ ->
        socket =
          socket
          |> assign(form: to_form(Finances.change_finance(%Finance{})))
          |> assign(:mode, :new)
          |> assign(:finance, nil)
          |> assign(:money_sources, money_sources)
          |> assign(:selected_money_source_id, nil)
          |> assign(:page_title, "Nova movimentação")

        {:ok, socket}
    end
  end

  @impl true
  def handle_event("save_finance", %{"finance" => params}, socket) do
    do_save_finance(socket, params)
  end

  @impl true
  def handle_event(
        "select_money_source",
        %{"finance" => %{"money_source_id" => money_source_id}},
        socket
      ) do
    {:noreply, assign(socket, :selected_money_source_id, money_source_id)}
  end

  @impl true
  def handle_event("select_money_source", %{"money_source_id" => money_source_id}, socket) do
    {:noreply, assign(socket, :selected_money_source_id, money_source_id)}
  end

  @impl true
  def handle_event("validate", %{"finance" => params}, socket) do
    changeset =
      %Finance{}
      |> Finances.change_finance(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, form: to_form(changeset))}
  end

  defp do_save_finance(socket, params) do
    case Finances.create_finance(
           socket.assigns.current_user.id,
           socket.assigns.selected_money_source_id,
           params
         ) do
      {:ok, %{money_source: %MoneySource{}, finance: %Finance{}}} ->
        socket =
          socket
          |> put_flash(:info, "Movimentação criada com sucesso")
          |> push_navigate(to: ~p"/finances")

        {:noreply, socket}

      {:error, "User not found"} ->
        {:noreply, put_flash(socket, :error, "Usuário não encontrado")}

      {:error, "Money source not found"} ->
        {:noreply, put_flash(socket, :error, "Conta não encontrada")}

      {:error, "Unauthorized"} ->
        {:noreply,
         put_flash(socket, :error, "Você não tem permissão para criar movimentações nesta conta")}

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end
