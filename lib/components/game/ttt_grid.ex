defmodule TamnoonTtt.Components.Game.TttGrid do
  @behaviour Tamnoon.Component

  def heex() do
    """
    <div class="grid grid-cols-3 gap-2 w-48 mx-auto mt-10">
      <%= for row <- [0, 1, 2] do %>
        <%= for col <- [0, 1, 2] do %>
          <%= TamnoonTtt.Components.Game.TttGrid.grid_button(row, col) %>
        <% end %>
      <% end %>
    </div>
    """
  end

  def grid_button(row, col) do
    """
    <button
      class="btn btn-soft btn-primary btn-xl text-2xl"
      id="grid-btn-#{row}-#{col}"
      disabled=@cell_#{row}_#{col}
      onclick=@debug
    >@cell_#{row}_#{col}</button>
    """
  end
end
