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

    new_state = Map.put(state, String.to_atom(cell_id), state[:current_player])
    current_result = check_game_result(new_state)

    if current_result == :continue do
      Tamnoon.MethodManager.trigger_method(:start_turn, %{}, 0)
    else
      {result, winner} =
        case current_result do
          :draw -> {:draw, nil}
          {_, _} -> current_result
          _ -> raise "Unknown current_result, #{current_result}"
        end

      Tamnoon.MethodManager.trigger_method(:disable_buttons, %{})

      Tamnoon.MethodManager.trigger_method(
        :handle_game_over,
        %{"result" => result, "winner" => winner},
        1000
      )
    end

    {%{String.to_atom(cell_id) => current_player}, [fill_cell_action]}
  end

  defmethod :disable_buttons do
    disable_buttons_action =
      DOM.Actions.ForEach.new!(%{
        target:
          DOM.NodeCollection.new!(%{
            selector_type: :query,
            selector_value: "#game-grid button"
          }),
        callback:
          DOM.Actions.ToggleAttribute.new!(%{
            attribute: "disabled",
            force_to: true,
            target:
              DOM.Node.new!(%{
                selector_type: :iteration_placeholder,
                selector_value: nil
              })
          })
      })

    {%{}, [disable_buttons_action]}
  end

  defmethod :handle_game_over do
    result = req["result"]

    result_text =
      case result do
        "draw" ->
          "The game ended in a draw."

        "win" ->
          "#{if req["winner"] == state[:player_symbol],
            do: "You have",
            else: "#{state[:other_player_name]} has"} won the game!"
      end

    switch_page_action =
      TamnoonTtt.Utils.PageManagement.switch_page_action("pages/game_over_page.html.heex")

    {%{result_text: result_text}, [switch_page_action]}
  end

  @spec check_game_result(state :: map()) :: {:win, String.t()} | :draw | :continue
  defp check_game_result(state)

  # Check diagonals
  defp check_game_result(%{cell_0_0: cell_a, cell_1_1: cell_b, cell_2_2: cell_c})
       when cell_a == cell_b and cell_b == cell_c,
       do: {:win, cell_a}

  defp check_game_result(%{cell_0_2: cell_a, cell_1_1: cell_b, cell_2_0: cell_c})
       when cell_a == cell_b and cell_b == cell_c,
       do: {:win, cell_a}

  # Check rows, cols and draw
  defp check_game_result(state) do
    result =
      Enum.find_value(0..2, fn axis_1 ->
        row_cells =
          Enum.map(0..2, fn axis_2 ->
            Map.get(state, String.to_atom("cell_#{axis_1}_#{axis_2}"))
          end)

        col_cells =
          Enum.map(0..2, fn axis_2 ->
            Map.get(state, String.to_atom("cell_#{axis_2}_#{axis_1}"))
          end)

        case {row_cells, col_cells} do
          {[cell, cell, cell], _} when not is_nil(cell) -> {:win, cell}
          {_, [cell, cell, cell]} when not is_nil(cell) -> {:win, cell}
          _ -> nil
        end
      end)

    if is_nil(result), do: draw_or_continue(state), else: result
  end

  defp draw_or_continue(state) do
    empty_cell_exists =
      Enum.find_value(0..8, fn index ->
        axis_1 = rem(index, 3)
        axis_2 = div(index, 3)

        Map.get(state, String.to_atom("cell_#{axis_1}_#{axis_2}"))
        |> is_nil()
      end)

    if empty_cell_exists, do: :continue, else: :draw
  end
end
