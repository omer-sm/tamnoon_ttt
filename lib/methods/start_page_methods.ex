defmodule TamnoonTtt.Methods.StartPageMethods do
  import Tamnoon.MethodManager
  alias Tamnoon.DOM

  defmethod :join_queue do
    # TBD

    {%{name: String.trim(state[:name])}}
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
