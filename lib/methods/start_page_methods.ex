defmodule TamnoonTtt.Methods.StartPageMethods do
  import Tamnoon.MethodManager
  alias Tamnoon.DOM

  defmethod :join_queue do
    Tamnoon.Methods.sub(%{"channel" => "queue"}, state)

    trimmed_name = String.trim(state[:name])
    new_state = Map.put(state, :name, trimmed_name)

    Tamnoon.Methods.pub(%{
      "channel" => "queue",
      "action" => %{
        "method" => "queue_handshake",
        "sender" => inspect(self()),
        "name" => trimmed_name
      }
    }, new_state)

    {%{name: trimmed_name}}
  end

  defmethod :update_name do
    old_value = state[:name]
    new_value = req["value"]

    case {old_value, String.trim(new_value)} do
      {"", ""} -> {}
      {"", _} -> {%{name: new_value}, [toggle_play_button(false)]}
      {_, ""} -> {%{name: new_value}, [toggle_play_button(true)]}
      {_, _} -> {%{name: new_value}}
    end
  end

  defp toggle_play_button(disable) do
    DOM.Actions.ToggleAttribute.new!(%{
      attribute: "disabled",
      force: disable,
      target:
        DOM.Node.new!(%{
          selector_type: :id,
          selector_value: "play-btn"
        })
    })
  end
end
