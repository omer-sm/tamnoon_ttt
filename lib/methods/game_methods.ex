defmodule TamnoonTtt.Methods.GameMethods do
  import Tamnoon.MethodManager
  alias Tamnoon.DOM

  defmethod :start_turn do
    current_player = Map.get(state, :current_player, "O")

    new_player = if current_player == "X", do: "O", else: "X"

    toggle_buttons_action =
      DOM.Actions.ForEach.new!(%{
        target:
          DOM.NodeCollection.new!(%{
            selector_type: :query,
            selector_value: "#game-grid button:has(> span:empty)"
          }),
        callback:
          DOM.Actions.ToggleAttribute.new!(%{
            attribute: "disabled",
            force_to: Map.get(req, "player", new_player) == state[:player_symbol],
            target:
              DOM.Node.new!(%{
                selector_type: :iteration_placeholder,
                selector_value: nil
              })
          })
      })

    {%{current_player: new_player}, [toggle_buttons_action]}
  end

  defmethod :handle_move do
    cell_id = req["key"]
    game_channel = Tamnoon.Methods.subbed_channels() |> List.first()

    # TODO: check for game over

    new_state = Map.put(state, String.to_atom(cell_id), state[:current_player])

    Tamnoon.Methods.pub(
      %{
        "channel" => game_channel,
        "action" => %{
          "method" => "apply_move",
          "cell_id" => cell_id
        }
      },
      new_state
    )

    {%{}, [], new_state}
  end

  defmethod :apply_move do
    cell_id = req["cell_id"]
    current_player = state[:current_player]

    fill_cell_action =
      DOM.Actions.SetAttribute.new!(%{
        attribute: "textContent",
        value: current_player,
        target:
          DOM.Node.new!(%{
            selector_type: :id,
            selector_value: cell_id <> "_content"
          })
      })

      Tamnoon.MethodManager.trigger_method(:start_turn, %{}, 0)

    {%{String.to_atom(cell_id) => current_player}, [fill_cell_action]}
  end
end
