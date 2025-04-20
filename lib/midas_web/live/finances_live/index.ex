defmodule MidasWeb.FinancesLive.Index do
  use MidasWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <h1>Controle financeiro</h1>
    </div>
    """
  end
end
