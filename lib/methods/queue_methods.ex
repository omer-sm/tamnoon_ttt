defmodule TamnoonTtt.Methods.QueueMethods do
  require Logger
  import Tamnoon.MethodManager

  defmethod :queue_handshake do
    sender = req["sender"]
    self_pid = inspect(self())

    # Only start a game if this method was published by another client
    if sender == nil || sender == self_pid do
      {}
    else
      other_player_name = req["name"]
      channel_name = "match#{sender}#{self_pid}"

      new_state =
        state
        |> Map.put(:other_player_name, other_player_name)
        |> Map.put(:channel_name, channel_name)

      Tamnoon.Methods.pub(
        %{
          "channel" => "queue",
          "action" => %{
            "method" => "start_game",
            "channel_name" => channel_name,
            "other_player_name" => state[:name],
            "sender" => self_pid
          }
        },
        new_state
      )

      {%{other_player_name: other_player_name}}
    end
  end

  defmethod :start_game do
    Logger.info("Started game for #{state[:name]} in channel #{req["channel_name"]}")

    Tamnoon.Methods.unsub(%{"channel" => "queue"}, state)
    Tamnoon.Methods.sub(%{"channel" => req["channel_name"]}, state)

    sender = req["sender"]
    self_pid = inspect(self())

    switch_page_action =
      TamnoonTtt.Utils.PageManagement.switch_page_action("pages/game_page.html.heex")

    if sender == self_pid do
      {%{
         player_symbol: "X",
         # Force the other_player_name diff so it gets injected into the new page
         other_player_name: state[:other_player_name]
       }, [switch_page_action]}
    else
      other_player_name = req["other_player_name"]

      new_state =
        state
        |> Map.put(:player_symbol, "O")
        |> Map.put(:other_player_name, other_player_name)

      Tamnoon.Methods.pub(
        %{
          "channel" => req["channel_name"],
          "action" => %{
            "method" => "start_turn",
            "player" => "X"
          }
        },
        new_state
      )

      {%{player_symbol: "O", other_player_name: other_player_name},
       [switch_page_action]}
    end
  end
end
