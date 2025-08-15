defmodule TamnoonTtt.Methods.GameOverMethods do
  import Tamnoon.MethodManager

  defmethod :play_again do
    game_channel = Tamnoon.Methods.subbed_channels() |> List.first()
    Tamnoon.Methods.unsub(%{"channel" => game_channel}, state)

    diffs =
      state
      |> Map.keys()
      |> Enum.reject(&(&1 == :name))
      |> Map.from_keys(nil)
      |> Map.put(:name, state[:name])

    switch_page_action = TamnoonTtt.Utils.PageManagement.switch_page_action("pages/start_page.html.heex")

    {diffs, [switch_page_action, TamnoonTtt.Methods.StartPageMethods.toggle_play_button(false)]}
  end
end
