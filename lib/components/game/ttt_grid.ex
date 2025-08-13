defmodule TamnoonTtt.Components.Game.TttGrid do
  @behaviour Tamnoon.Component

  def heex() do
    """
    <div class="grid grid-cols-3 gap-2 w-48 mx-auto mt-10" id="game-grid">
      <%= for row <- [0, 1, 2] do %>
        <%= for col <- [0, 1, 2] do %>
          <%= TamnoonTtt.Components.Game.TttGrid.grid_button(row, col) %>
        <% end %>
      <% end %>
    </div>
    """
  end

  def grid_button(row, col) do
    cell_id = "cell_#{row}_#{col}"

    # Note: The span inside the buttons is to bypass a rc.2 bug where setting the inner text messes up the onclick.
    """
    <button
      class="btn btn-soft btn-primary btn-xl text-2xl"
      disabled=@#{cell_id}
      onclick=@handle_move-#{cell_id}
    ><span id="#{cell_id}_content">@#{cell_id}</span></button>
    """
  end
end
